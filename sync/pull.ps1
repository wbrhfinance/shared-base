# pull.ps1 - unified C:\Code sync for all of William's machines.
# Single source of truth: C:\Code\shared-base\sync\repos.json (this repo).
# shared-base is synced FIRST, so script and repo-list updates propagate to
# every machine automatically on its next run. No more copy-pasting scripts.
#
# Modes (set per repo in repos.json):
#   sync = auto-commit local edits, pull --rebase, push   (knowledge repos)
#   pull = git pull --ff-only; never touches local edits  (code repos)
#
# Logs:   C:\Code\bin\pull.log         (rolling, auto-trimmed)
# Status: C:\Code\bin\last-status.txt  (one line per repo, last run only)
#
# Compatible with Windows PowerShell 5.1. Runs as the logged-in user and
# inherits Git Credential Manager credentials. ASCII only, on purpose.

$ErrorActionPreference = 'Continue'
$Root       = 'C:\Code'
$BinDir     = Join-Path $Root 'bin'
$Log        = Join-Path $BinDir 'pull.log'
$StatusFile = Join-Path $BinDir 'last-status.txt'
$RepoConfig = Join-Path $Root 'shared-base\sync\repos.json'

if (-not (Test-Path $BinDir)) { New-Item -ItemType Directory -Path $BinDir -Force | Out-Null }

# --- log rotation: keep the file under ~512 KB ---
if ((Test-Path $Log) -and ((Get-Item $Log).Length -gt 524288)) {
    $tail = Get-Content $Log -Tail 800
    Set-Content -Path $Log -Value $tail -Encoding UTF8
}

function Write-Log([string]$m) { Add-Content -Path $Log -Value $m -Encoding UTF8 }

$script:results = @()
function Record([string]$state, [string]$repo, [string]$detail) {
    $line = "[$state] $repo"
    if ($detail) { $line += " ($detail)" }
    Write-Log $line
    $script:results += [pscustomobject]@{ State = $state; Repo = $repo; Detail = $detail }
}

# Splits porcelain status into tracked modifications vs untracked files.
# Untracked junk must never block a pull (the old script's biggest flaw).
function Get-Changes([string]$path) {
    $out = git -C $path status --porcelain 2>$null
    $tracked = @(); $untracked = @()
    foreach ($l in @($out)) {
        if (-not $l) { continue }
        if ($l -match '^\?\?') { $untracked += $l } else { $tracked += $l }
    }
    return @{ Tracked = $tracked; Untracked = $untracked }
}

function Sync-Repo($r) {
    $path = Join-Path $Root $r.path
    $name = $r.path

    # missing on this machine -> clone it (keeps machines converged)
    if (-not (Test-Path $path)) {
        if ($r.url) {
            Write-Log "[CLONE] $name from $($r.url)"
            git clone $r.url $path 2>&1 | ForEach-Object { Write-Log "        $_" }
            if ($LASTEXITCODE -ne 0) { Record 'FAIL' $name 'clone failed'; return }
            Record 'CLONED' $name ''
        } else {
            Record 'MISSING' $name 'path absent and no url set in repos.json'
        }
        return
    }

    # stale lock left by a crashed git process older than 1h -> clear it
    $lock = Join-Path $path '.git\index.lock'
    if (Test-Path $lock) {
        $age = (Get-Date) - (Get-Item $lock).LastWriteTime
        if ($age.TotalHours -gt 1) {
            Remove-Item $lock -Force -ErrorAction SilentlyContinue
            Write-Log "[UNLOCK] $name (removed stale index.lock)"
        } else {
            Record 'LOCKED' $name 'index.lock is fresh; another git may be running'
            return
        }
    }

    # self-healing remote: enforce the URL from repos.json
    if ($r.url) {
        $cur = git -C $path remote get-url origin 2>$null
        if ($cur -and ("$cur".Trim() -ne $r.url)) {
            git -C $path remote set-url origin $r.url
            Write-Log "[REMOTE] $name -> $($r.url)"
        }
    }

    $ch = Get-Changes $path

    if ($r.mode -eq 'sync') {
        $didCommit = $false
        if (($ch.Tracked.Count + $ch.Untracked.Count) -gt 0) {
            git -C $path add -A 2>&1 | Out-Null
            $msg = "auto-sync: $env:COMPUTERNAME $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
            git -C $path commit -m $msg 2>&1 | Out-Null
            if ($LASTEXITCODE -eq 0) {
                $didCommit = $true
                Write-Log "[COMMIT] $name ($($ch.Tracked.Count + $ch.Untracked.Count) change(s))"
            }
        }
        $pull = git -C $path pull --rebase 2>&1
        if ($LASTEXITCODE -ne 0) {
            git -C $path rebase --abort 2>$null
            Record 'CONFLICT' $name 'pull --rebase failed and was aborted; resolve manually'
            $pull | ForEach-Object { Write-Log "        $_" }
            return
        }
        $push = git -C $path push 2>&1
        if ($LASTEXITCODE -ne 0) {
            Record 'PUSHFAIL' $name 'commit is local only; check access/network'
            $push | ForEach-Object { Write-Log "        $_" }
            return
        }
        if ($didCommit -or ("$pull" -notmatch 'up to date')) { Record 'SYNCED' $name '' }
        else { Record 'OK' $name 'no changes' }
    }
    else {
        if ($ch.Tracked.Count -gt 0) {
            git -C $path fetch 2>&1 | Out-Null
            $behind = git -C $path rev-list --count 'HEAD..@{u}' 2>$null
            Record 'DIRTY' $name "local edits, pull skipped; behind origin by $behind commit(s)"
            return
        }
        $pull = git -C $path pull --ff-only 2>&1
        if ($LASTEXITCODE -ne 0) {
            Record 'FAIL' $name "exit $LASTEXITCODE"
            $pull | ForEach-Object { Write-Log "        $_" }
            return
        }
        if ("$pull" -match 'up to date') { Record 'OK' $name 'no changes' }
        else {
            Record 'PULL' $name ''
            $pull | ForEach-Object { Write-Log "        $_" }
        }
    }
}

Write-Log ''
Write-Log "=== Run: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') on $env:COMPUTERNAME ==="

# 1. shared-base first - it carries this script and repos.json
Sync-Repo ([pscustomobject]@{
    path = 'shared-base'
    url  = 'https://github.com/wbrhfinance/shared-base.git'
    mode = 'sync'
})

# 2. everything else, from the (possibly just-updated) repos.json
if (-not (Test-Path $RepoConfig)) {
    Write-Log '[FATAL] repos.json not found - only shared-base was synced'
} else {
    $cfg = Get-Content $RepoConfig -Raw | ConvertFrom-Json
    foreach ($r in $cfg.repos) {
        if ($r.path -eq 'shared-base') { continue }
        Sync-Repo $r
    }
}

# 3. summary
$bad = @($script:results | Where-Object { $_.State -in @('FAIL','CONFLICT','PUSHFAIL','MISSING','DIRTY','LOCKED') })
Write-Log "=== End: $($script:results.Count) repos, $($bad.Count) need attention ==="

$lines = @("Last run: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') on $env:COMPUTERNAME")
$lines += $script:results | ForEach-Object { ("[$($_.State)] $($_.Repo) $($_.Detail)").TrimEnd() }
Set-Content -Path $StatusFile -Value $lines -Encoding UTF8

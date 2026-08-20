# bootstrap.ps1 - one-time setup per machine. Safe to re-run (idempotent).
# Run interactively in PowerShell:
#   powershell -NoProfile -ExecutionPolicy Bypass -File C:\Code\shared-base\sync\bootstrap.ps1
#
# What it does:
#   1. clears stale .git\index.lock files
#   2. removes the legacy nested shared-base\bin folder
#   3. retires the old daily-pull.ps1 (renamed, scheduled tasks disabled)
#   4. moves Tokens work product out of the repo (only where OneDrive exists)
#   5. resolves dead CapeCapitalDev remotes by probing candidate URLs,
#      writes the verified URL back into repos.json
#   6. registers the CodeSync scheduled tasks (09:00 and 15:00 daily)
#   7. runs the first sync and prints the status
#
# ASCII only, on purpose: PowerShell 5.1 misreads BOM-less UTF-8.

$ErrorActionPreference = 'Continue'
$Root       = 'C:\Code'
$SharedBase = Join-Path $Root 'shared-base'
$SyncDir    = Join-Path $SharedBase 'sync'
$PullScript = Join-Path $SyncDir 'pull.ps1'
$RepoConfig = Join-Path $SyncDir 'repos.json'

Write-Host "== C:\Code sync bootstrap on $env:COMPUTERNAME =="

if (-not (Test-Path $RepoConfig)) {
    Write-Host "repos.json not found at $RepoConfig - pull shared-base first: cd C:\Code\shared-base, then git pull"
    exit 1
}
if (Get-Process git -ErrorAction SilentlyContinue) {
    Write-Host 'git.exe is currently running - close it and re-run bootstrap.'
    exit 1
}

$cfg = Get-Content $RepoConfig -Raw | ConvertFrom-Json

# --- 1. stale lock files ---
foreach ($r in $cfg.repos) {
    $lock = Join-Path $Root ($r.path + '\.git\index.lock')
    if (Test-Path $lock) {
        Remove-Item $lock -Force
        Write-Host "removed stale lock: $($r.path)"
    }
}

# --- 2. legacy nested bin inside shared-base ---
$nested = Join-Path $SharedBase 'bin'
if (Test-Path $nested) {
    Remove-Item $nested -Recurse -Force
    Write-Host 'removed legacy shared-base\bin'
}

# --- 3. retire the old script and its scheduled tasks ---
$oldScript = Join-Path $Root 'bin\daily-pull.ps1'
if (Test-Path $oldScript) {
    Move-Item $oldScript "$oldScript.retired" -Force
    Write-Host 'renamed old bin\daily-pull.ps1 -> daily-pull.ps1.retired'
}
Get-ScheduledTask -ErrorAction SilentlyContinue | ForEach-Object {
    $hit = $_.Actions | Where-Object {
        ("$($_.Execute)" -match 'daily-pull') -or ("$($_.Arguments)" -match 'daily-pull')
    }
    if ($hit) {
        Disable-ScheduledTask -TaskName $_.TaskName -TaskPath $_.TaskPath -ErrorAction SilentlyContinue | Out-Null
        Write-Host "disabled old scheduled task: $($_.TaskName)"
    }
}

# --- 4. Tokens work product out of the repo ---
$skillDir = Join-Path $SharedBase 'skills\dual-engine-research\Single topic research'
$destBase = 'C:\Users\willi\OneDrive\Business\Cape Capital\Themes'
$dest     = Join-Path $destBase 'Tokens'
$tokenFiles = @(Get-ChildItem -Path $skillDir -Filter 'Tokens_*' -File -ErrorAction SilentlyContinue)
if ($tokenFiles.Count -gt 0) {
    if (Test-Path $destBase) {
        if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Path $dest -Force | Out-Null }
        $tokenFiles | Move-Item -Destination $dest -Force
        Write-Host "moved $($tokenFiles.Count) Tokens file(s) to $dest"
        git -C $SharedBase add -A 2>&1 | Out-Null
        git -C $SharedBase commit -m 'Move Tokens work product out of repo (to OneDrive Themes)' 2>&1 | Out-Null
        Write-Host 'committed removal in shared-base (pushed by the first sync below)'
    } else {
        Write-Host 'OneDrive Themes path not found on this machine - leaving Tokens files; their removal will arrive via git once done on the main PC.'
    }
}

# --- 5. resolve unverified remotes (dead CapeCapitalDev org) ---
$updated = $false
foreach ($r in $cfg.repos) {
    if ($r.url) { continue }
    if (-not $r.candidates) { continue }
    $path = Join-Path $Root $r.path
    if (-not (Test-Path $path)) { Write-Host "$($r.path): not on this machine, skipping remote probe"; continue }
    $resolved = $false
    foreach ($cand in $r.candidates) {
        git ls-remote --exit-code $cand HEAD *> $null
        if ($LASTEXITCODE -ne 0) { continue }
        git -C $path fetch $cand *> $null
        git -C $path merge-base --is-ancestor HEAD FETCH_HEAD *> $null
        $related = ($LASTEXITCODE -eq 0)
        if (-not $related) {
            git -C $path merge-base --is-ancestor FETCH_HEAD HEAD *> $null
            $related = ($LASTEXITCODE -eq 0)
        }
        if ($related) {
            git -C $path remote set-url origin $cand
            $r.url = $cand
            $updated = $true
            $resolved = $true
            Write-Host "$($r.path): remote verified and set -> $cand"
        } else {
            Write-Host "$($r.path): $cand is reachable but its history does not match this folder - check manually."
        }
        break
    }
    if (-not $resolved -and -not $r.url) {
        Write-Host "$($r.path): no candidate URL worked - open github.com and fix 'url' in sync\repos.json"
    }
}
if ($updated) {
    ($cfg | ConvertTo-Json -Depth 6) | Set-Content -Path $RepoConfig -Encoding UTF8
    git -C $SharedBase add sync/repos.json 2>&1 | Out-Null
    git -C $SharedBase commit -m 'Resolve repo remote URLs in repos.json' 2>&1 | Out-Null
    Write-Host 'updated repos.json committed (pushed by the first sync below)'
}

# --- 6. scheduled tasks ---
$action = "powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"$PullScript`""
schtasks /Create /F /TN 'CodeSync-AM' /TR $action /SC DAILY /ST 09:00 | Out-Null
schtasks /Create /F /TN 'CodeSync-PM' /TR $action /SC DAILY /ST 15:00 | Out-Null
Write-Host 'scheduled tasks registered: CodeSync-AM (09:00) and CodeSync-PM (15:00) daily.'
schtasks /Create /F /TN 'CodeSync-Logon' /TR $action /SC ONLOGON 2>$null | Out-Null
if ($LASTEXITCODE -eq 0) { Write-Host 'bonus: CodeSync-Logon registered (runs at every logon).' }
else { Write-Host 'note: logon trigger needs admin rights; skipped. The two daily tasks are enough.' }

# --- 7. first sync ---
Write-Host ''
Write-Host 'running first sync...'
& powershell.exe -NoProfile -ExecutionPolicy Bypass -File $PullScript
Write-Host ''
Get-Content (Join-Path $Root 'bin\last-status.txt') | Write-Host
Write-Host ''
Write-Host '== bootstrap complete =='

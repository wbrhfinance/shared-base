# daily-pull.ps1
# Fast-forward pulls of core repos.
# Skips repos with uncommitted changes. Logs every run to pull.log.
# Runs as the logged-in user, so it inherits the Git Credential Manager
# entry stored in Windows Credential Manager.

$ErrorActionPreference = 'Continue'

$repos = @(
    'C:\Code\shared-base',
    'C:\Code\cape\cape-toolbox',
    'C:\Code\cape\Moonshot',
    'C:\Code\cape\cape_blank',
    'C:\Code\brh\brh-toolbox',
    'C:\Code\brh\wbr-market-dashboard',
    'C:\Code\brh\brh-finance-website',
    'C:\Code\brh\brh-finance-february'
    # Gauges excluded: active feature branches; pull manually.
)

$logFile  = 'C:\Code\bin\pull.log'
$timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

function Write-Log {
    param([string]$Message)
    Add-Content -Path $logFile -Value $Message -Encoding UTF8
}

Write-Log ''
Write-Log "=== Run: $timestamp ==="

foreach ($repo in $repos) {
    if (-not (Test-Path $repo)) {
        Write-Log "[SKIP] $repo (path does not exist)"
        continue
    }

    Push-Location $repo
    try {
        $status = git status --porcelain 2>&1
        if ($status) {
            Write-Log "[SKIP] $repo (uncommitted changes)"
            continue
        }

        $pullOutput = git pull --ff-only 2>&1
        $exitCode   = $LASTEXITCODE

        if ($exitCode -eq 0) {
            if ($pullOutput -match 'Already up to date') {
                Write-Log "[OK]   $repo (no changes)"
            } else {
                Write-Log "[PULL] $repo"
                $pullOutput | ForEach-Object { Write-Log "   
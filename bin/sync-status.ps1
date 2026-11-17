# sync-status.ps1
# One-glance report: which repos are dirty, which are ahead/behind GitHub.
# Read-only. Run any time, especially before switching machines.

$ErrorActionPreference = 'Continue'

$repos = @(
    'C:\Code\shared-base',
    'C:\Code\cape\cape-toolbox',
    'C:\Code\cape\Gauges',
    'C:\Code\cape\Moonshot',
    'C:\Code\cape\cape_blank',
    'C:\Code\brh\brh-toolbox',
    'C:\Code\brh\wbr-market-dashboard',
    'C:\Code\brh\brh-finance-website',
    'C:\Code\brh\brh-finance-february'
)

Write-Host ""
Write-Host ("{0,-45} {1,-18} {2,-8} {3}" -f 'Repo', 'Branch', 'Dirty', 'vs GitHub') -ForegroundColor Cyan
Write-Host ('-' * 95)

foreach ($repo in $repos) {
    if (-not (Test-Path $repo)) {
        Write-Host ("{0,-45} MISSING" -f $repo) -ForegroundColor Red
        continue
    }

    Push-Location $repo
    try {
        git fetch --quiet 2>$null

        $branch = git rev-parse --abbrev-ref HEAD 2>$null
        $dirty  = if (git status --porcelain 2>$null) { 'YES' } else { '-' }

        $upstream = git rev-parse --abbrev-ref '@{upstream}' 2>$null
        if ($LASTEXITCODE -eq 0) {
            $counts = git rev-list --left-right --count "$upstream...HEAD" 2>$null
            $behind, $ahead = $counts -split '\s+'
            $vs = @()
            if ([int]$ahead -gt 0)  { $vs += "$ahead to push" }
            if ([int]$behind -gt 0) { $vs += "$behind to pull" }
            if (-not $vs) { $vs = @('in sync') }
            $vsText = $vs -join ', '
        } else {
            $vsText = 'NO UPSTREAM (never pushed)'
        }

        $color = 'Green'
        if ($dirty -eq 'YES' -or $vsText -ne 'in sync') { $color = 'Yellow' }
        if ($vsText -like 'NO UPSTREAM*') { $color = 'Red' }

        Write-Host ("{0,-45} {1,-18} {2,-8} {3}" -f $repo.Replace('C:\Code\',''), $branch, $dirty, $vsText) -ForegroundColor $color
    } finally {
        Pop-Location
    }
}

Write-Host ""
Write-Host "Dirty = uncommitted changes. 'to push' = commits GitHub does not have yet." -ForegroundColor DarkGray

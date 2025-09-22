# Revision : 1.0
# Description : Runs once-per-day scheduled tasks including Security Now! transcript fetch, file compare, and git sync; maintains daily run stamp file
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-09-22
# Modified Date : 2025-09-22

# Assumes $githubpath is set elsewhere in your $PROFILE
$stateRoot = Join-Path $githubpath "Daily Run Status"
$stampFile = Join-Path $stateRoot "daily-run.txt"
$today     = Get-Date -Format 'yyyy-MM-dd'

if (-not (Test-Path $stateRoot)) {
    New-Item -ItemType Directory -Path $stateRoot -Force | Out-Null
}

# Read last-run date: find the first line that matches YYYY-MM-DD
$last = $null
if (Test-Path $stampFile) {
    $lines = Get-Content -Path $stampFile -ErrorAction SilentlyContinue
    foreach ($line in $lines) {
        $t = $line.Trim()
        if ($t -match '^\d{4}-\d{2}-\d{2}$') { $last = $t; break }
    }
}

# Helper: locked write of header + date (prevents races)
function Set-DailyStamp {
    param([string] $Path, [string] $Date)

    $contentLines = @('#DO NOT CHANGE THIS FILE', $Date)

    $dir = Split-Path $Path -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }

    $fs = [System.IO.File]::Open($Path,
        [System.IO.FileMode]::OpenOrCreate,
        [System.IO.FileAccess]::ReadWrite,
        [System.IO.FileShare]::None)
    try {
        $text  = ($contentLines -join [Environment]::NewLine) + [Environment]::NewLine
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($text)
        $fs.SetLength(0); $fs.Write($bytes,0,$bytes.Length); $fs.Flush()
    } finally { $fs.Dispose() }
}

# --- Only run once per calendar day ---
if ($last -ne $today) {

    # ===== Your once-per-day steps =====
    try {
        # 1) Security Now! fetch
        & "$githubpath\PowerShell\GRC-TWIT-SecurityNow-Transcripts\download-next-security-now-txt-transcriptions-and-pdf-show-notes-from-grc_com.ps1"

        # 2) File compare + CSV diff
        # & 'path\other-file.ps1'

        # 3) Git sync function
        # another-function

        # ✅ Only stamp AFTER all above attempted
        Set-DailyStamp -Path $stampFile -Date $today
        Write-Host "Daily tasks complete : stamped $today" -ForegroundColor Green
    }
    catch {
        Write-Warning "Daily tasks failed : $($_.Exception.Message)"
        # No stamp on failure -> will try again next session
    }
}
else {
    Write-Host "Daily tasks already stamped for $today : skipping" -ForegroundColor Yellow
}

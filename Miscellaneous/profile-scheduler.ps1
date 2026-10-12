# Filename: profile-scheduler.ps1
# Revision : 2.1.0
# Description : Runs scripts on per-script intervals based on each script's own last run time
# Author : Jason Lamb (with help from Claude Code)
# Created Date : 2026-04-01
# Modified Date : 2026-05-14
# Changelog :
# 1.0.0 initial release
# 1.1.0 added per-script last run tracking to state JSON
# 1.1.1 added Security Now transcript/PDF downloader to weekly tasks
# 2.0.0 switched from shared block timestamps to per-script interval tracking
# 2.1.0 added run/skip status output with time-remaining at session start

$schedulerStatePath = "$psexports\profile-scheduler-state.json"

# Load or initialize state
if (Test-Path $schedulerStatePath) {
    $stateRaw = Get-Content $schedulerStatePath | ConvertFrom-Json
    $scriptState = @{}
    if ($stateRaw.Scripts) {
        $stateRaw.Scripts.PSObject.Properties | ForEach-Object {
            $scriptState[$_.Name] = $_.Value
        }
    }
} else {
    $scriptState = @{}
}

$now = Get-Date
$stateChanged = $false

function Should-RunScript {
    param([string]$Key, [string]$Interval)
    $lastRun = if ($scriptState.ContainsKey($Key)) { [DateTime]$scriptState[$Key].LastRun } else { [DateTime]::MinValue }
    switch ($Interval) {
        'Daily'   { return $lastRun.Date -lt $now.Date }
        'Weekly'  { return ($now - $lastRun).TotalHours -ge 168 }
        'Monthly' { return ($now - $lastRun).TotalDays -ge 30 }
    }
}

function Get-TimeRemaining {
    param([string]$Key, [string]$Interval)
    $lastRun = if ($scriptState.ContainsKey($Key)) { [DateTime]$scriptState[$Key].LastRun } else { [DateTime]::MinValue }
    $nextRun = switch ($Interval) {
        'Daily'   { $lastRun.Date.AddDays(1) }
        'Weekly'  { $lastRun.AddHours(168) }
        'Monthly' { $lastRun.AddDays(30) }
    }
    $remaining = $nextRun - $now
    if ($remaining.TotalDays -ge 1) {
        "$([int]$remaining.TotalDays)d $($remaining.Hours)h left"
    } elseif ($remaining.TotalHours -ge 1) {
        "$([int]$remaining.TotalHours)h $($remaining.Minutes)m left"
    } else {
        "$([int]$remaining.TotalMinutes)m left"
    }
}

Write-Host "`nScheduler:" -ForegroundColor Cyan

####################
# Daily scripts
####################
if (Should-RunScript 'check-choco-updates' 'Daily') {
    Write-Host "  [RAN]  check-choco-updates (Daily)" -ForegroundColor Green
    . 'C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\Documents\Github\powershell\Miscellaneous\check-choco-updates.ps1'
    $scriptState['check-choco-updates'] = [PSCustomObject]@{ LastRun = $now.ToString('o'); Interval = 'Daily' }
    $stateChanged = $true
} else {
    Write-Host "  [SKIP] check-choco-updates (Daily) — $(Get-TimeRemaining 'check-choco-updates' 'Daily')" -ForegroundColor DarkGray
}

# Long-running network scan: launched in its own minimized window so it doesn't block this session.
# -NoProfile is required, otherwise the new window would load this profile and re-run the scheduler.
# Gated on a run that actually FINISHED today (script's run log), not on launch time, so a reboot or
# hung run gets retried by the next session; skipped while a scan window is already open.
$sharedFolderGrowthScript = "$env:OneDrive\Documents\Github\powershell-private\altronic-scripts\Get-AltronicSharedFolderGrowth.ps1"
$sharedFolderGrowthRunLog = "$env:OneDrive\powershell-exports\shared-folder-growth\SharedFolderRunLog.csv"
$sharedFolderGrowthDoneToday = $null
if (Test-Path -LiteralPath $sharedFolderGrowthRunLog) {
    $sharedFolderGrowthDoneToday = Import-Csv -LiteralPath $sharedFolderGrowthRunLog |
        Where-Object { ([datetime]$_.RunEnd).Date -eq $now.Date } | Select-Object -Last 1
}
$sharedFolderGrowthRunning = Get-CimInstance Win32_Process -Filter "Name='pwsh.exe'" -ErrorAction SilentlyContinue |
    Where-Object CommandLine -like '*Get-AltronicSharedFolderGrowth.ps1*' | Select-Object -First 1

if ($sharedFolderGrowthDoneToday) {
    Write-Host "  [SKIP] shared-folder-growth (Daily) — finished today at $(([datetime]$sharedFolderGrowthDoneToday.RunEnd).ToString('HH:mm')) (took $($sharedFolderGrowthDoneToday.Duration))" -ForegroundColor DarkGray
} elseif ($sharedFolderGrowthRunning) {
    Write-Host "  [SKIP] shared-folder-growth (Daily) — already running since $($sharedFolderGrowthRunning.CreationDate.ToString('MM-dd HH:mm')) (PID $($sharedFolderGrowthRunning.ProcessId))" -ForegroundColor Yellow
} else {
    Write-Host "  [RAN]  shared-folder-growth (Daily) — started in a separate minimized window" -ForegroundColor Green
    Start-Process -FilePath 'pwsh.exe' -WindowStyle Minimized -ArgumentList @(
        '-NoProfile', '-NoExit', '-ExecutionPolicy', 'Bypass', '-File', "`"$sharedFolderGrowthScript`""
    )
    $scriptState['shared-folder-growth'] = [PSCustomObject]@{ LastRun = $now.ToString('o'); Interval = 'Daily' }
    $stateChanged = $true
}

####################
# Weekly scripts
####################
if (Should-RunScript 'check-powershell-update' 'Weekly') {
    Write-Host "  [RAN]  check-powershell-update (Weekly)" -ForegroundColor Green
    . 'C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\Documents\Github\powershell\Miscellaneous\check-powershell-update.ps1'
    $scriptState['check-powershell-update'] = [PSCustomObject]@{ LastRun = $now.ToString('o'); Interval = 'Weekly' }
    $stateChanged = $true
} else {
    Write-Host "  [SKIP] check-powershell-update (Weekly) — $(Get-TimeRemaining 'check-powershell-update' 'Weekly')" -ForegroundColor DarkGray
}

if (Should-RunScript 'download-next-security-now-txt-transcriptions-and-pdf-show-notes-from-grc_com' 'Weekly') {
    Write-Host "  [RAN]  security-now-download (Weekly)" -ForegroundColor Green
    . 'C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\Documents\Github\powershell\GRC-TWIT-SecurityNow-Transcripts\download-next-security-now-txt-transcriptions-and-pdf-show-notes-from-grc_com.ps1'
    $scriptState['download-next-security-now-txt-transcriptions-and-pdf-show-notes-from-grc_com'] = [PSCustomObject]@{ LastRun = $now.ToString('o'); Interval = 'Weekly' }
    $stateChanged = $true
} else {
    Write-Host "  [SKIP] security-now-download (Weekly) — $(Get-TimeRemaining 'download-next-security-now-txt-transcriptions-and-pdf-show-notes-from-grc_com' 'Weekly')" -ForegroundColor DarkGray
}

if (Should-RunScript 'm365-version-update-download' 'Weekly') {
    Write-Host "  [RAN]  m365-version-update-download (Weekly)" -ForegroundColor Green
    & 'C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\Documents\Github\powershell\File-Management-Scripts\m365-version-update-download.ps1' -Force
    $scriptState['m365-version-update-download'] = [PSCustomObject]@{ LastRun = $now.ToString('o'); Interval = 'Weekly' }
    $stateChanged = $true
} else {
    Write-Host "  [SKIP] m365-version-update-download (Weekly) — $(Get-TimeRemaining 'm365-version-update-download' 'Weekly')" -ForegroundColor DarkGray
}

if ((Should-RunScript 'move-s-it-public-to-g-it' 'Weekly') -and $now.DayOfWeek -eq 'Monday') {
    Write-Host "  [RAN]  move-s-it-public-to-g-it (Weekly, Monday)" -ForegroundColor Green
    . 'C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\Documents\Github\powershell\File-Management-Scripts\move-s-it-public-to-g-it.ps1'
    $scriptState['move-s-it-public-to-g-it'] = [PSCustomObject]@{ LastRun = $now.ToString('o'); Interval = 'Weekly' }
    $stateChanged = $true
} else {
    $dayCheck = if ($now.DayOfWeek -ne 'Monday') { "(runs Monday only)" } else { "" }
    Write-Host "  [SKIP] move-s-it-public-to-g-it (Weekly) — $(Get-TimeRemaining 'move-s-it-public-to-g-it' 'Weekly') $dayCheck" -ForegroundColor DarkGray
}

####################
# Monthly scripts
####################
# Add monthly scripts here

####################
# Save state
####################
if ($stateChanged) {
    [PSCustomObject]@{
        Scripts = $scriptState
    } | ConvertTo-Json -Depth 3 | Set-Content $schedulerStatePath
}

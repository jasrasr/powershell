# Filename: profile-scheduler.ps1
# Revision : 2.0.0
# Description : Runs scripts on per-script intervals based on each script's own last run time
# Author : Jason Lamb (with help from Claude Code)
# Created Date : 2026-04-01
# Modified Date : 2026-05-01
# Changelog :
# 1.0.0 initial release
# 1.1.0 added per-script last run tracking to state JSON
# 1.1.1 added Security Now transcript/PDF downloader to weekly tasks
# 2.0.0 switched from shared block timestamps to per-script interval tracking

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
        'Daily'   { return ($now - $lastRun).TotalHours -ge 24 }
        'Weekly'  { return ($now - $lastRun).TotalHours -ge 168 }
        'Monthly' { return ($now - $lastRun).TotalDays -ge 30 }
    }
}

####################
# Daily scripts
####################
if (Should-RunScript 'check-choco-updates' 'Daily') {
    . 'C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\Documents\Github\powershell\Miscellaneous\check-choco-updates.ps1'
    $scriptState['check-choco-updates'] = [PSCustomObject]@{ LastRun = $now.ToString('o'); Interval = 'Daily' }
    $stateChanged = $true
}

####################
# Weekly scripts
####################
if (Should-RunScript 'check-powershell-update' 'Weekly') {
    . 'C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\Documents\Github\powershell\Miscellaneous\check-powershell-update.ps1'
    $scriptState['check-powershell-update'] = [PSCustomObject]@{ LastRun = $now.ToString('o'); Interval = 'Weekly' }
    $stateChanged = $true
}

if (Should-RunScript 'download-next-security-now-txt-transcriptions-and-pdf-show-notes-from-grc_com' 'Weekly') {
    . 'C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\Documents\Github\powershell\GRC-TWIT-SecurityNow-Transcripts\download-next-security-now-txt-transcriptions-and-pdf-show-notes-from-grc_com.ps1'
    $scriptState['download-next-security-now-txt-transcriptions-and-pdf-show-notes-from-grc_com'] = [PSCustomObject]@{ LastRun = $now.ToString('o'); Interval = 'Weekly' }
    $stateChanged = $true
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

# Filename: profile-scheduler.ps1
# Revision : 1.1.0
# Description : Runs scripts on daily/weekly/monthly intervals based on elapsed time since last run
# Author : Jason Lamb (with help from Claude Code)
# Created Date : 2026-04-01
# Modified Date : 2026-04-24
# Changelog :
# 1.0.0 initial release
# 1.1.0 added per-script last run tracking to state JSON

$schedulerStatePath = "$psexports\profile-scheduler-state.json"

# Load or initialize state
if (Test-Path $schedulerStatePath) {
    $stateRaw    = Get-Content $schedulerStatePath | ConvertFrom-Json
    $lastDaily   = [DateTime]$stateRaw.LastDaily
    $lastWeekly  = [DateTime]$stateRaw.LastWeekly
    $lastMonthly = [DateTime]$stateRaw.LastMonthly
    $scriptState = @{}
    if ($stateRaw.Scripts) {
        $stateRaw.Scripts.PSObject.Properties | ForEach-Object {
            $scriptState[$_.Name] = $_.Value
        }
    }
} else {
    $lastDaily = $lastWeekly = $lastMonthly = [DateTime]::MinValue
    $scriptState = @{}
}

$now = Get-Date
$stateChanged = $false

####################
# Daily - every 24 hours
####################
if (($now - $lastDaily).TotalHours -ge 24) {

    . 'C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\Documents\Github\powershell\Miscellaneous\check-choco-updates.ps1'
    $scriptState['check-choco-updates'] = [PSCustomObject]@{ LastRun = $now.ToString('o'); Interval = 'Daily' }

    $lastDaily = $now
    $stateChanged = $true
}

####################
# Weekly - every 168 hours
####################
if (($now - $lastWeekly).TotalHours -ge 168) {

    . 'C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\Documents\Github\powershell\Miscellaneous\check-powershell-update.ps1'
    $scriptState['check-powershell-update'] = [PSCustomObject]@{ LastRun = $now.ToString('o'); Interval = 'Weekly' }

    $lastWeekly = $now
    $stateChanged = $true
}

####################
# Monthly - every 30 days
####################
if (($now - $lastMonthly).TotalDays -ge 30) {

    # Add monthly scripts here

    $lastMonthly = $now
    $stateChanged = $true
}

if ($stateChanged) {
    [PSCustomObject]@{
        LastDaily   = $lastDaily.ToString('o')
        LastWeekly  = $lastWeekly.ToString('o')
        LastMonthly = $lastMonthly.ToString('o')
        Scripts     = $scriptState
    } | ConvertTo-Json -Depth 3 | Set-Content $schedulerStatePath
}

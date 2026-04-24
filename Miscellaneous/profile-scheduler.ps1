# profile-scheduler.ps1
# Runs scripts on daily/weekly/monthly intervals based on elapsed time since last run
# Intervals: 24 hours (daily), 168 hours (weekly), 30 days (monthly)
# Revision 1.0 | Author: Jason Lamb with help from Claude

$schedulerStatePath = "$psexports\profile-scheduler-state.json"

# Load or initialize state
if (Test-Path $schedulerStatePath) {
    $state = Get-Content $schedulerStatePath | ConvertFrom-Json
    $lastDaily   = [DateTime]$state.LastDaily
    $lastWeekly  = [DateTime]$state.LastWeekly
    $lastMonthly = [DateTime]$state.LastMonthly
} else {
    $lastDaily = $lastWeekly = $lastMonthly = [DateTime]::MinValue
}

$now = Get-Date
$stateChanged = $false

####################
# Daily - every 24 hours
####################
if (($now - $lastDaily).TotalHours -ge 24) {

    . 'C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\Documents\Github\powershell\Miscellaneous\check-choco-updates.ps1'

    $lastDaily = $now
    $stateChanged = $true
}

####################
# Weekly - every 168 hours
####################
if (($now - $lastWeekly).TotalHours -ge 168) {

    . 'C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\Documents\Github\powershell\Miscellaneous\check-powershell-update.ps1'

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
    } | ConvertTo-Json | Set-Content $schedulerStatePath
}

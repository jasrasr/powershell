# Define the Event IDs for account disabled and enabled
$eventIDs = @(4725, 4722)

# Define the time range for the log query
$startTime = (Get-Date).AddDays(-30) # Last 30 days
$endTime = Get-Date

# Search the Security Event Log on the Domain Controller
Get-WinEvent -FilterHashtable @{
    LogName = 'Security'
    ID = $eventIDs
    StartTime = $startTime
    EndTime = $endTime
} | ForEach-Object {
    $event = [xml]$_.ToXml()
    [PSCustomObject]@{
        TimeCreated   = $_.TimeCreated
        EventID       = $_.Id
        Action        = if ($_.Id -eq 4725) { 'Disabled' } else { 'Enabled' }
        UserAccount   = $event.Event.EventData.Data | Where-Object { $_.Name -eq 'TargetUserName' } | Select-Object -ExpandProperty '#text'
        AdminAccount  = $event.Event.EventData.Data | Where-Object { $_.Name -eq 'SubjectUserName' } | Select-Object -ExpandProperty '#text'
    }
} | Format-Table -AutoSize

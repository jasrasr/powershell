# script to get the active directory audit of taken on accounts by domain admins
# Author: Jason Lamb
# Date: 12/13/24
# Version: 1.0
# Description: This script will query the Security Event Log on a Domain Controller for events related to account creation, enabling, disabling, etc. It will then display the results in a table format.
# Usage: Run the script on a computer with the Active Directory PowerShell module installed. The script will query the Security Event Log on the Domain Controller for the last 7 days.
# Note: You may need to adjust the Event IDs and time range based on your environment.
# CURRENT: Define the script block to run on the remote computer

$scriptBlock = { # 1/3 lines to comment out or remove to run directly on the domain controller
    # Define the Event IDs for account disabled, enabled, created, etc.
    $eventIDs = @(4725, 4722, 4720, 4732, 4733, 5136, 4670, 4648, 4662, 4672)

    # Define the time range for the log query
    $startTime = (Get-Date).AddDays(-7) # Last 7 days
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
            Action        = switch ($_.Id) {
                4725 { 'Disabled' }
                4722 { 'Enabled' }
                4720 { 'Created' }
                4732 { 'Added to Group' }
                4733 { 'Removed from Group' }
                5136 { 'Modified' }
                4670 { 'Permissions Changed' }
                4648 { 'Logon Attempted' }
                4662 { 'Access Attempted' }
                4672 { 'Special Privileges Assigned' }
                #default { 'Unknown' }
            }
            UserAccount   = $event.Event.EventData.Data | Where-Object { $_.Name -eq 'TargetUserName' } | Select-Object -ExpandProperty '#text'
            AdminAccount  = $event.Event.EventData.Data | Where-Object { $_.Name -eq 'SubjectUserName' } | Select-Object -ExpandProperty '#text'
        }
    } | Format-Table -AutoSize
} # 2/3 lines to comment out or remove to run directly on the domain controller

Invoke-Command -ComputerName cledc1 -ScriptBlock $scriptBlock # 3/3 lines to comment out or remove to run directly on the domain controller

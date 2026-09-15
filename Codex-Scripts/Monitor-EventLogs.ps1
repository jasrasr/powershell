<#!
.SYNOPSIS
    Retrieves recent events from Windows event logs with filtering options.
.DESCRIPTION
    Monitor-EventLogs queries one or more Windows event logs and emits the newest entries
    within a user-specified time window. Use the parameters to scope the level and ID filters.
.PARAMETER LogName
    One or more log names to query. Defaults to the Application and System logs.
.PARAMETER HoursBack
    Limits the event search to entries newer than the provided number of hours.
.PARAMETER Level
    Filters by event severity level. Accepts Information, Warning, or Error.
.PARAMETER Id
    Optionally filters on specific event IDs.
.EXAMPLE
    .\\Monitor-EventLogs.ps1 -LogName Security -HoursBack 1 -Level Error
.EXAMPLE
    .\\Monitor-EventLogs.ps1 -Id 1000,1001
.NOTES
    Author: ChatGPT Automation
#>
[CmdletBinding()]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string[]]$LogName = @('Application','System'),

    [Parameter()]
    [ValidateRange(1,168)]
    [int]$HoursBack = 24,

    [Parameter()]
    [ValidateSet('Information','Warning','Error')]
    [string[]]$Level,

    [Parameter()]
    [int[]]$Id
)

$filter = @{
    LogName   = $LogName
    StartTime = (Get-Date).AddHours(-1 * $HoursBack)
}

if ($Level) {
    $filter['Level'] = foreach ($lvl in $Level) {
        switch ($lvl) {
            'Information' { 4 }
            'Warning'     { 3 }
            'Error'       { 2 }
        }
    }
}

if ($Id) {
    $filter['Id'] = $Id
}

Get-WinEvent -FilterHashtable $filter |
    Sort-Object TimeCreated |
    Select-Object TimeCreated, LogName, LevelDisplayName, Id, ProviderName, Message

# Revision : 1.1
# Description : Accept a date parameter or prompt for one; then compute days until or since that date
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-09-26
# Modified Date : 2025-09-26

<#
.SYNOPSIS
    Compute days until or since a provided date (via parameter or prompt).

.DESCRIPTION
    If a date is passed in as a parameter, the script uses it.
    If no date parameter is given, it prompts the user (Read-Host).
    It then compares that date to today:
      - If future, prints how many days until.
      - If past, prints how many days since.
      - If same as today, prints "today".

.PARAMETER TargetDate
    An optional date (string or DateTime). If omitted, user is prompted.

.EXAMPLE
    # Using parameter:
    PS> .\Calculate-Days.ps1 -TargetDate "10/15/2025"
    That date is 19 day(s) in the future.

    # No parameter, interactive:
    PS> .\Calculate-Days.ps1
    Enter a date (MM/dd/yyyy) [default: 09/26/2025]:
    That date is … etc.

.INPUTS
    None (the script doesn't accept pipeline input).

.OUTPUTS
    None (writes to console).

.NOTES
    Author      : Jason "Lambo" Lamb
    Version     : 1.1
    Created Date: 2025-09-26
    Modified Date: 2025-09-26

.LINK
    about_Comment_Based_Help
#>


# Two blank lines before code/functions

function Read-DateWithDefault {
    param(
        [string]$Prompt = 'Enter a date (MM/dd/yyyy)',
        [DateTime]$Default = (Get-Date).Date
    )

    do {
        $raw = Read-Host -Prompt ("$Prompt [default: $($Default.ToString('MM/dd/yyyy'))]")
        if ([string]::IsNullOrWhiteSpace($raw)) {
            $dt = $Default
            break
        }
        try {
            $dt = Get-Date -Date $raw -ErrorAction Stop
        }
        catch {
            Write-Host "'$raw' isn’t a valid date — try again." -ForegroundColor Yellow
            $dt = $null
        }
    } until ($dt)

    return $dt.Date
}

# Main logic

param(
    [Parameter(Mandatory = $false)]
    [DateTime]$TargetDate
)

# If no parameter supplied, prompt
if (-not $PSBoundParameters.ContainsKey('TargetDate')) {
    $TargetDate = Read-DateWithDefault -Prompt 'Enter a date (MM/dd/yyyy)'
}
else {
    # If parameter was passed, just take the date portion (ignore time)
    $TargetDate = $TargetDate.Date
}

$today = (Get-Date).Date

if ($TargetDate -gt $today) {
    $days = (New-TimeSpan -Start $today -End $TargetDate).Days
    Write-Host "⏳ That date is $days day(s) in the future."
}
elseif ($TargetDate -lt $today) {
    $days = (New-TimeSpan -Start $TargetDate -End $today).Days
    Write-Host "🕰 That date was $days day(s) ago."
}
else {
    Write-Host "📅 That date is today — 0 day(s)."
}

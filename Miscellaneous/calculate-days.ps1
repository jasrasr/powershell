<#
.SYNOPSIS
    Calculates how many days until—or since—a user-provided date, defaulting to today if blank.

.DESCRIPTION
    Prompts the user for a date. If the input is in the future, calculates days until that date.
    If the input is in the past, calculates days since that date. Defaults to today's date when no input
    is provided. Ignores time-of-day and focuses on full days.

.PARAMETER None
    Interactive script; no parameters are passed via command line.

.EXAMPLE
    PS> .\Calculate-Days.ps1
    Enter a date (MM/dd/yyyy) [default: 08/19/2025]:
    That date is 10 day(s) in the future.

.INPUTS
    None. This script does not accept pipeline input.

.OUTPUTS
    None. The script writes output only to the console.

.NOTES
    Author      : Jason "Lambo" Lamb, IT Manager & weekend woodworker
    Script Date : 2025-08-19
    Version     : 1.0

.LINK
    Documentation on Comment-Based Help: about_Comment_Based_Help
#>


# Two blank lines below to separate help block from code

function Read-DateWithDefault {
    param(
        [string]$Prompt = 'Enter a date (MM/dd/yyyy)',
        [DateTime]$Default = (Get-Date).Date
    )
    do {
        $raw = Read-Host -Prompt ("$Prompt (default: $($Default.ToString('MM/dd/yyyy')))")
        if ([string]::IsNullOrWhiteSpace($raw)) {
            $dt = $Default
            break
        }
        try {
            $dt = Get-Date -Date $raw -ErrorAction Stop
        }
        catch {
            Write-Host "'$raw' isn’t a valid date—try again, champ." -ForegroundColor Yellow
            $dt = $null
        }
    } until ($dt)
    return $dt.Date
}

$targetDate = Read-DateWithDefault -Prompt 'Gimme a date (MM/dd/yyyy)'
$today = (Get-Date).Date

if ($targetDate -gt $today) {
    $days = (New-TimeSpan -Start $today -End $targetDate).Days
    Write-Host "⏳ That date is $days day(s) in the future."
}
elseif ($targetDate -lt $today) {
    $days = (New-TimeSpan -Start $targetDate -End $today).Days
    Write-Host "🕰 That date was $days day(s) ago."
}
else {
    Write-Host "📅 That date is today."
}

# Revision : 2.0
# Description : Accept a date parameter or prompt for one; compute days until/since that date.
#               After displaying results allow:
#                 - Entering Y to start over (interactive prompt for a new date),
#                 - Entering N (or blank) to exit,
#                 - Or entering a date directly to compute immediately.
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-09-26
# Modified Date: 2025-10-20

<#
.SYNOPSIS
    Compute days until or since a provided date (via parameter or prompt),
    then allow Y/N or direct-date input to continue.

.DESCRIPTION
    If a date is passed in as a parameter, the script uses it for the first run.
    After finishing, the script accepts one of:
      - Y  : start over interactively (prompt for a date)
      - N  : exit (default)
      - any date string: parse and immediately compute for that date, repeating until
                         the user types Y, N, or blank.

.PARAMETER TargetDate
    An optional date (string or DateTime). If omitted, user is prompted.

.NOTES
    Author      : Jason "Lambo" Lamb
    Version     : 2.0
    Created Date: 2025-09-26
    Modified Date: 2025-10-20
#>

param(
    [Parameter(Mandatory = $false)]
    [AllowNull()]
    [object]$TargetDate
)

function Parse-DateManual {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Input
    )

    if ($null -eq $Input) { return $null }
    $s = $Input.Trim()
    if ([string]::IsNullOrWhiteSpace($s)) { return $null }

    # Normalize whitespace
    $s = ($s -replace '\s+', ' ').Trim()

    # Split on '/', '-' or whitespace
    $parts = $s -split '[\/\-\s]+'
    if ($parts.Count -ne 3) {
        return $null
    }

    for ($i = 0; $i -lt 3; $i++) { $parts[$i] = $parts[$i].Trim() }

    try {
        if ($parts[0].Length -eq 4 -and $parts[0] -match '^\d{4}$') {
            $year  = [int]$parts[0]
            $month = [int]$parts[1]
            $day   = [int]$parts[2]
        }
        elseif ($parts[2].Length -eq 4 -and $parts[2] -match '^\d{4}$') {
            $month = [int]$parts[0]
            $day   = [int]$parts[1]
            $year  = [int]$parts[2]
        }
        else {
            $month = [int]$parts[0]
            $day   = [int]$parts[1]
            $ystr  = $parts[2]
            if ($ystr -notmatch '^\d{2,4}$') { return $null }
            if ($ystr.Length -eq 2) {
                $yy = [int]$ystr
                if ($yy -le 29) { $year = 2000 + $yy } else { $year = 1900 + $yy }
            }
            else {
                $year = [int]$ystr
            }
        }

        if ($month -lt 1 -or $month -gt 12) { return $null }
        if ($year -lt 1 -or $year -gt 9999) { return $null }

        $maxDay = [datetime]::DaysInMonth($year, $month)
        if ($day -lt 1 -or $day -gt $maxDay) { return $null }

        return [datetime]::new($year, $month, $day)
    }
    catch {
        return $null
    }
}

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

        # Try manual numeric parse first
        $parsed = Parse-DateManual -Input $raw
        if ($parsed) {
            $dt = $parsed
            break
        }

        # Try permissive PowerShell parse last
        try {
            $dt = Get-Date -Date $raw -ErrorAction Stop
            break
        }
        catch {
            Write-Host "'$raw' is not a valid date - try again." -ForegroundColor Yellow
            $dt = $null
        }
    } until ($dt)

    return $dt.Date
}

function Show-Calculation {
    param(
        [Parameter(Mandatory = $true)]
        [DateTime]$DateToCheck
    )

    $today = (Get-Date).Date

    if ($DateToCheck -gt $today) {
        $days = (New-TimeSpan -Start $today -End $DateToCheck).Days
        Write-Host "⏳ That date is $days day(s) in the future."
    }
    elseif ($DateToCheck -lt $today) {
        $days = (New-TimeSpan -Start $DateToCheck -End $today).Days
        Write-Host "🕰 That date was $days day(s) ago."
    }
    else {
        Write-Host "📅 That date is today - 0 day(s)."
    }
}

# Main logic (loop with enhanced restart prompt)
$initialParamProvided = $PSBoundParameters.ContainsKey('TargetDate')
$iteration = 0
$keepRunning = $true

while ($keepRunning) {
    # Determine TargetDate for this iteration:
    if ($initialParamProvided -and $iteration -eq 0) {
        # Use the provided parameter for the first run.
        if ($TargetDate -is [DateTime]) {
            $TargetDate = $TargetDate.Date
        }
        elseif ($TargetDate -is [string]) {
            $parsed = Parse-DateManual -Input $TargetDate
            if (-not $parsed) {
                try {
                    $parsed = Get-Date -Date $TargetDate -ErrorAction Stop
                }
                catch {
                    Write-Error "Parameter TargetDate '$TargetDate' is not a valid date."
                    exit 1
                }
            }
            $TargetDate = $parsed.Date
        }
        else {
            $asString = [string]$TargetDate
            $parsed = Parse-DateManual -Input $asString
            if (-not $parsed) {
                try {
                    $parsed = Get-Date -Date $asString -ErrorAction Stop
                }
                catch {
                    Write-Error "Parameter TargetDate '$asString' is not a valid date."
                    exit 1
                }
            }
            $TargetDate = $parsed.Date
        }
    }
    else {
        # Either no initial parameter or a subsequent iteration: prompt interactively.
        $default = if ($TargetDate -is [DateTime]) { $TargetDate.Date } else { (Get-Date).Date }
        $TargetDate = Read-DateWithDefault -Prompt 'Enter a date (MM/dd/yyyy)' -Default $default
    }

    # Show calculation for the current TargetDate
    Show-Calculation -DateToCheck $TargetDate

    # Enhanced restart prompt:
    # - Blank or N (default) = exit
    # - Y = restart interactively (will prompt for a new date next iteration)
    # - Date string = parse and compute immediately; repeat prompt after result
    $inner = $true
    while ($inner) {
        $answer = Read-Host "Start over? Enter Y to prompt, N to exit (default N), or enter a date (MM/dd/yyyy) to compute now"
        if ([string]::IsNullOrWhiteSpace($answer)) {
            $keepRunning = $false
            $inner = $false
            break
        }

        # Check for explicit N
        if ($answer -match '^[Nn](o)?$') {
            $keepRunning = $false
            $inner = $false
            break
        }

        # Check for explicit Y -> go interactive next iteration
        if ($answer -match '^[Yy](es)?$') {
            $initialParamProvided = $false
            $iteration++
            $inner = $false
            break
        }

        # Otherwise, try to parse the answer as a date and compute immediately
        $tryParsed = Parse-DateManual -Input $answer
        if (-not $tryParsed) {
            # Try permissive Get-Date as last resort
            try {
                $tryParsed = Get-Date -Date $answer -ErrorAction Stop
            }
            catch {
                $tryParsed = $null
            }
        }

        if ($tryParsed) {
            $TargetDate = $tryParsed.Date
            Show-Calculation -DateToCheck $TargetDate
            # After immediate computation, loop again to ask whether to continue/exit/enter another date
            continue
        }

        Write-Host "Unrecognized response. Enter Y, N, or a date like 10/01/2025." -ForegroundColor Yellow
        # stay in inner loop to prompt again
    }
}

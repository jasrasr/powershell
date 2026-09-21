#Requires -Version 5.1
<#
.SYNOPSIS
Prompts for and sets the local Windows time zone.
.DESCRIPTION
Offers Eastern, Central, Mountain, Pacific, or installed Windows time zones
matching a standard (non-daylight-saving) UTC offset. Regional daylight-saving
rules apply automatically. Use the other-zone option for Arizona or regions
that do not observe daylight saving time. The account running the script must
have permission to change the Windows time zone.
.EXAMPLE
.\set-timezone.ps1
Run from PowerShell.
#>
[CmdletBinding(SupportsShouldProcess)]
param()

$ErrorActionPreference = 'Stop'

try {
    $currentZone = Get-TimeZone
    Write-Host "Current time zone: $($currentZone.DisplayName)"
    $selectedId = $null

    while (-not $selectedId) {
        Write-Host "`n1. Eastern  (EST/EDT)"
        Write-Host '2. Central  (CST/CDT)'
        Write-Host '3. Mountain (MST/MDT)'
        Write-Host '4. Pacific  (PST/PDT)'
        Write-Host '5. Other time zone - search by standard UTC offset'
        Write-Host 'Q. Quit without changes'
        $choice = (Read-Host 'Select 1-5 or Q').Trim()

        switch ($choice) {
            '1' { $selectedId = 'Eastern Standard Time' }
            '2' { $selectedId = 'Central Standard Time' }
            '3' { $selectedId = 'Mountain Standard Time' }
            '4' { $selectedId = 'Pacific Standard Time' }
            '5' {
                Write-Host 'Enter the standard UTC offset, not the seasonal daylight-saving offset.'
                Write-Host 'Examples: -05:00, +05:30, +05:45, or 0. Enter B to go back.'
                while (-not $selectedId) {
                    $offsetText = (Read-Host 'UTC offset').Trim()
                    if ($offsetText -eq 'B') { break }
                    if ($offsetText -notmatch '^([+-]?)(\d{1,2})(?::([0-5]\d))?$') {
                        Write-Warning 'Use an offset such as -05:00 or +05:30.'
                        continue
                    }

                    $hours = [int]$Matches[2]
                    $minutes = 0
                    if ($Matches[3]) { $minutes = [int]$Matches[3] }
                    $offsetMinutes = ($hours * 60) + $minutes
                    if ($Matches[1] -eq '-') { $offsetMinutes = -$offsetMinutes }
                    if ($offsetMinutes -lt -720 -or $offsetMinutes -gt 840) {
                        Write-Warning 'Enter an offset between -12:00 and +14:00.'
                        continue
                    }

                    $zones = @(Get-TimeZone -ListAvailable |
                        Where-Object { $_.BaseUtcOffset.TotalMinutes -eq $offsetMinutes } |
                        Sort-Object DisplayName, Id)
                    if ($zones.Count -eq 0) {
                        Write-Warning 'No installed Windows time zones match that standard offset.'
                        continue
                    }

                    for ($i = 0; $i -lt $zones.Count; $i++) {
                        Write-Host ('{0}. {1} [{2}]' -f ($i + 1), $zones[$i].DisplayName, $zones[$i].Id)
                    }
                    Write-Host 'Select your region so its daylight-saving rules are used.'
                    while (-not $selectedId) {
                        $zoneChoice = (Read-Host 'Select a zone number, or B to enter another offset').Trim()
                        if ($zoneChoice -eq 'B') { break }
                        $zoneNumber = 0
                        if ([int]::TryParse($zoneChoice, [ref]$zoneNumber) -and
                            $zoneNumber -ge 1 -and $zoneNumber -le $zones.Count) {
                            $selectedId = $zones[$zoneNumber - 1].Id
                        }
                        else {
                            Write-Warning 'Select one of the listed zone numbers.'
                        }
                    }
                }
            }
            'Q' { return }
            default { Write-Warning 'Select 1, 2, 3, 4, 5, or Q.' }
        }
    }

    if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME, "Set time zone to '$selectedId'")) {
        Set-TimeZone -Id $selectedId
        $updatedZone = Get-TimeZone
        if ($updatedZone.Id -ne $selectedId) {
            throw "Time zone verification failed. Current zone: $($updatedZone.Id)"
        }
        Write-Host "Time zone set to: $($updatedZone.DisplayName)"
    }
}
catch {
    throw "Unable to set the time zone: $($_.Exception.Message)"
}

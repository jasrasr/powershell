<#
    Filename:    Remove-NetworkPrinters.ps1
    Revision:    1.2.0
    Description: Identifies and removes all network printers installed for the current user
                 or system-wide. Catches both Type=Connection printers and locally-added
                 TCP/IP printers whose port matches a specified IP range. Supports -WhatIf.
    Author:      Jason Lamb with help from Claude Code
    Created:     2026-06-08
    Modified:    2026-06-08

    Changelog:
        1.2.0 - Changed -IPFilter default to '*' to catch all IP printers by default
        1.1.0 - Added -IPFilter parameter to catch local-type printers on matching IP ports
        1.0.0 - Initial release
#>

[CmdletBinding(SupportsShouldProcess)]
param (
    [switch]$AllUsers,

    # Wildcard pattern matched against the printer's port name/address.
    # Matches IP_ prefixed ports (e.g. IP_192.168.1.50) and raw IP ports.
    # Set to $null or '' to skip IP-based matching entirely.
    [string]$IPFilter = '*',

    [string]$LogPath = "$PSExports\Remove-NetworkPrinters_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
)

#region Functions

function Get-TargetPrinters {
    param (
        [switch]$AllUsers,
        [string]$IPFilter
    )

    $allPrinters = Get-Printer -ErrorAction SilentlyContinue

    # Network connections (\\server\share, WSD, etc.)
    $networkPrinters = $allPrinters | Where-Object { $_.Type -eq 'Connection' }

    # Local-type printers whose port resolves to an IP in the target range.
    # Port names are typically "IP_192.168.1.50" or sometimes the raw IP.
    $ipPrinters = @()
    if ($IPFilter) {
        $ipPrinters = $allPrinters | Where-Object {
            $_.Type -eq 'Local' -and (
                $_.PortName -like "IP_$IPFilter" -or
                $_.PortName -like $IPFilter
            )
        }
    }

    $combined = @($networkPrinters) + @($ipPrinters) |
        Sort-Object Name -Unique

    if (-not $AllUsers) {
        $combined = $combined | Where-Object {
            $_.ComputerName -eq $env:COMPUTERNAME -or [string]::IsNullOrEmpty($_.ComputerName)
        }
    }

    return $combined
}

#endregion

#region Main

Write-Host "`nRemove-NetworkPrinters.ps1" -ForegroundColor Cyan

if ($IPFilter) {
    Write-Host "IP filter  : $IPFilter" -ForegroundColor Gray
}
else {
    Write-Host "IP filter  : (none - Type=Connection only)" -ForegroundColor Gray
}

Write-Host "Scanning for network printers...`n" -ForegroundColor Gray

$targetPrinters = Get-TargetPrinters -AllUsers:$AllUsers -IPFilter $IPFilter

if (-not $targetPrinters) {
    Write-Host "No matching printers found. Nothing to do." -ForegroundColor Green
    exit 0
}

Write-Host "Found $($targetPrinters.Count) printer(s) to process:`n" -ForegroundColor Yellow

$results = [System.Collections.Generic.List[PSCustomObject]]::new()

foreach ($printer in $targetPrinters) {
    $matchReason = if ($printer.Type -eq 'Connection') { 'Network connection' }
                   else { "IP port match ($($printer.PortName))" }

    $entry = [PSCustomObject]@{
        PrinterName  = $printer.Name
        PortName     = $printer.PortName
        DriverName   = $printer.DriverName
        Type         = $printer.Type
        MatchReason  = $matchReason
        Status       = $null
        Timestamp    = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    }

    Write-Host "  Printer : $($printer.Name)" -ForegroundColor White
    Write-Host "  Port    : $($printer.PortName)" -ForegroundColor Gray
    Write-Host "  Type    : $($printer.Type)  ($matchReason)" -ForegroundColor Gray

    if ($PSCmdlet.ShouldProcess($printer.Name, 'Remove printer')) {
        try {
            Remove-Printer -Name $printer.Name -ErrorAction Stop
            $entry.Status = 'Removed'
            Write-Host "  Result  : Removed successfully`n" -ForegroundColor Green
        }
        catch {
            $entry.Status = "Error: $($_.Exception.Message)"
            Write-Host "  Result  : ERROR - $($_.Exception.Message)`n" -ForegroundColor Red
        }
    }
    else {
        $entry.Status = 'WhatIf - No action taken'
        Write-Host "  Result  : [WhatIf] Would remove`n" -ForegroundColor DarkYellow
    }

    $results.Add($entry)
}

# Export log
try {
    $null = New-Item -ItemType Directory -Path (Split-Path $LogPath) -Force -ErrorAction SilentlyContinue
    $results | Export-Csv -Path $LogPath -NoTypeInformation
    Write-Host "Log saved to: $LogPath" -ForegroundColor Cyan
}
catch {
    Write-Warning "Could not save log: $($_.Exception.Message)"
}

$removed = @($results | Where-Object { $_.Status -eq 'Removed' }).Count
$errors  = @($results | Where-Object { $_.Status -like 'Error*' }).Count
$skipped = @($results | Where-Object { $_.Status -like 'WhatIf*' }).Count

Write-Host "`nSummary:" -ForegroundColor Cyan
Write-Host "  Removed : $removed" -ForegroundColor Green
if ($errors  -gt 0) { Write-Host "  Errors  : $errors" -ForegroundColor Red }
if ($skipped -gt 0) { Write-Host "  Skipped : $skipped (WhatIf mode)" -ForegroundColor DarkYellow }

#endregion

# Example Usage:
# .\Remove-NetworkPrinters.ps1
# .\Remove-NetworkPrinters.ps1 -WhatIf
# .\Remove-NetworkPrinters.ps1 -IPFilter '192.168.*.*'
# .\Remove-NetworkPrinters.ps1 -IPFilter '192.168.1.*'
# .\Remove-NetworkPrinters.ps1 -IPFilter ''
# .\Remove-NetworkPrinters.ps1 -AllUsers -WhatIf
# .\Remove-NetworkPrinters.ps1 -LogPath "C:\Temp\printer-removal.csv"
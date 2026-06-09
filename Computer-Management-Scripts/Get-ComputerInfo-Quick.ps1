# Filename: Get-ComputerInfo-Quick.ps1
# Revision : 1.0.0
# Description : Retrieves computer name, model, BIOS version, and current logged-in user.
#               Runs locally by default; use -ComputerName to query one or more remote machines.
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-05-14
# Modified Date : 2026-05-14
# Changelog :
# 1.0.0 initial release

param(
    [string[]]$ComputerName
)

function Get-QuickInfo {
    param([string]$Target)

    $wmiArgs = @{ ErrorAction = "Stop" }
    if ($Target) { $wmiArgs.ComputerName = $Target }

    try {
        $cs   = Get-WmiObject -Class Win32_ComputerSystem @wmiArgs
        $bios = Get-WmiObject -Class Win32_BIOS           @wmiArgs

        [PSCustomObject]@{
            ComputerName = $cs.Name
            Model        = $cs.Model.Trim()
            BIOSVersion  = $bios.SMBIOSBIOSVersion.Trim()
            LoggedInUser = if ($cs.UserName) { $cs.UserName } else { "(none)" }
        }
    } catch {
        Write-Warning "Could not connect to ${Target}: $_"
        [PSCustomObject]@{
            ComputerName = if ($Target) { $Target } else { $env:COMPUTERNAME }
            Model        = "N/A"
            BIOSVersion  = "N/A"
            LoggedInUser = "N/A"
        }
    }
}

if ($ComputerName) {
    $results = foreach ($computer in $ComputerName) { Get-QuickInfo -Target $computer }
} else {
    $results = Get-QuickInfo
}

$results | Format-Table -AutoSize

# Example Usage:
#   .\Get-ComputerInfo-Quick.ps1
#   .\Get-ComputerInfo-Quick.ps1 -ComputerName "PC01"
#   .\Get-ComputerInfo-Quick.ps1 -ComputerName "PC01","PC02","PC03"

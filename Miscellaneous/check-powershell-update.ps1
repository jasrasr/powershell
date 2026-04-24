# Filename: check-powershell-update.ps1
# Revision : 1.0.0
# Description : Checks the Chocolatey RSS feed for powershell-core and alerts if a newer version is available than what is currently installed
# Author : Jason Lamb (with help from Claude Code)
# Created Date : 2026-04-23
# Modified Date : 2026-04-23
# Changelog :
# 1.0.0 initial release

$feed = Invoke-RestMethod "https://community.chocolatey.org/packages/powershell-core.atom"
$chocoVersion = ($feed.entry[0].title -split ' ')[-1]
$installedVersion = $PSVersionTable.PSVersion.ToString()

if ([version]$chocoVersion -gt [version]$installedVersion) {
    Write-Host "PowerShell update available on Chocolatey!" -ForegroundColor Yellow
    Write-Host "  Installed : $installedVersion"
    Write-Host "  Available : $chocoVersion"
    Write-Host "  Run: choco upgrade powershell-core -y" -ForegroundColor Cyan
} else {
    Write-Host "PowerShell is up to date ($installedVersion)." -ForegroundColor Green
}

# Example Usage:
#   .\check-powershell-update.ps1

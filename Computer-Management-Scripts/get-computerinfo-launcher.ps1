<#
# Revision : 1.0.0
# Description : Local launcher for Get-ComputerInfo.ps1 web script
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2026-05-14
# Modified Date : 2026-05-14
#>

Clear-Host

Write-Host "Reminder : This script is normally run from jasr.me." -ForegroundColor Yellow
Write-Host ""
Write-Host "Preferred command :" -ForegroundColor Cyan
Write-Host 'irm https://jasr.me/al-comp | iex' -ForegroundColor Green
Write-Host ""

try {
    Write-Host "Running web version now..." -ForegroundColor Cyan
    irm "https://jasr.me/al-comp" | iex
}
catch {
    Write-Warning "Failed to download or run https://jasr.me/al-comp"
    Write-Warning "Error : $_"
}

Write-Host ""
Write-Host "press any key"
Write-Host "to end"
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Filename: install-browsersearch-powertoys-plugin.ps1
# Revision : 1.0
# Description : Installs the BrowserSearch plugin for PowerToys Run from a downloaded ZIP file, copies required DLL dependencies, and restarts PowerToys if installation succeeds.
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2026-03-20
# Modified Date : 2026-03-20
# Changelog :
# 1.0 initial release

# Close PowerToys Run if it is running
Get-Process PowerToys.Run -ErrorAction SilentlyContinue | Stop-Process -Force

$downloadspath = "C:\Users\$env:USERNAME\Downloads"

if (Test-Path "$downloadspath\BrowserSearch-main.zip") {
    # unzip BrowserSearch-main.zip
    Expand-Archive -Path "$downloadspath\BrowserSearch-main.zip" -DestinationPath "$downloadspath\BrowserSearch-main" -Force
}
else {
    # stop script with error message
    Write-Host "BrowserSearch-main.zip not found in $downloadspath. Please download it from GitHub first.  https://github.com/TBM13/BrowserSearch/archive/refs/heads/main.zip" -ForegroundColor Yellow
    # launch browser to download page
    Start-Process "https://github.com/TBM13/BrowserSearch"
    return
}

Copy-Item "$downloadspath\BrowserSearch-main\BrowserSearch-main\BrowserSearch" "$env:LOCALAPPDATA\Microsoft\PowerToys\PowerToys Run\Plugins\BrowserSearch" -Recurse -Force
New-Item -ItemType Directory -Force -Path "$env:LOCALAPPDATA\Microsoft\PowerToys\PowerToys Run\Plugins\BrowserSearch\libs" | Out-Null

$libsDest = "$env:LOCALAPPDATA\Microsoft\PowerToys\PowerToys Run\Plugins\BrowserSearch\libs"
Copy-Item "$env:ProgramFiles\PowerToys\wox.plugin.dll" $libsDest
Copy-Item "$env:ProgramFiles\PowerToys\Wox.Infrastructure.dll" $libsDest
Copy-Item "$env:ProgramFiles\PowerToys\Microsoft.Data.Sqlite.dll" $libsDest
Copy-Item "$env:ProgramFiles\PowerToys\PowerToys.Settings.UI.Lib.dll" $libsDest

$libsPath = "$env:LOCALAPPDATA\Microsoft\PowerToys\PowerToys Run\Plugins\BrowserSearch\libs"
if (
    (Test-Path "$libsPath\wox.plugin.dll") -and
    (Test-Path "$libsPath\Wox.Infrastructure.dll") -and
    (Test-Path "$libsPath\Microsoft.Data.Sqlite.dll") -and
    (Test-Path "$libsPath\PowerToys.Settings.UI.Lib.dll")
) {
    Write-Host "All required DLLs exist." -ForegroundColor Green

    # Launch PowerToys
    Start-Process "$env:ProgramFiles\PowerToys\PowerToys.exe"
}
else {
    Write-Host "One or more required DLLs are missing." -ForegroundColor Red
}

# Example usage:
# . .\powertoys-browsersearch-install-helper.ps1
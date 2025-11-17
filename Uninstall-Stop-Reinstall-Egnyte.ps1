# Revision : 1.2
# Description : Stop Egnyte processes, uninstall Egnyte Desktop App, install 3.28.0.167, and verify elevation. Rev 1.2
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-11-17
# Modified Date : 2025-11-17

# ------------------------
# Admin Check
# ------------------------
$windowsIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
$windowsPrincipal = New-Object Security.Principal.WindowsPrincipal($windowsIdentity)
$isAdmin = $windowsPrincipal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "❌ This script must be run as Administrator. Exiting ..." -ForegroundColor Red
    exit 1
}

Write-Host "✔ Running with administrative privileges." -ForegroundColor Green

# ------------------------
# Stop Egnyte Processes
# ------------------------
Write-Host "`nStopping Egnyte processes ..."

$processes = Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*egnyte*" }

foreach ($p in $processes) {
    Write-Host "Stopping $($p.Name) : PID $($p.Id)"
    Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue
}

# ------------------------
# Uninstall Existing Egnyte
# ------------------------
Write-Host "`nChecking for installed Egnyte app ..."

$egnyteUninstall = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" |
    ForEach-Object { Get-ItemProperty $_.PsPath } |
    Where-Object { $_.DisplayName -like "*Egnyte*" }

if (-not $egnyteUninstall) {
    $egnyteUninstall = Get-ChildItem "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" |
        ForEach-Object { Get-ItemProperty $_.PsPath } |
        Where-Object { $_.DisplayName -like "*Egnyte*" }
}

if ($egnyteUninstall) {
    Write-Host "Found installed Egnyte version : $($egnyteUninstall.DisplayName)"
    Write-Host "Uninstalling Egnyte ..."

    $guid = $egnyteUninstall.PSChildName

    if ($guid -match "^\{.*\}$") {
        Write-Host "Using MSI uninstall GUID : $guid"
        Start-Process "msiexec.exe" -ArgumentList "/x $guid /qn" -Wait
    }
    elseif ($egnyteUninstall.UninstallString) {
        Write-Host "Using UninstallString : $($egnyteUninstall.UninstallString)"
        Start-Process "cmd.exe" -ArgumentList "/c $($egnyteUninstall.UninstallString) /qn" -Wait
    }

    Write-Host "Egnyte uninstall complete."
}
else {
    Write-Host "Egnyte not found. Skipping uninstall."
}

# ------------------------
# Install New Egnyte
# ------------------------
$msiPath = "\\clesccm\Application Source\Accessories\Egnyte\3.28\EgnyteDesktopApp_3.28.0_167.msi"

Write-Host "`nInstalling Egnyte from $msiPath ..."
Start-Process "msiexec.exe" -ArgumentList "/i `"$msiPath`" /qn" -Wait

Write-Host "`n✔ Egnyte installation complete."

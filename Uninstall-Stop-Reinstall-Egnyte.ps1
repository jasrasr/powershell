# Revision : 1.8
# Description : Self-elevate, stop Egnyte Desktop App processes, uninstall all versions with reboot suppression, copy MSI local, install Egnyte 3.29.1.175, and wait for keypress. Rev 1.8
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-11-17
# Modified Date : 2025-11-17

# ------------------------
# Self Elevation Block
# ------------------------
$windowsIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
$windowsPrincipal = New-Object Security.Principal.WindowsPrincipal($windowsIdentity)
$isAdmin = $windowsPrincipal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "⚠ Not running as Administrator. Attempting to relaunch with elevation ..." -ForegroundColor Yellow

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "powershell.exe"
    $psi.Arguments = "-ExecutionPolicy Bypass -File `"$PSCommandPath`""
    $psi.Verb = "runas"

    try {
        [System.Diagnostics.Process]::Start($psi) | Out-Null
        exit
    }
    catch {
        Write-Host "❌ User declined elevation. Continuing without admin ..." -ForegroundColor Yellow
    }
} else {
    Write-Host "✔ Running with administrative privileges." -ForegroundColor Green
}

# ------------------------
# Stop Egnyte Desktop App Processes
# ------------------------
Write-Host "`nStopping Egnyte Desktop App processes ..."

$egnyteProcesses = @(
    "Egnyte WebEdit",
    "EgnyteClient",
    "EgnyteDrive",
    "EgnyteSyncService",
    "EgnyteUpdate"
)

foreach ($proc in $egnyteProcesses) {
    $p = Get-Process -Name $proc -ErrorAction SilentlyContinue
    if ($p) {
        Write-Host "Stopping process $proc : PID $($p.Id)"
        Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue
    }
}

# ------------------------
# Uninstall Egnyte Desktop App (ALL versions)
# ------------------------
Write-Host "`nChecking for installed Egnyte Desktop App entries ..."

$uninstallRoot = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"

$egnyteApps = Get-ChildItem $uninstallRoot -ErrorAction SilentlyContinue |
    ForEach-Object {
        $props = Get-ItemProperty $_.PsPath -ErrorAction SilentlyContinue
        if ($props.DisplayName -eq "Egnyte Desktop App" -or $props.Publisher -eq "Egnyte, Inc.") {
            $props
        }
    }

if ($egnyteApps.Count -eq 0) {
    Write-Host "No Egnyte Desktop App installations found. Skipping uninstall."
}
else {
    foreach ($app in $egnyteApps) {
        Write-Host "`nFound Egnyte Desktop App : $($app.DisplayName)"
        Write-Host "Version installed : $($app.DisplayVersion)"
        Write-Host "MSI GUID : $($app.PSChildName)"

        $guid = $app.PSChildName

        if ($guid -and $guid -match "^\{.*\}$") {
            Write-Host "Uninstalling Egnyte Desktop App with REBOOT suppression ..."
            $proc = Start-Process "msiexec.exe" -ArgumentList "/x $guid /qn REBOOT=ReallySuppress" -PassThru
            $proc.WaitForExit()
            Write-Host "MSI uninstall exit code : $($proc.ExitCode)"
        }
        elseif ($app.UninstallString) {
            Write-Host "Using UninstallString : $($app.UninstallString) REBOOT=ReallySuppress"
            $cmd = "$($app.UninstallString) REBOOT=ReallySuppress"
            $proc = Start-Process "cmd.exe" -ArgumentList "/c $cmd" -PassThru
            $proc.WaitForExit()
            Write-Host "UninstallString exit code : $($proc.ExitCode)"
        }
        else {
            Write-Host "⚠ No uninstall method found for this entry."
        }
    }

    Write-Host "`n✔ Attempted uninstall for all Egnyte Desktop App entries."
}

# ------------------------
# Copy MSI Local and Install
# ------------------------
$sourceMsi  = "\\clesccm\Application Source\Accessories\Egnyte\3.29.1.175\EgnyteDesktopApp_3.29.1_175.msi"
$localFolder = "C:\Temp"
$localMsi    = Join-Path $localFolder "EgnyteDesktopApp_3.29.1_175.msi"

if (-not (Test-Path $localFolder)) {
    Write-Host "Creating folder $localFolder ..."
    New-Item -Path $localFolder -ItemType Directory | Out-Null
}

Write-Host "`nCopying MSI to $localMsi ..."
Copy-Item -Path $sourceMsi -Destination $localMsi -Force

Write-Host "`nInstalling Egnyte from $localMsi with REBOOT suppression ..."
$installProc = Start-Process "msiexec.exe" -ArgumentList "/i `"$localMsi`" /qn REBOOT=ReallySuppress" -PassThru
$installProc.WaitForExit()
Write-Host "Install MSI exit code : $($installProc.ExitCode)"

Write-Host "`n✔ Egnyte installation complete from local source."

# ------------------------
# Finished — Press Any Key to Exit
# ------------------------
Write-Host "`n------------------------------------------"
Write-Host "✔ Script completed. Press any key to exit ..."
Write-Host "------------------------------------------"
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# ------------------------
# Example Usage
# ------------------------
#   .\Update-EgnyteDesktopApp.ps1

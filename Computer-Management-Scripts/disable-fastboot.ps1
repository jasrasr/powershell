# Filename : disable-fastboot.ps1
# Revision : 1.2
# Description : Disables Windows Fast Boot (Fast Startup) via registry with validation, state check, and logging
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2026-03-18
# Modified Date : 2026-03-18
# Changelog :
# 1.0 initial version
# 1.1 added admin check, state validation, and logging
# 1.2 added before/after registry value output for verification

function Disable-FastBoot {

    # Ensure script is running as Administrator
    if (-not ([Security.Principal.WindowsPrincipal] `
        [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator)) {

        Write-Error "This script must be run as Administrator."
        return
    }

    $FastBootRegPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
    $FastBootValueName = "HiberbootEnabled"

    $logFile = "C:\temp\powershell-exports\disable-fastboot-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"

    try {
        # BEFORE STATE
        $before = Get-ItemProperty -Path $FastBootRegPath -Name $FastBootValueName -ErrorAction Stop

        Write-Output "Current Fast Boot value (before) : $($before.$FastBootValueName)"
        Add-Content -Path $logFile -Value "$(Get-Date) - BEFORE : $($before.$FastBootValueName)"

        if ($before.$FastBootValueName -eq 0) {
            Write-Output "Fast Boot is already disabled."
            Add-Content -Path $logFile -Value "$(Get-Date) - Already disabled."
        }
        else {
            Set-ItemProperty -Path $FastBootRegPath -Name $FastBootValueName -Value 0
            Write-Output "Fast Boot has been successfully disabled."
            Add-Content -Path $logFile -Value "$(Get-Date) - Fast Boot disabled."
        }

        # AFTER STATE
        $after = Get-ItemProperty -Path $FastBootRegPath -Name $FastBootValueName

        Write-Output "Current Fast Boot value (after)  : $($after.$FastBootValueName)"
        Add-Content -Path $logFile -Value "$(Get-Date) - AFTER : $($after.$FastBootValueName)"

        Write-Output "Please restart your computer for the changes to take effect."
    }
    catch {
        Write-Error "Error disabling Fast Boot : $_"
        Add-Content -Path $logFile -Value "$(Get-Date) - ERROR : $_"
    }
}

Disable-FastBoot


<# 
.EXAMPLE
. .\disable-fastboot.ps1
Disable-FastBoot
#>
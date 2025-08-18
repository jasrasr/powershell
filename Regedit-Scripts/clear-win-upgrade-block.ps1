# Revision : 1.0
# Description : Remove upgrade block by clearing TargetReleaseVersion settings and DisableOSUpgrade. Rev 1.0
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-08-13
# Modified Date : 2025-08-13

param(
    [string]$ComputerName = $env:COMPUTERNAME
)

$WUPath  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
$WSPath  = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore"

$sb = {
    param($WUPath,$WSPath)

    Write-Host "=== Clearing Windows Update upgrade restrictions on $env:COMPUTERNAME ==="

    # Ensure key exists
    if (-not (Test-Path $WUPath)) { New-Item -Path $WUPath -Force | Out-Null }
    if (-not (Test-Path $WSPath)) { New-Item -Path $WSPath -Force | Out-Null }

    # Set TargetReleaseVersion to 0 (DWORD)
    if (Get-ItemProperty -Path $WUPath -Name "TargetReleaseVersion" -ErrorAction SilentlyContinue) {
        Set-ItemProperty -Path $WUPath -Name "TargetReleaseVersion" -Value 0 -Type DWord
        Write-Host "Set TargetReleaseVersion to 0"
    }

    # Remove TargetReleaseVersionInfo completely
    if (Get-ItemProperty -Path $WUPath -Name "TargetReleaseVersionInfo" -ErrorAction SilentlyContinue) {
        Remove-ItemProperty -Path $WUPath -Name "TargetReleaseVersionInfo"
        Write-Host "Removed TargetReleaseVersionInfo"
    }

    # Set DisableOSUpgrade to 0 in both locations
    foreach ($path in @($WUPath,$WSPath)) {
        if (Get-ItemProperty -Path $path -Name "DisableOSUpgrade" -ErrorAction SilentlyContinue) {
            Set-ItemProperty -Path $path -Name "DisableOSUpgrade" -Value 0 -Type DWord
            Write-Host "Set DisableOSUpgrade to 0 at $path"
        }
    }

    Write-Host "Upgrade block settings cleared."
}

if ($ComputerName -ieq $env:COMPUTERNAME -or $ComputerName -in @('localhost','127.0.0.1','.')) {
    & $sb $WUPath $WSPath
} else {
    Invoke-Command -ComputerName $ComputerName -ScriptBlock $sb -ArgumentList $WUPath,$WSPath
}

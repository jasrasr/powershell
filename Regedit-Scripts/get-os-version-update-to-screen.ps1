# Revision : 1.1
# Description : Check specific registry values (local or remote) and output results to screen only. Rev 1.1
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-08-13
# Modified Date : 2025-08-13

param(
    [string]$ComputerName = $env:COMPUTERNAME
)

function Check-RegistryValue {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$PropertyName,
        [string]$ComputerName = $env:COMPUTERNAME
    )

    $sb = {
        param($Path,$PropertyName)
        $result = [pscustomobject]@{
            ComputerName    = $env:COMPUTERNAME
            Path            = $Path
            PropertyName    = $PropertyName
            KeyExists       = $false
            PropertyExists  = $false
            Value           = $null
            ValueKind       = $null
            Error           = $null
        }
        try {
            if (Test-Path -Path $Path) {
                $result.KeyExists = $true
                $props = (Get-ItemProperty -Path $Path -ErrorAction Stop).PSObject.Properties.Name
                if ($props -contains $PropertyName) {
                    $result.PropertyExists = $true
                    $result.Value = Get-ItemPropertyValue -Path $Path -Name $PropertyName -ErrorAction Stop
                    try {
                        $rk = Get-Item -Path $Path
                        $result.ValueKind = $rk.GetValueKind($PropertyName)
                    } catch {
                        $result.ValueKind = 'Unknown'
                    }
                }
            }
        } catch {
            $result.Error = $_.Exception.Message
        }
        return $result
    }

    if ($ComputerName -ieq $env:COMPUTERNAME -or $ComputerName -in @('localhost','127.0.0.1','.')) {
        & $sb $Path $PropertyName
    } else {
        Invoke-Command -ComputerName $ComputerName -ScriptBlock $sb -ArgumentList $Path,$PropertyName -ErrorAction Continue
    }
}

# --- PATHS ---
$windowsUpdateRegPath      = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
$windowsStoreRegPath       = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore"
$upgradeNotificationRegPath= "HKLM:\SYSTEM\Setup\UpgradeNotification"

# --- RUN CHECKS ---
$results = @()
$results += Check-RegistryValue -Path $windowsUpdateRegPath       -PropertyName "ProductVersion"           -ComputerName $ComputerName
$results += Check-RegistryValue -Path $windowsUpdateRegPath       -PropertyName "TargetReleaseVersionInfo" -ComputerName $ComputerName
$results += Check-RegistryValue -Path $windowsUpdateRegPath       -PropertyName "TargetReleaseVersion"     -ComputerName $ComputerName
$results += Check-RegistryValue -Path $windowsUpdateRegPath       -PropertyName "DisableOSUpgrade"         -ComputerName $ComputerName
$results += Check-RegistryValue -Path $windowsStoreRegPath        -PropertyName "DisableOSUpgrade"         -ComputerName $ComputerName
$results += Check-RegistryValue -Path $upgradeNotificationRegPath -PropertyName "UpgradeAvailable"         -ComputerName $ComputerName

# --- OUTPUT TO SCREEN ---
$results | Format-Table -AutoSize

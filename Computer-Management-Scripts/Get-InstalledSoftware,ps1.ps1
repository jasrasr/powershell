function Get-InstalledSoftware {
    param(
        [string]$ComputerName = $env:COMPUTERNAME
    )

    # Paths to check on remote machine
    $lmKeys = @(
        "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
        "SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
    )

    try {
        # Open remote HKLM hive
        $remoteHKLM = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey(
            [Microsoft.Win32.RegistryHive]::LocalMachine,
            $ComputerName
        )

        $software = @()

        foreach ($subKey in $lmKeys) {
            $key = $remoteHKLM.OpenSubKey($subKey)
            if ($null -eq $key) { continue }
            foreach ($name in $key.GetSubKeyNames()) {
                $skey = $key.OpenSubKey($name)
                if ($skey -eq $null) { continue }

                $dispName = $skey.GetValue("DisplayName")
                if ([string]::IsNullOrEmpty($dispName)) { continue }

                $obj = [PSCustomObject]@{
                    ComputerName     = $ComputerName
                    DisplayName      = $dispName
                    DisplayVersion   = $skey.GetValue("DisplayVersion")
                    Publisher        = $skey.GetValue("Publisher")
                    InstallDate      = $skey.GetValue("InstallDate")
                    UninstallString  = $skey.GetValue("UninstallString")
                }
                $software += $obj
            }
        }

        return $software
    }
    catch {
        Write-Warning "Failed to query $ComputerName: $_"
    }
}

<#
Example Usage:
Get-InstalledSoftware -ComputerName "Server01" | Format-Table -AutoSize
#>
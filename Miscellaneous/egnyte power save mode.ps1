    #dir  '\\egnytemigrate-3\c$\users\jason.lamb\downloads'

$remotecomputers = @(
    'egnytemigrate-1',
    'egnytemigrate-2',
    'egnytemigrate-3',
    'egnytemigrate-4',
    'egnytemigrate-5',
    'egnytemigrate-6'
)
<#
foreach ($computer in $remotecomputers) {
    $source = '\\egnytemigrate-3\c$\users\jason.lamb\downloads\CMMAgentInstaller.msi'
    $destination = "\\$computer\c$\users\jason.lamb\downloads\CMMAgentInstaller.msi"
    $newdestinationfolder = "\\$computer\c$\temp"
    $newdestinationfile = "\\$computer\c$\temp\CMMAgentInstaller.msi"
       # Verify if the file exists on the remote machine
    if (!(Test-Path -Path $newdestinationfolder)) {
        new-item -itemtype directory $newdestinationfolder
        } else {
        Copy-Item -Path $destination -Destination $newdestinationfile -Force
    }
    dir $newdestinationfolder
}
#>
<# DOESN'T WORK
    foreach ($computer in $remotecomputers) {
powercfg /change standby-timeout-ac 0
powercfg /change standby-timeout-dc 0
powercfg /change monitor-timeout-ac 0
powercfg /change monitor-timeout-dc 0
powercfg /hibernate off
powercfg /setactive SCHEME_MIN
Get-PnpDevice | Where-Object { $_.FriendlyName -match "USB" } | ForEach-Object {
    powercfg -devicequery wake_programmable | ForEach-Object {
        powercfg -deviceenablewake "$_"
    }
}
Get-NetAdapter | ForEach-Object {
    powercfg -devicedisablewake $_.Name
}
    }

    #>

    
# Ensure PowerShell Remoting is enabled on the remote computers
Invoke-Command -ComputerName $remoteComputers -ScriptBlock {
    Enable-PSRemoting -Force
}

# Execute the power configuration changes remotely
Invoke-Command -ComputerName $remoteComputers -ScriptBlock {
    # Step 1: Disable Sleep & Hibernation
    powercfg /change standby-timeout-ac 0
    powercfg /change standby-timeout-dc 0
    powercfg /change monitor-timeout-ac 0
    powercfg /change monitor-timeout-dc 0
    powercfg /hibernate off

    # Step 2: Set Power Plan to High Performance
    powercfg /setactive SCHEME_MIN
    }

    # Step 3: Disable USB Power Saving
    Get-PnpDevice | Where-Object { $_.FriendlyName -match "USB" } | ForEach-Object {
        powercfg -devicequery wake_programmable | ForEach-Object {
            powercfg -deviceenablewake "$_"
        }
    }

    # Step 4: Disable Network Adapter Power Saving
    Get-NetAdapter | ForEach-Object {
        powercfg -devicedisablewake $_.Name
    }
}

# Verify the changes remotely
Invoke-Command -ComputerName $remoteComputers -ScriptBlock {
    Write-Host "Verifying Power Settings on $env:COMPUTERNAME..."
    powercfg /query SCHEME_MIN
    powercfg -devicequery wake_programmable
}

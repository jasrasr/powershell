    #dir  '\\egnytemigrate-3\c$\users\jason.lamb\downloads'

midd
    
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
$session = New-PSSession -ComputerName "CLEDC1" -Credential (Get-Credential)
Invoke-Command -Session $session -ScriptBlock { 
repadmin /syncall
write-host "pausing 5 seconds"
for ($i = 5; $i -ge 1; $i--) {
    Write-Host "$i"
    Start-Sleep -Seconds 1
}
write-host "adsync will fail if it is currently running"
Start-ADSyncSyncCycle -PolicyType Delta
}

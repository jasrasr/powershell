param(
    [Parameter(Mandatory = $true)]
    [string]$ComputerName
)

$session = New-PSSession -ComputerName $ComputerName -Credential (Get-Credential)
Invoke-Command -Session $session -ScriptBlock {
    repadmin /syncall
    Write-Host "Pausing 5 seconds"
    for ($i = 5; $i -ge 1; $i--) {
        Write-Host "$i"
        Start-Sleep -Seconds 1
    }
    Write-Host "ADSync will fail if it is currently running"
    Start-ADSyncSyncCycle -PolicyType Delta
}

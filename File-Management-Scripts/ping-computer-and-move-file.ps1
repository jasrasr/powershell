$remotecomputers = @("CHIW10H36D1J3","CHIW10720PRV3")
$sourcefolder = "c$\temp\*bitlocker*.pdf"
$destinationfolder = "U:\Cleveland\740\Operations\Bitlocker"

foreach ($remotecomputer in $remotecomputers) {
    <# $remotecomputer is tremotecompute$remotecomputers current item #>
    if ((Test-Connection -ComputerName $remotecomputer -Count 1).StatusCode -eq 0) {
        $fullsourcepath = Join-Path -Path "\\$remotecomputer" -ChildPath $sourcefolder
        Move-Item -Path "$fullsourcepath\*bitlocker*.pdf" -Destination $destinationfolder -Force
    } else {
        Write-Host "$remotecomputer is not reachable"
    }

}

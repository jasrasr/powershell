$list2array = @(
    "BUFHF4F814",
    "BUFHQBD0J3",
    "BUFW1081DB4J3",
    "BUFW10CPVD814",
    "BUFW10J4WQLG3",
    "BUFW111X7LCK3",
    "CHI6H1LT74",
    "CHI9YF3LS3",
    "CHIW10DK1BTV3",
    "CHIW10G3H3HW3",
    "CHIW11352SKY3",
    "CHIW114GN3HW3",
    "CHIW119QTNRV3",
    "CHIW11JKN3HW3",
    "CLE26H3LS3",
    "CLE2FJ3LS3",
    "CLE3B1LT74",
    "CLE40TQLG3",
    "CLE69VQLG3",
    "CLE95WQLG3",
    "CLE9HK7G94",
    "CLEBG9JRV3",
    "CLEBKF69K3",
    "CLEC6Q7G94",
    "CLEJRJG814",
    "CLEJRTF0J3",
    "CLEW101Z630J3",
    "CLEW103XQQLG3",
    "CLEW104QBMKY3",
    "CLEW109KYHRV3",
    "CLEW10C6WQLG3",
    "CLEW10CP8F814",
    "CLEW10J3ZD0J3",
    "CLEW111TBMKY3",
    "CLEW114RBMKY3",
    "CLEW11H7JG0J3",
    "CLEW11HF740J3",
    "CLEW11JLSC0J3",
    "CLEW11JPSQLG3",
    "CLEW11JYZNRV3",
    "NWIBQN3HW3",
    "NWIH3J3LS3",
    "NWIW117N4F814",
    "NWIW118PBMKY3",
    "NWIW11HMBMKY3",
    "PIT85DWW94",
    "PITC40F814",
    "PITW1046T3HW3",
    "PITW1158T3HW3",
    "PITW116LTG0J3",
    "PITW116Y036M3",
    "PITW11C4WQLG3",
    "PITW11F40PRV3",
    "PITW11GBRQLG3",
    "TOL36H3LS3",
    "TOL4SBMKY3",
    "TOL56H3LS3",
    "TOL63J3LS3",
    "TOL6B1LT74",
    "TOL7H1LT74",
    "TOL7RBMKY3",
    "TOLDYZ2HW3",
    "TOLW10B0B3HW3",
    "TOLW116QBMKY3",
    "TOLW1178VF814",
    "TOLW117SBMKY3",
    "TOLW11B8WQLG3",
    "TOLW11C7W66L3",
    "TOLW11GPBMKY3",
    "TOLW11HY720J3",
    "TOLW11JLBMKY3"
)
foreach ($item in $list2array){
   
    if (Test-Connection -ComputerName $item -Count 1 -Quiet) {
        Write-Host "$item : Online" -ForegroundColor Green
    # check if winrm is enabled
    $winrmStatus = (Get-Service -Name WinRM -ComputerName $item -ErrorAction SilentlyContinue).Status
    if ($winrmStatus -eq 'Running') {   
        Write-Host "$item : WinRM is already enabled" -ForegroundColor Yellow
        continue
    } else {
        Write-Host "$item : Enabling WinRM..." -ForegroundColor Cyan
        try {
            Invoke-Command -ComputerName $item -ScriptBlock {
                Enable-PSRemoting -Force -SkipNetworkProfileCheck
            } -ErrorAction Stop
            Write-Host "$item : WinRM enabled successfully." -ForegroundColor Green
        } catch {
            Write-Host "$item : Failed to enable WinRM. Error: $_" -ForegroundColor Red
        }
        Write-Host "$item : Offline" -ForegroundColor Red
        # add $item to new array $offlinecomputers
        $offlinecomputers += $item
    }
    
}
Write-Host "Offline computers:" -ForegroundColor Red
$offlinecomputers | ForEach-Object { Write-Host $_ -ForegroundColor Red }

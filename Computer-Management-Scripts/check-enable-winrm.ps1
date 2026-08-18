$list2array = @(
    "computernmae1",
		"computername2"
)

$offlinecomputers = @()


foreach ($item in $list2array){
    if (Test-Connection -ComputerName $item -Count 1 -Quiet) {
        Write-Host "$item : Online" -ForegroundColor Green
        # check if winrm is enabled using Invoke-Command
        try {
            $winrmStatus = Invoke-Command -ComputerName $item -ScriptBlock {
                (Get-Service -Name WinRM).Status
            } -ErrorAction Stop
            if ($winrmStatus -eq 'Running') {   
                Write-Host "$item : WinRM is already enabled" -ForegroundColor Yellow
                continue
            } else {
                Write-Host "$item : Enabling WinRM..." -ForegroundColor Cyan
                Invoke-Command -ComputerName $item -ScriptBlock {
                    Enable-PSRemoting -Force -SkipNetworkProfileCheck
                } -ErrorAction Stop
                Write-Host "$item : WinRM enabled successfully." -ForegroundColor Green
            }
        } catch {
            Write-Host "$item : Failed to check/enable WinRM. Error: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "$item : Offline" -ForegroundColor Red
        $offlinecomputers += $item
    }
}


Write-Host "Offline computers:" -ForegroundColor Red
$offlinecomputers | ForEach-Object { Write-Host $_ -ForegroundColor Red }

# SimpleInfo.ps1 (host this on GitHub or a web server)
Write-Output "Gathering system information..."
Write-Output "Hostname: $(hostname)"
Write-Output "OS Version: $(Get-WmiObject Win32_OperatingSystem | Select-Object -ExpandProperty Version)"
Write-Output "Logged-in User: $env:USERNAME"

# remote.ps1
# Collect basic system information and send it to the jasr.me receiver.
# The API key must match private/config.php on the server.

$endpoint = "https://jasr.me/code/receive.php"
$apiKey = "R9vK2mQ7xL4pN8sW3cT6yH1zB5dF0gJ2"

$privateIp = Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object {
        $_.IPAddress -notlike "127.*" -and
        $_.IPAddress -notlike "169.254.*" -and
        $_.AddressState -eq "Preferred"
    } |
    Select-Object -First 1 -ExpandProperty IPAddress

$payload = @{
    PublicIPAddress  = (Invoke-RestMethod -Uri "https://api.ipify.org")
    OSVersion        = (Get-CimInstance -ClassName Win32_OperatingSystem).Version
    Hostname         = $env:COMPUTERNAME
    PrivateIPAddress = $privateIp
    Username         = $env:USERNAME
} | ConvertTo-Json -Compress

Invoke-RestMethod `
    -Uri $endpoint `
    -Method Post `
    -Headers @{ "X-API-Key" = $apiKey } `
    -ContentType "application/json" `
    -Body $payload

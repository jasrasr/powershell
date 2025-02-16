# remote.ps1
$url2 = "http://jasr.me/code/remote1.ps1"

# Download and execute remote1.ps1 directly
Invoke-Expression (Invoke-WebRequest -Uri $url2).Content

# Optionally, download remote1.ps1 to disk for inspection and manual execution
$path = "C:\temp\remote1.ps1"
$client = New-Object System.Net.WebClient
$client.DownloadFile($url2, $path)

Write-Output "remote1.ps1 has been saved to $path. You can inspect and run it manually if needed."

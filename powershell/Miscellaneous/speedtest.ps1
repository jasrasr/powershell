<#
.SYNOPSIS
    This script performs a speed test and outputs the results.

.DESCRIPTION
    This script downloads the Ookla Speedtest CLI, runs a speed test, and outputs the download speed, upload speed, and ping.

.NOTES
    Author: Jason Lamb
    Date: 11/7/24
    Version: 1
#>

# Generate the timestamp
$timestamp = (Get-Date).ToString("yyyy-MM-dd-HH-mm-ss")

# Set the folder path and create it if necessary
$FolderPath = "C:\temp\Automox-exports\Speedtest"
if (-not (Test-Path -Path $FolderPath)) {
    New-Item -Path $FolderPath -ItemType Directory -Force
}

# Download and extract the Speedtest CLI
Invoke-WebRequest -Uri https://install.speedtest.net/app/cli/ookla-speedtest-1.1.1-win64.zip -OutFile "$FolderPath\speedtest.zip"
Expand-Archive -Path "$FolderPath\speedtest.zip" -DestinationPath "$FolderPath\SpeedtestCLI"

# Run the speed test
& "$FolderPath\SpeedtestCLI\speedtest.exe" --accept-license --accept-gdpr

# Capture and parse the speed test result
$speedtestResult = & "$FolderPath\SpeedtestCLI\speedtest.exe" --accept-license --accept-gdpr --format=json | ConvertFrom-Json

# Output results with a separator for clarity
Write-Output "----------------------------------------"
Write-Output $timestamp
Write-Output "Speedtest Results:"
Write-Output "Download Speed: $([math]::Round($speedtestResult.download.bandwidth * 8 / 1000000, 2)) Mbps"
Write-Output "Upload Speed: $([math]::Round($speedtestResult.upload.bandwidth * 8 / 1000000, 2)) Mbps"
Write-Output "Ping: $($speedtestResult.ping.latency) ms"
Write-Output "----------------------------------------"

# Revision : 1.0
# Description : Display a PowerShell progress bar with a variable total duration
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-07-01
# Modified Date : 2025-07-01

param (
    [int]$MinSeconds = 3,
    [int]$MaxSeconds = 10
)

# Generate random duration in seconds
$duration = Get-Random -Minimum $MinSeconds -Maximum ($MaxSeconds + 1)
$steps = 100
$interval = $duration / $steps

Write-Host "Progress will complete in approximately $duration seconds..."

for ($i = 0; $i -le $steps; $i++) {
    $percent = ($i / $steps) * 100
    Write-Progress -Activity "Processing Task" -Status "$percent% Complete" -PercentComplete $percent
    Start-Sleep -Milliseconds ($interval * 1000)
}

Write-Host "Done! Total time : $duration seconds"

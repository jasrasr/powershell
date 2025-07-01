# Revision : 1.1
# Description : Display a PowerShell progress bar with a variable total duration (fixed 99% hang issue)
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

for ($i = 0; $i -lt $steps; $i++) {
    $percent = ($i / $steps) * 100
    Write-Progress -Activity "Processing Task" -Status "$([math]::Round($percent,0))% Complete" -PercentComplete $percent
    Start-Sleep -Milliseconds ($interval * 1000)
}

# Final update to ensure 100% is shown
Write-Progress -Activity "Processing Task" -Status "100% Complete" -PercentComplete 100
Start-Sleep -Milliseconds 300

# Clear the progress bar
Write-Progress -Activity "Processing Task" -Completed

Write-Host "Done! Total time : $duration seconds"

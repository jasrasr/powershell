<#
.SYNOPSIS
    Displays progress while simulating a loading task.

.DESCRIPTION
    Shows a native PowerShell progress bar while processing advances from
    0 percent through 100 percent.

.EXAMPLE
    .\Show-LoadingScreenProgress.ps1

.NOTES
    This script runs the demonstration immediately when invoked.
#>

Write-Host "Starting heavy processing task..."

for ($i = 0; $i -le 100; $i += 5) {
    Write-Progress -Activity "Loading Claude Context" -Status "Ingesting project files... $i%" -PercentComplete $i
    Start-Sleep -Milliseconds 150
}

Write-Progress -Activity "Loading Claude Context" -Completed
Write-Host "Ready!" -ForegroundColor Green

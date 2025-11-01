<#
.SYNOPSIS
   Starts or stops caffeine.exe (-active/-stop) and logs each action into a single .log file.

.DESCRIPTION
   This script writes a line per action (“Start” or “Stop”) with timestamp,
   into a single log file named e.g. caffeine.log in the designated log folder.
   It doesn’t create a new file each time — it appends to the same one.

.PARAMETER Action
   'start' (corresponds to -active) or 'stop'.

.EXAMPLE
   . .\Invoke-Caffeine.ps1 -Action start
   . .\Invoke-Caffeine.ps1 -Action stop
#>

param (
    [ValidateSet('start','stop')]
    [string]$Action = 'start'
)

# Paths and config (adjust to your preference)
$exePath   = "$onedrivepath\Documents\caffeine.exe"
$logFolder = $psexportspath
$logFile   = Join-Path $logFolder "caffeine.log"

# Make sure log folder exists
if (-not (Test-Path $logFolder)) {
    New-Item -ItemType Directory -Path $logFolder | Out-Null
}

# Acquire timestamp in a good format
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

switch ($Action) {
    'start' {
        # Log the start event
        "$timestamp, Start" | Out-File -FilePath $logFile -Append
        # Start the process
        Start-Process -FilePath $exePath -ArgumentList '-active'
        Write-Host "Caffeine started. Logged to $logFile"
    }
    'stop' {
        # Log the stop event
        "$timestamp, Stop" | Out-File -FilePath $logFile -Append
        # Stop the process if running
        Get-Process -Name caffeine -ErrorAction SilentlyContinue | Stop-Process
        Write-Host "Caffeine stopped. Logged to $logFile"
    }
}

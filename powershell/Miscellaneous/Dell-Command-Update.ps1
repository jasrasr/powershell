<#
EVALUATION CODE

# update 10/24/24 moved logs to 'C:\Temp\Automox-Exports\DCU'
# update 10/24/24 - check if dcu-cli.exe file exist

# Define the file path to check
$filePath = "C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe"

# Check if the file exists
if (Test-Path -Path $filePath) {
    Write-Host "File exists: $filePath"
    exit 1  # File exists, exit with code 1
} else {
    Write-Host "File does not exist: $filePath"
    exit 0  # File does not exist, exit with code 0
}

#>

# Create a timestamp for the log file
$timestamp = Get-Date -Format "yyyy-MM-dd-HH-mm-ss"
$logPath = "C:\Temp\Automox-Exports\DCU\DellCommandUpdate-$timestamp.log"

# Define the source and destination directories
$sourceDirectory = "C:\Temp"
$destinationDirectory = "C:\Temp\Automox-Exports\DCU"

# Ensure the destination directory exists, if not create it
if (-not (Test-Path -Path $destinationDirectory)) {
    New-Item -ItemType Directory -Path $destinationDirectory -Force
    Write-Host "Created directory: $destinationDirectory"
}

# Get all files in the source directory that match the pattern
Get-ChildItem -Path $sourceDirectory -Filter "DellCommandUpdate*" | ForEach-Object {
    # Move the file to the destination directory
    $sourcePath = $_.FullName
    $destinationPath = Join-Path $destinationDirectory $_.Name

    Move-Item -Path $sourcePath -Destination $destinationPath
    Write-Host "Moved file: $($_.Name) to $destinationDirectory"
}

# Start the process for Dell Command Update and wait for it to finish
Start-Process -FilePath "C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe" -ArgumentList "/applyUpdates", "-silent", "-outputLog=$logPath" -Wait

# Output the contents of the log file for review
Get-Content -Path $logPath | Write-Host
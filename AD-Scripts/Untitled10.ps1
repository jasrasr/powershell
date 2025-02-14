
# ======================
# Otto AI Generated Code
# ======================
# Check for updates using winget
$updates = winget upgrade --accept-source-agreements --accept-package-agreements

# Check if there are any updates available
if ($updates -match "No packages found to upgrade") {
    # No updates available
    write-output "exit 0"
} else {
    # Updates are available
    write-output "exit 1"
}


###

# Set the folder path
$folderPath = "C:\Temp\Automox-Exports\Winget-Updates"

# Check if the folder exists; create it if it doesn't
if (-not (Test-Path -Path $folderPath)) {
    New-Item -Path $folderPath -ItemType Directory -Force
}

# Generate the timestamp
$timestamp = (Get-Date).ToString("yyMMdd-HHmmss")

# Set the output path with the timestamp
$outputPath = "$folderPath\winget-updates-$timestamp.txt"

# Run the winget command and export the output to both the screen and the file
winget upgrade --all -h --include-unknown --accept-package-agreements --accept-source-agreements | Tee-Object -FilePath $outputPath

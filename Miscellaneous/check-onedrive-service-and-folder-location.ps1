# Define the OneDrive path specific to Middough
$oneDrivePath = "C:\users\$env:USERNAME\OneDrive - Middough"

# Define the name of the OneDrive process
$onedriveProcessName = "OneDrive"

# Check if the OneDrive process is running
$onedriveProcess = Get-Process -Name $onedriveProcessName -ErrorAction SilentlyContinue

# Define user-specific paths using $env:USERNAME
$sourceFolders = @(
    "C:\$env:USERNAME\Desktop",
    "C:\$env:USERNAME\Documents",
    "C:\$env:USERNAME\Downloads",
    "C:\$env:USERNAME\Pictures",
    "C:\$env:USERNAME\Music",
    "C:\$env:USERNAME\Videos"
)

# Check if OneDrive path exists
if ($onedriveProcess) {
    # If the OneDrive process is found, confirm the path
    if (-Not (Test-Path -Path $oneDrivePath)) {
        Write-Host "OneDrive service is running. OneDrive path not found." -ForegroundColor Red
        exit 0
    } else {
        # OneDrive process is running, and path exists
        Write-Host "OneDrive is running, and the path exists." -ForegroundColor Green
        # Move files from each folder
foreach ($sourcePath in $sourceFolders) {
    if (-Not (Test-Path -Path $sourcePath)) {
        Write-Host "Source path $sourcePath not found. Skipping." -ForegroundColor Yellow
        continue
    }

    # Get all files from the source folder
    $files = Get-ChildItem -Path $sourcePath -Recurse -File

    foreach ($file in $files) {
        # Construct the destination path within OneDrive
        $relativePath = $file.FullName.Substring($sourcePath.Length)
        $destination = Join-Path $oneDrivePath $relativePath
        $destinationDir = Split-Path $destination -Parent

        # Create the destination directory if it doesn't exist
        if (-Not (Test-Path -Path $destinationDir)) {
            New-Item -ItemType Directory -Path $destinationDir -Force
            }

        # Move file to OneDrive
        Move-Item -Path $file.FullName -Destination $destination -Force
        Write-Host "Moved $($file.FullName) to OneDrive"
        }
        Write-Host "Move to OneDrive completed for all specified folders."
    }
} else {
    # OneDrive process is not running
    Write-Host "OneDrive process not found." -ForegroundColor Yellow
    exit 0
}




# Define the OneDrive path specific to Middough
$oneDrivePath = "C:\users\$env:USERNAME\OneDrive - Middough"

# Check if OneDrive path exists
if (-Not (Test-Path -Path $oneDrivePath)) {
    Write-Host "OneDrive path not found. Please ensure OneDrive is set up on this machine." -ForegroundColor Red
    exit 0
}




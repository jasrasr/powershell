# Define OneDrive path specific to ${domainup}

$oneDrivePath = "C:\users\$env:USERNAME\OneDrive - ${domain}"
# Check if OneDrive process is running
$oneDriveProcess = Get-Process -Name "OneDrive" -ErrorAction SilentlyContinue

if ($oneDriveProcess) {
    Write-Host "OneDrive is running."
    
    # Check if the OneDrive sync folder exists
    if (Test-Path -Path $oneDrivePath) {
        Write-Host "OneDrive sync folder exists at: $oneDrivePath."

        # Define user-specific paths using $env:USERNAME
$sourceFolders = @(
    "C:\users\$env:USERNAME\Desktop",
    "C:\users\$env:USERNAME\Documents",
    "C:\users\$env:USERNAME\Downloads",
    "C:\users\$env:USERNAME\Pictures",
    "C:\users\$env:USERNAME\Music",
    "C:\users\$env:USERNAME\Videos"
)

# Define the list of source folders
$UserFolders = @("Desktop", "Documents", "Downloads", "Pictures", "Music", "Videos")


# Define the OneDrive path specific to ${domainup}
$oneDrivePath = "C:\users\$env:USERNAME\OneDrive - ${domain}"





# Check if OneDrive path exists
if (-Not (Test-Path -Path $oneDrivePath)) {
    Write-Host "OneDrive path not found. Please ensure OneDrive is set up on this machine." -ForegroundColor Red

}


# Loop through each source folder, join it with the base folder, and create the folder if it doesn't exist
foreach ($UserFolder in $UserFolders) {
    $fullPath = Join-Path $oneDrivePath $UserFolder
    
    # Check if the folder exists, if not, create it
    if (-Not (Test-Path -Path $fullPath)) {
        New-Item -Path $fullPath -ItemType Directory | Out-Null
        Write-Host "Created directory: $fullPath"
    } else {
        Write-Host "Directory already exists: $fullPath"
    }
}




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
}

Write-Host "Move to OneDrive completed for all specified folders."

    } else {
        Write-Host "OneDrive sync folder not found. Please ensure OneDrive is set up properly." -ForegroundColor Red
    }
} else {
    Write-Host "OneDrive is not running. Please ensure it is signed in and running." -ForegroundColor Red
}

###



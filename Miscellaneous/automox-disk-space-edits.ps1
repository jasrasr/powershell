<#
# ======================
# Otto AI Generated Code
# ======================
# Define the path to the folder
$folderPath = "C:\Windows\ccmcache"  # Path to check

# Check if the folder exists
if (Test-Path $folderPath) {
    # Get the size of the folder
    $folderSize = (Get-ChildItem $folderPath -Recurse | Measure-Object -Property Length -Sum).Sum

    # Convert size from bytes to gigabytes
    $folderSizeGB = $folderSize / 1GB

    # Check if the folder size is greater than 1 GB
    if ($folderSizeGB -gt 1) {
        # Exit with code 1 if size is greater than 1 GB
        write-output "exit 1"
    } else {
        # Exit with code 0 if size is less than or equal to 1 GB
        write-output "exit 0"
    }
} else {
    # If the folder does not exist, exit with code 1
    write-output "exit 0"
}

#>

#FOLDER DELETE WITH DISK SIZE IN MB & GB
# Define the parent folder path where you want to check for subfolders
$parentFolderPath = "C:\windows\ccmcache"

# Function to calculate the total size of a folder
function Get-FolderSize($path) {
    $totalSize = (Get-ChildItem -Path $path -Recurse | Measure-Object -Property Length -Sum).Sum
    $sizeMB = [math]::Round($totalSize / 1MB, 2)  # Size in MB
    $sizeGB = [math]::Round($totalSize / 1GB, 2)  # Size in GB
    return @{ MB = $sizeMB; GB = $sizeGB }
}

# Get total size of the folder before deletion
$sizeBefore = Get-FolderSize $parentFolderPath
Write-Output "Total size before deletion: $($sizeBefore.MB) MB ($($sizeBefore.GB) GB)"

# Get the current date and subtract 3 days to set the threshold
$thresholdDate = (Get-Date).AddDays(-3)

# Get all directories (folders) within the specified path
$folders = Get-ChildItem -Path $parentFolderPath -Directory

# Loop through each folder and check its LastWriteTime
foreach ($folder in $folders) {
    if ($folder.LastWriteTime -lt $thresholdDate) {
        # If the folder's LastWriteTime is older than the threshold, delete the folder
        Remove-Item -Path $folder.FullName -Recurse -Force

        # Output confirmation for each deleted folder
        Write-Output "Deleted folder: $($folder.FullName)"
    }
}

# Get total size of the folder after deletion
$sizeAfter = Get-FolderSize $parentFolderPath
Write-Output "Total size after deletion: $($sizeAfter.MB) MB ($($sizeAfter.GB) GB)"













# Define the base folder path
$baseFolderPath = "C:\windows\ccmcache"

# Set the initial date (today)
$startDate = Get-Date

# Loop to create 10 folders, each with 1 file, and modify the timestamps
for ($i = 0; $i -lt 10; $i++) {
    # Define the folder path for each folder (e.g., Folder-Test\folder0, Folder-Test\folder1, etc.)
    $folderPath = "$baseFolderPath\folder$i\"

    # Define the file path for each file inside the folder with .txt extension
    $filePath = "$folderPath\MyFile$i.txt"

    # Create the folder
    New-Item -ItemType Directory -Path $folderPath -Force

    # Create a file of 1 GB size (1 GB = 1073741824 bytes) using fsutil
    fsutil file createnew $filePath 1073741824

    # Calculate the date for each folder and file (today - $i days)
    $folderDate = $startDate.AddDays(-$i)

    # Modify the file's last write time, last access time, and creation time
    (Get-Item $filePath).LastWriteTime = $folderDate
    (Get-Item $filePath).LastAccessTime = $folderDate
    (Get-Item $filePath).CreationTime = $folderDate

    # Modify the folder's last write time, last access time, and creation time
    (Get-Item $folderPath).LastWriteTime = $folderDate
    (Get-Item $folderPath).LastAccessTime = $folderDate
    (Get-Item $folderPath).CreationTime = $folderDate
}
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
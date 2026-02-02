# Define an array of project folders
$projectfolders = @(
    "\\server\folder",
    "C:\folder"
    )

    
# Loop through each folder and calculate the total size
foreach ($projectfolder in $projectfolders) {
    if (Test-Path $projectfolder) {
        # Store Get-ChildItem results in a variable to optimize performance
        $items = Get-ChildItem -Path $projectfolder -Recurse
        
        # Calculate total size
        $folderSize = ($items | Measure-Object -Property Length -Sum).Sum
        $folderSizeMB = [math]::Round($folderSize / 1MB, 2)
        
        # Count files and folders
        $fileCount = ($items | Where-Object { -not $_.PSIsContainer }).Count
        $folderCount = ($items | Where-Object { $_.PSIsContainer }).Count
        
        # Display information in structured format
        Write-Output "Folder: $projectfolder"
        Write-Output "  Total size: $folderSizeMB MB"
        Write-Output "  Files: $fileCount"
        Write-Output "  Folders: $folderCount"
        Write-Output ""
    }
    else {
        Write-Output "Folder $projectfolder does not exist."
        Write-Output ""
    }
}

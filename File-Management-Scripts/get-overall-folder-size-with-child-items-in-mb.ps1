# Define an array of project folders
$projectfolders = @(
    "\\server\folder",
    "C:\folder"
    )

    
# Loop through each folder and calculate the total size
foreach ($projectfolder in $projectfolders) {
    if (Test-Path $projectfolder) {
        $folderSize = (Get-ChildItem -Path $projectfolder -Recurse | Measure-Object -Property Length -Sum).Sum
        $folderSizeMB = [math]::Round($folderSize / 1MB, 2)
        Write-Output "Total size of $projectfolder : $folderSizeMB MB"
    }
    else {
        Write-Output "Folder $projectfolder does not exist."
    }
}

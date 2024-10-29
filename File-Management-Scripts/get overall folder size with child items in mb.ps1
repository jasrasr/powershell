# Define an array of project folders
$projectfolders = @(
    "N:\Citgo\CID 2024\CID2403",
    "N:\Citgo\CID 2024\CID2404",
    "N:\Citgo\CID 2024\CID2405",
    "N:\Citgo\CID 2024\CID2406",
    "N:\Citgo\CID 2024\CID2407"
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

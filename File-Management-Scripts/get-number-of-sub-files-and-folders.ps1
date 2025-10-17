# Process each folder, does it exist, how many sub files/folders

$foldersToProcess = @(
'\\server\folder\folder1',
'\\server\folder\folder2',
'\\server\folder\folder3'
)
foreach ($folder in $foldersToProcess) {
    if (Test-Path -Path $folder) {
        # check if folder has subfolders or files
        $items = Get-ChildItem -Path $folder -Recurse -Force -ErrorAction SilentlyContinue
        if ($items.Count -eq 0) {
            Write-Host "Folder is empty: $folder" -ForegroundColor Yellow
            continue
        }
        else {
            Write-Host "Folder has items: $folder - $($items.Count) items" -ForegroundColor Green
        }
     } else {
        Write-Host "Folder does not exist: $folder" -ForegroundColor Red
    }
}

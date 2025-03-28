# Define the root folder to search
$rootFolder = "C:\Users\jason.lamb\OneDrive - middough\Documents\GitHub\PowerShell"

# Get all files and folders recursively from the root folder
Get-ChildItem -Path $rootFolder -Recurse | ForEach-Object {
    # Check if the name contains a space
    if ($_.Name -match "\s") {
        # Replace spaces with dashes in the name
        $newName = $_.Name -replace "\s", "-"
        
        # Construct the full path for the new name
        $newFullName = Join-Path $_.DirectoryName $newName
        
        # Rename the item (file or folder)
        try {
            Rename-Item -Path $_.FullName -NewName $newFullName -Force
            Write-Output "Renamed: '$($_.FullName)' to '$newFullName'"
        }
        catch {
            Write-Output "Failed to rename: '$($_.FullName)'"
        }
    }
}

# Define the root folder to search
$rootFolder = "C:\Users\jason.lamb\OneDrive - middough\Documents\GitHub\PowerShell-private"

# Get all files and folders recursively from the root folder
Get-ChildItem -Path $rootFolder -Recurse | ForEach-Object {
    # Check if the name contains a space
    if ($_.Name -match "\s") {
        # Replace spaces with dashes in the name
        $newName = $_.Name -replace "\s", "-"
        
        # Construct the full path for the new name
        $newFullName = Join-Path $_.DirectoryName $newName
        
        # Rename the item (file or folder)
        try {
            Rename-Item -Path $_.FullName -NewName $newFullName -Force
            Write-Output "Renamed: '$($_.FullName)' to '$newFullName'"
        }
        catch {
            Write-Output "Failed to rename: '$($_.FullName)'"
        }
    }
}

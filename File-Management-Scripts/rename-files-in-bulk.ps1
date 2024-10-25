# Define the directory where the files are located
$directory = "N:\!newprojecttemplate-BIM"

# Get all files in the directory and subfolders that match the pattern
Get-ChildItem -Path $directory -Recurse -Filter "* - internet*" | ForEach-Object {
    # Store the current file name
    $oldName = $_.Name
    # Replace " - internet" with " - sharepoint"
    $newName = $oldName -replace " - internet", " - sharepoint"
    
    # Create the full path for the old and new names
    $oldFullPath = $_.FullName
    $newFullPath = Join-Path $_.DirectoryName $newName
    
    # Rename the file
    Rename-Item -Path $oldFullPath -NewName $newFullPath
    Write-Host "Renamed file: $oldName to $newName"
}



# Define the directory to search
#$directory = "N:\TEST\TEST2504"

# List all files in the folder and subfolders
Get-ChildItem -Path $directory -Recurse | Where-Object { -not $_.PSIsContainer } | Select-Object FullName

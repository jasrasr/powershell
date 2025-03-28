# Define the root folder to search
$rootFolder = "N:\"

# Use Get-ChildItem to search for directories in the format "N:\*\*"
$folders = Get-ChildItem -Path $rootFolder -Directory -Recurse | Where-Object {
    $_.FullName -match "^N:\\\w+\\\w+$"
}

# Output the matching folders
$folders | ForEach-Object { $_.FullName }

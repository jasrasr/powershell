# Define the path to the file you want to rename
$filePath = "${onedrivepath}\Downloads\Autodesk Licensing Service - 15.1.0.12339 - Win - Update.exe"

# Get the directory and file name
$directory = Split-Path $filePath
$fileName = Split-Path $filePath -Leaf

# Replace spaces with dashes in the file name
$newFileName = $fileName -replace " ", "-"

#replace double or triple dashes with single dashes, run once for triple dashes, then again for double dashes
$newFileName = $newFileName -replace "--", "-"

#replace double or triple dashes with single dashes, run twice for double
$newFileName = $newFileName -replace "--", "-"

# Define the new file path
$newFilePath = Join-Path $directory $newFileName

# Rename the file
Rename-Item -Path $filePath -NewName $newFileName

Write-Host "Renamed file to: $newFilePath"
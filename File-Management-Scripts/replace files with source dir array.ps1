# Define an array of source directories
$sourceDirs = @("C:\Path\To\Source1", "C:\Path\To\Source2")

# Define the template directory
$templateDir = "C:\Path\To\Template"

# Define files to remove and copy
$filesToRemove = @("file1.txt", "file2.txt")
$filesToCopy = @("template1.txt", "template2.txt")

foreach ($sourceDir in $sourceDirs) {
    # Remove specific files if found
    foreach ($file in $filesToRemove) {
        $filePath = Join-Path -Path $sourceDir -ChildPath $file
        if (Test-Path -Path $filePath) {
            Remove-Item -Path $filePath -Force
            Write-Host "Removed: $filePath"
        }
    }

    # Copy files from the template directory
    foreach ($file in $filesToCopy) {
        $sourceFilePath = Join-Path -Path $templateDir -ChildPath $file
        $destFilePath = Join-Path -Path $sourceDir -ChildPath $file
        Copy-Item -Path $sourceFilePath -Destination $destFilePath -Force
        Write-Host "Copied: $sourceFilePath to $destFilePath"
    }
}

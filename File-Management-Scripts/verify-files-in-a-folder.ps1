# Verify Files in a Folder

# This script verifies the presence of specific files in a folder

$folderPath = "C:\path\to\your\folder"
$requiredFiles = @("file1.txt", "file2.txt", "file3.txt")

foreach ($file in $requiredFiles) {
    if (-Not (Test-Path (Join-Path $folderPath $file))) {
        Write-Host "Missing file: $file"
        # Change from 'exit 1' to 'return' to keep the session open
        return
    }
}

Write-Host "All required files are present"

# Additional logic can go here

# Change from 'exit 1' to 'return' to keep the session open
return
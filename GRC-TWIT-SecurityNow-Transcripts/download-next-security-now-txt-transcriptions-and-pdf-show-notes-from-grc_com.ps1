# PowerShell Script to Download Security Now Transcripts

# Existing logic...

# Check if JPG-Episode-Images folder is empty
$jpgFolderPath = "JPG-Episode-Images"
$jpgFiles = Get-ChildItem $jpgFolderPath -Filter *.jpg

if ($jpgFiles.Count -eq 0) {
    $nextJPG = 1   # Set nextJPG to 1 if no JPG files present
} else {
    # Logic for setting nextJPG based on existing JSON
}

# Download/check sequentially through at least 1069
$startJPG = $nextJPG
$endJPG = 1069
$successCount = 0
$misses = 0

for ($currentJPG = $startJPG; $currentJPG -le $endJPG; $currentJPG++) {
    # Download or check logic...
    $downloaded = Download-JPG $currentJPG   # Example function to download
    if ($downloaded) {
        $successCount++
        $lastJPG = $currentJPG
        $misses = 0  # Reset misses on success
    } else {
        $misses++  # Increment misses
        if ($misses -eq 2) {  # Stop after two consecutive misses
            break
        }
    }
}

# Logic to save state
$lastJPG = if ($successCount -gt 0) { $lastJPG } else { 0 }

# Save the state with LastJPG
Save-State -LastJPG $lastJPG

# Existing logging style...
Log-Message "Download process completed. Last JPG: $lastJPG"

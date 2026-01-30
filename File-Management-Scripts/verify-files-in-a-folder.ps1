# Verify that all chunks from 0001 to 0138 have at least one backup file
# Files are named like: chunk_0001-backup1.csv, chunk_0001-backup2.csv, etc.

param(
    [string]$FolderPath = "J:\egnyte-012226\Backup",
    [int]$StartChunk = 1,
    [int]$EndChunk = 138
)

Write-Host "`nVerifying chunk files in: $FolderPath" -ForegroundColor Cyan
Write-Host "Expected range: chunk_$($StartChunk.ToString('0000')) to chunk_$($EndChunk.ToString('0000'))`n" -ForegroundColor Cyan

# Check if folder exists
if (-not (Test-Path $FolderPath)) {
    Write-Host "ERROR: Folder not found: $FolderPath" -ForegroundColor Red
    return
}

# Get all files matching the chunk pattern
$allFiles = Get-ChildItem -Path $FolderPath -File | Where-Object { $_.Name -match '^chunk_\d{4}' }

if ($allFiles.Count -eq 0) {
    Write-Host "ERROR: No chunk files found in the folder!" -ForegroundColor Red
    return
}

Write-Host "Total files found: $($allFiles.Count)`n" -ForegroundColor Gray

# Extract unique chunk numbers from filenames
$foundChunks = $allFiles | ForEach-Object {
    if ($_.Name -match '^chunk_(\d{4})') {
        [int]$matches[1]
    }
} | Select-Object -Unique | Sort-Object

# Find missing chunks
$missingChunks = @()
$foundChunksList = @()

for ($i = $StartChunk; $i -le $EndChunk; $i++) {
    if ($foundChunks -contains $i) {
        $foundChunksList += $i
    } else {
        $missingChunks += $i
    }
}

# Display results
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor White
Write-Host "                    RESULTS                        " -ForegroundColor White
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor White

Write-Host "`nChunks found: " -NoNewline
Write-Host "$($foundChunksList.Count) / $($EndChunk - $StartChunk + 1)" -ForegroundColor Green

if ($missingChunks.Count -eq 0) {
    Write-Host "`n✓ SUCCESS: All chunks are present!" -ForegroundColor Green
} else {
    Write-Host "`nMissing chunks: " -NoNewline
    Write-Host "$($missingChunks.Count)" -ForegroundColor Red
    
    Write-Host "`n✗ WARNING: The following chunks are missing:`n" -ForegroundColor Yellow
    
    # Display missing chunks in a formatted way (10 per line)
    for ($i = 0; $i -lt $missingChunks.Count; $i++) {
        Write-Host "chunk_$($missingChunks[$i].ToString('0000'))" -NoNewline -ForegroundColor Red
        
        if (($i + 1) % 10 -eq 0 -and $i -ne $missingChunks.Count - 1) {
            Write-Host ""
        } elseif ($i -ne $missingChunks.Count - 1) {
            Write-Host ", " -NoNewline
        }
    }
    Write-Host "`n"
}

Write-Host "═══════════════════════════════════════════════════`n" -ForegroundColor White

# Display sample of found chunks (first 5 and last 5)
Write-Host "Sample of found chunks:" -ForegroundColor Cyan
$sampleChunks = $foundChunksList | Select-Object -First 5
$lastChunks = $foundChunksList | Select-Object -Last 5

Write-Host "First 5: " -NoNewline -ForegroundColor Gray
Write-Host ($sampleChunks -join ", ") -ForegroundColor Green

Write-Host "Last 5:  " -NoNewline -ForegroundColor Gray
Write-Host ($lastChunks -join ", ") -ForegroundColor Green

Write-Host ""
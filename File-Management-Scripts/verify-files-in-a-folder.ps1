<#
.SYNOPSIS
    Verifies that files exist in a folder matching a specific pattern.

.DESCRIPTION
    This script verifies that files exist in a folder matching a numbered chunk pattern.
    For example, it can verify that files chunk_0001*.txt through chunk_0138*.txt exist,
    while ignoring backup files with suffixes like -backup1, -backup2, -backup3, etc.

.PARAMETER FolderPath
    The path to the folder containing the files to verify. This parameter is required.

.PARAMETER StartChunk
    The starting chunk number to verify. Default is 1.

.PARAMETER EndChunk
    The ending chunk number to verify. Default is 138.

.PARAMETER FileExtension
    The file extension to search for (without the dot). Default is "txt".

.PARAMETER FilePrefix
    The prefix used before the chunk number. Default is "chunk_".

.EXAMPLE
    .\verify-files-in-a-folder.ps1 -FolderPath "C:\Backups"
    
    Verifies that files chunk_0001*.txt through chunk_0138*.txt exist in C:\Backups,
    excluding backup files.

.EXAMPLE
    .\verify-files-in-a-folder.ps1 -FolderPath "C:\Backups" -StartChunk 1 -EndChunk 50 -FileExtension csv
    
    Verifies that files chunk_0001*.csv through chunk_0050*.csv exist in C:\Backups,
    excluding backup files.

.EXAMPLE
    .\verify-files-in-a-folder.ps1 -FolderPath "D:\Data" -FilePrefix "data_" -StartChunk 1 -EndChunk 100
    
    Verifies that files data_0001*.txt through data_0100*.txt exist in D:\Data,
    excluding backup files.

.NOTES
    Files with backup suffixes (e.g., -backup1, -backup2, -backup3) are ignored.
    The script returns exit code 0 if all files are found, or 1 if any are missing.
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$FolderPath,
    
    [Parameter(Mandatory=$false)]
    [int]$StartChunk = 1,
    
    [Parameter(Mandatory=$false)]
    [int]$EndChunk = 138,
    
    [Parameter(Mandatory=$false)]
    [string]$FileExtension = "txt",
    
    [Parameter(Mandatory=$false)]
    [string]$FilePrefix = "chunk_"
)

# Verify the folder exists
if (-not (Test-Path -Path $FolderPath)) {
    Write-Error "Folder path does not exist: $FolderPath"
    exit 1
}

# Validate chunk numbers
if ($StartChunk -le 0) {
    Write-Error "StartChunk must be a positive number (greater than 0)"
    exit 1
}

if ($EndChunk -le 0) {
    Write-Error "EndChunk must be a positive number (greater than 0)"
    exit 1
}

if ($StartChunk -gt $EndChunk) {
    Write-Error "StartChunk ($StartChunk) cannot be greater than EndChunk ($EndChunk)"
    exit 1
}

$startChunkFormatted = $StartChunk.ToString("D4")
$endChunkFormatted = $EndChunk.ToString("D4")

Write-Host "Verifying files in folder: $FolderPath" -ForegroundColor Cyan
Write-Host "Looking for files matching pattern: $FilePrefix$startChunkFormatted to $FilePrefix$endChunkFormatted*.$FileExtension" -ForegroundColor Cyan
Write-Host "Excluding files with backup suffixes (-backup1, -backup2, etc.)" -ForegroundColor Cyan
Write-Host ""

$missingChunks = @()
$foundChunks = @()

# Loop through each chunk number
for ($i = $StartChunk; $i -le $EndChunk; $i++) {
    # Format the chunk number with leading zeros (4 digits)
    $chunkNumber = $i.ToString("D4")
    
    # Build the search pattern for this chunk
    $searchPattern = "$FilePrefix$chunkNumber*.$FileExtension"
    
    # Get all files matching the pattern
    $matchingFiles = Get-ChildItem -Path $FolderPath -Filter $searchPattern -File -ErrorAction SilentlyContinue
    
    # Filter out backup files (files containing -backup followed by numbers)
    $nonBackupFiles = $matchingFiles | Where-Object { $_.Name -notmatch '-backup\d+' }
    
    if ($nonBackupFiles.Count -eq 0) {
        $missingChunks += $chunkNumber
        Write-Host "✗ Missing: $FilePrefix$chunkNumber*.$FileExtension" -ForegroundColor Red
    } else {
        $foundChunks += $chunkNumber
        if ($nonBackupFiles.Count -eq 1) {
            Write-Host "✓ Found: $($nonBackupFiles[0].Name)" -ForegroundColor Green
        } else {
            Write-Host "✓ Found: $($nonBackupFiles[0].Name) (+$($nonBackupFiles.Count - 1) more)" -ForegroundColor Green
        }
    }
}

# Display summary
Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "Verification Summary" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host "Total chunks expected: $($EndChunk - $StartChunk + 1)" -ForegroundColor White
Write-Host "Chunks found: $($foundChunks.Count)" -ForegroundColor Green
Write-Host "Chunks missing: $($missingChunks.Count)" -ForegroundColor Red

if ($missingChunks.Count -gt 0) {
    Write-Host ""
    Write-Host "Missing chunk numbers:" -ForegroundColor Yellow
    Write-Host ($missingChunks -join ", ") -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Verification FAILED - Missing files detected" -ForegroundColor Red
    exit 1
} else {
    Write-Host ""
    Write-Host "Verification PASSED - All files present" -ForegroundColor Green
    exit 0
}

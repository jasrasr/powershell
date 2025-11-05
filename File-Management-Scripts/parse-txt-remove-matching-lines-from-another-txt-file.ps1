# Revision : 2.0
# Description : Remove lines from *-cleaned.txt files that appear in a reference file (egnyte-permission-report.txt)
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-11-04
# Modified Date : 2025-11-04

param(
    [Parameter(Mandatory = $true)]
    [string] $Folder,                      # Folder containing *-cleaned.txt files
    [Parameter(Mandatory = $true)]
    [string] $ReferenceFile                # Path to egnyte-permission-report.txt
)

# --- Load reference file lines ---
if (-not (Test-Path $ReferenceFile)) {
    Write-Host "Reference file not found : $ReferenceFile" -ForegroundColor Red
    exit
}

$referenceLines = Get-Content $ReferenceFile | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" } | Sort-Object -Unique
Write-Host "Loaded $($referenceLines.Count) reference lines from $ReferenceFile" -ForegroundColor Yellow

# --- Find target files ---
$files = Get-ChildItem -Path $Folder -Filter '*-cleaned.txt' -File
if (-not $files) {
    Write-Host "No *-cleaned.txt files found in $Folder" -ForegroundColor Yellow
    exit
}

foreach ($file in $files) {
    Write-Host "Processing : $($file.Name)" -ForegroundColor Cyan

    try {
        # Load current file lines
        $content = Get-Content -Path $file.FullName

        # Filter out lines that match any from reference
        $filtered = $content | Where-Object { $referenceLines -notcontains $_ }

        # Build output name (e.g., chunk_0036-cleaned-dedup.txt)
        $newname = ($file.BaseName -replace '-cleaned$', '-cleaned-dedup') + '.txt'
        $newpath = Join-Path $file.DirectoryName $newname

        # Write filtered content to new file
        $filtered | Set-Content -Path $newpath -Encoding UTF8

        $removedCount = $content.Count - $filtered.Count
        Write-Host "Created : $newname  |  Original : $($content.Count)  Removed : $removedCount  Remaining : $($filtered.Count)" -ForegroundColor Green
    }
    catch {
        Write-Host "Error processing $($file.Name) : $_" -ForegroundColor Red
    }
}

Write-Host "All *-cleaned.txt files processed successfully." -ForegroundColor Cyan


# example usage
# .\parse-txt-remove-matching-lines-from-another-txt-file.ps1 -Folder 'C:\Temp\egnyte-110425\depth3' -ReferenceFile 'C:\Temp\egnyte-110425\egnyte-permission-report.txt'
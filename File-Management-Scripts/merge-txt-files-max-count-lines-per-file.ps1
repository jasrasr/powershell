# Revision : 1.2
# Description : Merge all TXT files in a folder into new merged files with a maximum of 1000 rows each.
# Adds progress display and CSV summary logging.
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-11-05
# Modified Date : 2025-11-05

param(
    [Parameter(Mandatory = $true)]
    [string]$FolderPath,

    [int]$MaxLinesPerFile = 1000
)

Write-Host "Starting merge in $FolderPath with max $MaxLinesPerFile lines per file..." -ForegroundColor Cyan

# --- Gather all text files ---
$txtFiles = Get-ChildItem -Path $FolderPath -Filter *.txt -File |
             Where-Object { $_.Name -notmatch '-merged\.txt$' } |
             Sort-Object Name

$totalCount = $txtFiles.Count
Write-Host "Found $totalCount source files" -ForegroundColor Yellow

# --- Create list for all lines ---
$allLines = New-Object System.Collections.Generic.List[string]

# --- Read files safely with progress ---
$counter = 0
foreach ($file in $txtFiles) {
    $counter++
    Write-Progress -Activity "Reading TXT files..." -Status "$counter of $totalCount : $($file.Name)" -PercentComplete (($counter / $totalCount) * 100)
    $lines = Get-Content -Path $file.FullName -Encoding UTF8
    foreach ($line in $lines) {
        [void]$allLines.Add([string]$line)
    }
}

Write-Progress -Activity "Reading TXT files..." -Completed
Write-Host "Total combined lines : $($allLines.Count)" -ForegroundColor Green

# --- Prepare summary log ---
$summaryFile = Join-Path $FolderPath "merge-summary.csv"
$summary = @()

# --- Split into groups of $MaxLinesPerFile ---
$chunkIndex = 1
$totalLinesWritten = 0

for ($i = 0; $i -lt $allLines.Count; $i += $MaxLinesPerFile) {
    $endIndex = [math]::Min($i + $MaxLinesPerFile - 1, $allLines.Count - 1)
    $chunk = $allLines[$i..$endIndex]
    $newFileName = "chunk_{0:D4}-cleaned-dedup-merged.txt" -f $chunkIndex
    $newFilePath = Join-Path $FolderPath $newFileName
    Write-Host "Writing $newFileName ($($chunk.Count) lines)" -ForegroundColor Yellow

    $chunk | Set-Content -Path $newFilePath -Encoding UTF8
    $totalLinesWritten += $chunk.Count

    $summary += [PSCustomObject]@{
        FileName         = $newFileName
        LinesInFile      = $chunk.Count
        CumulativeLines  = $totalLinesWritten
        CreatedDateTime  = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    }

    $chunkIndex++
}

# --- Write summary CSV ---
$summary | Export-Csv -Path $summaryFile -NoTypeInformation -Encoding UTF8
Write-Host "Merge complete. Created $($chunkIndex - 1) merged files in $FolderPath" -ForegroundColor Cyan
Write-Host "Summary log saved to $summaryFile" -ForegroundColor Green

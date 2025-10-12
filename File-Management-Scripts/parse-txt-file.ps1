# Revision : 1.2
# Description : Make a timestamped copy of a .txt file and remove lines ending with file extensions (.msg, .xlsx, .docx, .pdf, etc.) or containing 11+ backslashes, with progress bar and summary. Rev 1.2
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-10-12
# Modified Date : 2025-10-12

param(
    [Parameter(Mandatory = $true)]
    [string]$InputFile
)

# Create timestamp for backup suffix
$datetime = Get-Date -Format 'yyyyMMdd-HHmmss'

# Define backup path
$backupFile = "$($InputFile)-backup-$datetime.txt"

# Copy the original file to backup
Copy-Item -Path $InputFile -Destination $backupFile -Force
Write-Host "Backup created : $backupFile" -ForegroundColor Cyan

# Get all lines
$allLines = Get-Content -Path $InputFile
$total = $allLines.Count
$filteredLines = @()
$removedCount = 0

# Define patterns to remove
$patterns = '\.msg$', '\.xlsx$', '\.docx$', '\.pdf$', '\.xls$', '\.doc$', '\.pptx$', '\.csv$', '\.zip$','\.log$','\.txt$','\.dcf$','\.dcfx$','\.xml$','\.xml.lock$','\.dwg$'


Write-Host "Processing $total lines ..." -ForegroundColor Yellow

# Process lines with progress bar
for ($i = 0; $i -lt $total; $i++) {
    $line = $allLines[$i]
    $remove = $false

    # Rule 1: remove if ends with certain file extensions
    foreach ($pattern in $patterns) {
        if ($line -match $pattern) {
            $remove = $true
            break
        }
    }

    # Rule 2: remove if contains 11 or more backslashes
    if (-not $remove) {
        $slashCount = ($line.ToCharArray() | Where-Object { $_ -eq '\' }).Count
        if ($slashCount -ge 11) {
            $remove = $true
        }
    }

    if (-not $remove) {
        $filteredLines += $line
    }
    else {
        $removedCount++
    }

    # Update progress bar
    $percent = [math]::Round(($i / $total) * 100, 2)
    Write-Progress -Activity "Parsing text file" -Status "Processing line $i of $total" -PercentComplete $percent
}

# Overwrite original file with cleaned content
$filteredLines | Set-Content -Path $InputFile -Encoding UTF8

# Show summary
$keptCount = $filteredLines.Count
Write-Host "Removed lines : $removedCount" -ForegroundColor Red
Write-Host "Kept lines : $keptCount" -ForegroundColor Green
Write-Host "Clean file saved to : $InputFile" -ForegroundColor Cyan
Write-Host "Operation complete at $(Get-Date)" -ForegroundColor Yellow

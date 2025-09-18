# Revision : 1.0
# Description : Check if the source Excel differs from the most-recent destination copy. If different, copy to destination with today's date suffix (e.g., 'Project List Download 090425.xlsx'). Rev 1.0
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-09-04
# Modified Date : 2025-09-04

# Need to define $onedrivepath variable if not already defined
if (-not $onedrivepath) {
    $onedrivepath = 'C:\users\jason.lamb\OneDrive - middough'
}

param(
    [string] $SourceFile = 'S:\Corporate\MIS\Project List Download.xlsx',
    [string] $DestFolder = "$onedrivepath\General - IT\U & N Drive clean up",
    [string] $BaseName   = 'Project List Download',      # filename prefix before the date
    [string] $SearchMask = 'Project List Download*.xlsx' # existing destination pattern
)

# --- Prep & validation ---
try {
    if (-not (Test-Path -LiteralPath $SourceFile)) {
        Write-Host "Source file not found : $SourceFile"
        exit 1
    }
    if (-not (Test-Path -LiteralPath $DestFolder)) {
        Write-Host "Destination folder not found, creating : $DestFolder"
        New-Item -ItemType Directory -Path $DestFolder -Force | Out-Null
    }

    # Find the latest destination file that matches the pattern
    $latestDest = Get-ChildItem -LiteralPath $DestFolder -Filter $SearchMask -File -ErrorAction SilentlyContinue |
                  Sort-Object LastWriteTime -Descending |
                  Select-Object -First 1

    # Compute hashes for comparison (if a prior copy exists)
    $srcHash = Get-FileHash -Algorithm SHA256 -LiteralPath $SourceFile
    $same = $false
    if ($latestDest) {
        $dstHash = Get-FileHash -Algorithm SHA256 -LiteralPath $latestDest.FullName
        $same = ($srcHash.Hash -eq $dstHash.Hash)
    }

    Write-Host "Source file : $SourceFile"
    if ($latestDest) {
        Write-Host "Latest destination file : $($latestDest.FullName)"
    } else {
        Write-Host "Latest destination file : (none found)"
    }

    if ($same) {
        Write-Host "Result : No differences detected. No copy performed."
        exit 0
    } else {
        # Build dated filename like 'Project List Download 090425.xlsx'
        $dateSuffix = Get-Date -Format 'MMddyy'
        $newName = "$BaseName $dateSuffix.xlsx"
        $destPath = Join-Path $DestFolder $newName

        # If a same-date file already exists, overwrite it (can change to unique if desired)
        Copy-Item -LiteralPath $SourceFile -Destination $destPath -Force

        Write-Host "Differences detected : Copied to $destPath"
        exit 0
    }
}
catch {
    Write-Host "Error : $_"
    exit 1
}

# Get-FolderList.ps1
# Prompts for one or more directories and exports a recursive folder list per directory to C:\temp\

$directories = @()

Write-Host "Enter directories to scan (one per line). Leave blank and press Enter when done."

while ($true) {
    $input = Read-Host "Directory"
    if ([string]::IsNullOrWhiteSpace($input)) { break }
    if (-not (Test-Path $input -PathType Container)) {
        Write-Warning "Path not found or is not a directory: $input"
    } else {
        $directories += $input
    }
}

if ($directories.Count -eq 0) {
    Write-Warning "No valid directories entered. Exiting."
    exit
}

if (-not (Test-Path "C:\temp")) {
    New-Item -ItemType Directory -Path "C:\temp" | Out-Null
}

$datetime = Get-Date -Format "yyyy-MM-dd_HHmmss"

foreach ($dir in $directories) {
    $folderName = Split-Path $dir -Leaf
    $logFile = "C:\temp\$datetime-$folderName-folders.log"

    Write-Host "Scanning: $dir"
    Get-ChildItem -Path $dir -Directory -Recurse |
        Select-Object -ExpandProperty FullName |
        Out-File -FilePath $logFile -Encoding utf8

    Write-Host "Log saved: $logFile"
}

Write-Host "`nDone. $($directories.Count) director$(if ($directories.Count -eq 1) {'y'} else {'ies'}) scanned."

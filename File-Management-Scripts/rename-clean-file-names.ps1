# Revision : 1.5
# Description : Clean file names only (no folder renames). 
#               Removes tildes, single quotes, leading/trailing underscores, trims spaces,
#               collapses double spaces, excludes RE_ email replies.
#               Creates per-directory change logs only when changes occur
#               and a master CSV audit log. Idempotent normalization (single-pass).
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2026-01-07
# Modified Date : 2026-01-07

# write-host needs to use single quotes for this alert
write-host "MAKE SURE to setup newpaths = @('\\server\folder1', '\\server\folder2', '\\server\folder3') before running this." -foregroundcolor YELLOW
write-host "USE DOUBLE QUOTES in array because a folder/file with single quote will mess up the array." -foregroundcolor YELLOW


$WhatIfMode = $true   # set to $false when ready

$logFolder = "C:\temp\powershell-exports"
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$masterLog = Join-Path $logFolder "file-rename-master-$timestamp.csv"

if (-not (Test-Path $logFolder)) {
    New-Item -Path $logFolder -ItemType Directory | Out-Null
}

function Get-CleanFileName {
    param ([string] $FileName)

    $name = [System.IO.Path]::GetFileNameWithoutExtension($FileName)
    $ext  = [System.IO.Path]::GetExtension($FileName)

    $clean = $name

    do {
        $previous = $clean

        $clean = $clean -replace '~', ''
        $clean = $clean -replace "'", ''
        $clean = $clean.Trim()

        while ($clean -match '  ') {
            $clean = $clean -replace '  ', ' '
        }

        $clean = $clean -replace '^_+', ''
        $clean = $clean -replace '_+$', ''

    } while ($clean -ne $previous)

    return "$clean$ext"
}

"Timestamp,Folder,OriginalName,NewName,Status" | Out-File -FilePath $masterLog -Encoding utf8

foreach ($path in $newPaths | Sort-Object -Unique) {

    if (-not (Test-Path $path)) {
        Write-Host "Path not found : $path"
        continue
    }

    Write-Host "Processing folder : $path"

    $directoryChanges = @()

    Get-ChildItem -Path $path -File | ForEach-Object {

        $originalName = $_.Name
        $cleanName    = $originalName
        $status       = "Skipped"

        if ($originalName -match '^(?i)RE_') {
            $status = "Excluded-RE"
        }
        else {
            $cleanName = Get-CleanFileName $originalName

            if ($originalName -ne $cleanName) {

                Write-Host "Rename file : $originalName -> $cleanName"

                if ($WhatIfMode) {
                    $status = "WhatIf"
                }
                else {
                    try {
                        Rename-Item -Path $_.FullName -NewName $cleanName
                        $status = "Renamed"
                    }
                    catch {
                        $status = "Error"
                    }
                }

                $directoryChanges += "$originalName -> $cleanName"
            }
        }

        $logLine = '"' + (Get-Date -Format "yyyy-MM-dd HH:mm:ss") + '","' +
                   $path + '","' +
                   $originalName + '","' +
                   $cleanName + '","' +
                   $status + '"'

        $logLine | Out-File -FilePath $masterLog -Append -Encoding utf8
    }

    if ($directoryChanges.Count -gt 0) {

        $dirLogName = "filename-changes-$timestamp.txt"
        $dirLogPath = Join-Path $path $dirLogName

        $header = @(
            "File name changes",
            "Directory : $path",
            "Timestamp : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')",
            ""
        )

        if (-not $WhatIfMode) {
            $header + $directoryChanges | Out-File -FilePath $dirLogPath -Encoding utf8
        }

        Write-Host "Directory log created : $dirLogPath"
    }
}

Write-Host "Master log written to $masterLog"

<# 
===========================
EXAMPLE RUN / USAGE
===========================

# 1. Define the folders to process
$newPaths = @(
    "\\middough.local\corp\data\dept\Cleveland\750\Share\Accts Payable\__PAID\2025 PAID\_ACHs\2025-12-23\Email"
)

# 2. Dry run first (recommended)
$WhatIfMode = $true
.\Clean-FileNames.ps1

# Review console output and per-directory logs (if any)

# 3. Run live after verification
$WhatIfMode = $false
.\Clean-FileNames.ps1

# 4. Review master log
Invoke-Item $masterlog

#>

# Revision : 1.1
# Description : Rename files within one or more target folders by trimming names, collapsing multiple spaces, and appending -1/-2 for duplicates; per-folder and global logs; optional recursion; dry run supported; exclusion folder array added. Rev 1.1
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-09-17
# Modified Date : 2025-09-17

param(
    [string[]] $TargetFolders = @(
        '\\middough.local\corp\data\dept\Cleveland\740'
    ),
    [switch] $Recurse = $true,
    [switch] $DryRun
)

# --- Setup -------------------------------------------------------------------
$logRoot = 'C:\temp\powershell-exports'
if (-not (Test-Path $logRoot)) {
    New-Item -Path $logRoot -ItemType Directory -Force | Out-Null
}
$timeStamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$globalLogFile = Join-Path $logRoot "file-name-trim-$timeStamp.log"

# Exclusions (folder names only, not full paths)
$ExcludeFolders = @(
    '!EgnyteTransfer'
)

# --- Helpers -----------------------------------------------------------------
function Write-GlobalLog {
    param([string] $Message)
    Add-Content -Path $globalLogFile -Value ("{0} | {1}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Message)
}

function Get-PerFolderLogPath {
    param([string] $FolderPath)
    $datePart = Get-Date -Format 'yyyyMMdd'
    return (Join-Path $FolderPath "file-name-trim-$datePart.log")
}

# --- Start -------------------------------------------------------------------
Write-Host "Starting rename in $($TargetFolders.Count) folder(s) : $((Get-Date).ToString('yyyy-MM-dd HH:mm:ss'))"
Write-GlobalLog "START for $($TargetFolders -join '; ')"

foreach ($folder in $TargetFolders) {
    if ([string]::IsNullOrWhiteSpace($folder)) {
        Write-Host "Skipped (blank folder entry)"
        Write-GlobalLog "SKIPPED - BLANK FOLDER ENTRY"
        continue
    }

    if (-not (Test-Path -LiteralPath $folder)) {
        Write-Host "Folder not found : $folder"
        Write-GlobalLog "NOT FOUND : $folder"
        continue
    }

    Write-Host "Scanning folder : $folder"
    try {
        $files = Get-ChildItem -LiteralPath $folder -File -Recurse:$Recurse -Force -ErrorAction Stop |
                 Where-Object {
                     # Exclude any file where *any* parent folder matches exclusion list
                     ($_.FullName.Split([IO.Path]::DirectorySeparatorChar) | Where-Object { $ExcludeFolders -contains $_ }) -eq $null
                 }
    } catch {
        Write-Host "Error reading $folder : $($_.Exception.Message)"
        Write-GlobalLog "ERROR reading '$folder' : $($_.Exception.Message)"
        continue
    }

    $total = $files.Count
    Write-Host "Files detected (after exclusions) : $total"

    $i = 0
    foreach ($file in $files) {
        $i++
        $currentPath = $file.FullName
        Write-Host "Processing $i of $total : $currentPath"

        $parentDir = $file.DirectoryName
        $folderLog = Get-PerFolderLogPath -FolderPath $parentDir

        $originalName = $file.Name
        $extension = [System.IO.Path]::GetExtension($originalName)
        $nameNoExt = [System.IO.Path]::GetFileNameWithoutExtension($originalName)

        # Clean : trim and collapse 2+ spaces to 1
        $cleanBase = ($nameNoExt.Trim() -replace '\s{2,}', ' ')
        $proposedName = "$cleanBase$extension"

        # If no change, skip
        if ($proposedName -ceq $originalName) {
            Write-Host "Skipped (no change) : $originalName"
            continue
        }

        # Resolve duplicates by appending -1, -2, ...
        $baseForDup = [System.IO.Path]::GetFileNameWithoutExtension($proposedName)
        $targetPath = Join-Path $parentDir $proposedName
        $suffix = 1
        while ((Test-Path -LiteralPath $targetPath) -and ($targetPath -ne $currentPath)) {
            $newName = "$baseForDup-$suffix$extension"
            $targetPath = Join-Path $parentDir $newName
            $suffix++
        }
        $finalName = Split-Path $targetPath -Leaf

        $logLine = "OLD : '$originalName' | NEW : '$finalName' | IN : '$parentDir'"

        if ($DryRun) {
            Write-Host "Dry run : '$originalName' --> '$finalName'"
            Write-GlobalLog "DRYRUN - $logLine"
            try {
                Add-Content -Path $folderLog -Value ("{0} | DRYRUN - OLD : '{1}' | NEW : '{2}'" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $originalName, $finalName)
            } catch {
                Write-Host "Could not write to folder log : $folderLog - $($_.Exception.Message)"
                Write-GlobalLog "ERROR writing folder log '$folderLog' : $($_.Exception.Message)"
            }
            continue
        }

        try {
            Rename-Item -LiteralPath $currentPath -NewName $finalName -ErrorAction Stop
            Write-Host "Renamed : '$originalName' --> '$finalName'"
            Write-GlobalLog $logLine
            try {
                Add-Content -Path $folderLog -Value ("{0} | OLD : '{1}' | NEW : '{2}'" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $originalName, $finalName)
            } catch {
                Write-Host "Could not write to folder log : $folderLog - $($_.Exception.Message)"
                Write-GlobalLog "ERROR writing folder log '$folderLog' : $($_.Exception.Message)"
            }
        } catch {
            Write-Host "Error on $currentPath : $($_.Exception.Message)"
            Write-GlobalLog ("ERROR - '{0}' : {1}" -f $currentPath, $_.Exception.Message)
        }
    }

    Write-Host "Completed folder : $folder"
    Write-GlobalLog "COMPLETED : $folder"
}

Write-Host "All done : global log at $globalLogFile"
Start-Process notepad.exe -ArgumentList "`"$globalLogFile`""

# Revision : 1.3
# Description : Rename OneDrive host-conflict files by removing the computer name token and appending "-onedriveconflict<3-char nonce>". Logs original -> new with timestamp to a single rolling CSV log. Adds exclusion of specific folders. Rev 1.3
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-10-09
# Modified Date : 2025-10-09

function Rename-OneDriveConflicts {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string]$Path,

        # Single rolling log file (appends forever)
        [string]$LogFile = 'C:\temp\powershell-exports\onedrive-conflicts.log',

        # Hostname fragments to strip (OneDrive-added)
        [string[]]$HostFragments = @(
            'CLEW112GFF814',
            'CLE3RF6G94'
        ),

        # Folders to ignore (files under these paths will not be processed)
        [string[]]$ExcludePaths = @(
            "$GitHubPath\PowerShell Transcript",
            "$onedrivepath\Downloads\OneDrive_1_5-15-2025\PowerShell Transcript"
        ),

        # Recurse into subfolders
        [switch]$Recurse,

        # Include .git internals (off by default)
        [switch]$IncludeGit
    )

    begin {
        try {
            if (-not (Test-Path $Path)) {
                throw "Path not found : $Path"
            }

            $logDir = Split-Path $LogFile -Parent
            if (-not (Test-Path $logDir)) {
                New-Item -ItemType Directory -Path $logDir -Force | Out-Null
            }

            if (-not (Test-Path $LogFile)) {
                'Timestamp,OriginalPath,NewPath' | Out-File -FilePath $LogFile -Encoding UTF8
            }

            # Build a single regex that matches "-<fragment>" for any fragment
            $escaped = $HostFragments | ForEach-Object { [Regex]::Escape($_) }
            $global:__ConflictRegex = "-($($escaped -join '|'))"

            # Normalize exclude roots (remove trailing \, full paths, case-insensitive)
            $global:__ExcludeRoots = $ExcludePaths |
                Where-Object { $_ -and (Test-Path $_) } |
                ForEach-Object {
                    ([IO.Path]::GetFullPath($_)).TrimEnd('\')
                }

            Write-Host "Scanning path : $Path" -ForegroundColor Cyan
            Write-Host "Log file       : $LogFile" -ForegroundColor DarkCyan
            Write-Host "Fragments      : $($HostFragments -join '; ')" -ForegroundColor DarkCyan
            if ($__ExcludeRoots.Count -gt 0) {
                Write-Host "Excluded roots : $($global:__ExcludeRoots -join '; ')" -ForegroundColor DarkYellow
            } else {
                Write-Host "Excluded roots : (none resolved)" -ForegroundColor DarkYellow
            }
            Write-Host "Regex          : $__ConflictRegex" -ForegroundColor DarkGray
        }
        catch {
            Write-Host "Error initializing : $_" -ForegroundColor Red
            return
        }
    }
    process {
        try {
            function Test-IsExcludedPath {
                param([string]$FullPath)
                $fp = ([IO.Path]::GetFullPath($FullPath)).TrimEnd('\')
                foreach ($root in $global:__ExcludeRoots) {
                    if ($fp.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase)) {
                        return $true
                    }
                }
                return $false
            }

            $gciParams = @{ Path = $Path; File = $true; ErrorAction = 'SilentlyContinue' }
            if ($Recurse) { $gciParams['Recurse'] = $true }

            $allFiles = Get-ChildItem @gciParams

            # Exclude .git unless explicitly included
            if (-not $IncludeGit) {
                $allFiles = $allFiles | Where-Object {
                    $_.FullName -notmatch '\\\.git(\\|$)'
                }
            }

            # Exclude specified roots
            if ($__ExcludeRoots.Count -gt 0) {
                $allFiles = $allFiles | Where-Object { -not (Test-IsExcludedPath -FullPath $_.FullName) }
            }

            # Candidates : file names whose BaseName contains "-<fragment>"
            $candidates = $allFiles | Where-Object {
                $_.BaseName -match $__ConflictRegex
            }

            Write-Host "Found candidates : $($candidates.Count)" -ForegroundColor Yellow

            $renamed = 0
            foreach ($file in $candidates) {
                $dir  = $file.DirectoryName
                $ext  = $file.Extension
                $base = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)

                # 3-char nonce A-Z0-9
                $nonce = -join ((65..90 + 48..57) | Get-Random -Count 3 | ForEach-Object { [char]$_ })

                # Replace exactly the -<fragment> segment with -onedriveconflict<nonce>
                $newBase = [Regex]::Replace($base, $__ConflictRegex, "-onedriveconflict$nonce")

                $newName = "$newBase$ext"
                $newFull = Join-Path $dir $newName

                if ($newFull -ieq $file.FullName) {
                    continue
                }

                if ($PSCmdlet.ShouldProcess($file.FullName, "Rename to $newName")) {
                    try {
                        Rename-Item -Path $file.FullName -NewName $newName -ErrorAction Stop

                        $timestamp = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
                        $csvLine = '"{0}","{1}","{2}"' -f $timestamp, $file.FullName.Replace('"','""'), $newFull.Replace('"','""')
                        Add-Content -Path $LogFile -Value $csvLine -Encoding UTF8

                        Write-Host "Renamed : $($file.FullName)" -ForegroundColor Green
                        Write-Host "    New : $newFull" -ForegroundColor DarkGreen
                        $renamed++
                    }
                    catch {
                        Write-Host "Failed to rename $($file.FullName) : $_" -ForegroundColor Red
                    }
                }
            }

            Write-Host "Total renamed : $renamed" -ForegroundColor Green
            Write-Host "Log updated   : $LogFile" -ForegroundColor Gray
        }
        catch {
            Write-Host "Error during processing : $_" -ForegroundColor Red
        }
    }
}

<# ======================
Examples

# Dry run first (recommended)
Rename-OneDriveConflicts -Path "$GitHubPath\PowerShell' -Recurse -WhatIf

# Actual rename with exclusions (defaults above)
Rename-OneDriveConflicts -Path "$GitHubPath\PowerShell' -Recurse

# Override or add more exclusions
Rename-OneDriveConflicts -Path "$onedrivepath -Recurse -whatif -ExcludePaths @(
    "$GitHubPath\PowerShell Transcript',
    'C:\Users\jason.lamb\OneDrive - middough\Downloads\OneDrive_1_5-15-2025\PowerShell Transcript'
)

# Include .git internals if needed (not typical)
Rename-OneDriveConflicts -Path "$GitHubPath\PowerShell' -Recurse -IncludeGit
====================== #>


<# ======================
Examples

# Dry run first (recommended)
Rename-OneDriveConflicts -Path "$GitHubPath\PowerShell" -Recurse -WhatIf

# Actual rename, excluding .git internals (default)
Rename-OneDriveConflicts -Path "$GitHubPath\PowerShell" -Recurse

# Include .git internals if needed (not typical)
Rename-OneDriveConflicts -Path "$GitHubPath\PowerShell" -Recurse -IncludeGit

# This will turn:
#   test-file-CLEW112GFF814.ps1  ->  test-file-onedriveconflictABC.ps1
# where ABC is a 3-character nonce.
====================== #>


# Example:
# Rename-OneDriveConflicts -Path "$githubpath\PowerShell" -Recurse -whatif
# Rename-OneDriveConflicts -Path 'C:\Temp\Test' -Recurse -WhatIf

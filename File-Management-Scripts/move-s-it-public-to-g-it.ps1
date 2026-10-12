# Filename: move-s-it-public-to-g-it.ps1
# Revision : 1.1.0
# Description : Moves all files from S:\IT Public to G:\IT without overwriting existing files, using the admin.jlamb credential
# Author : Jason Lamb
# Created Date : 2026-09-28
# Modified Date : 2026-09-28
# Changelog :
# 1.1.0 Access the source/target shares as admin.jlamb via the saved credential file instead of the current user's mapped drives

####################
# Configuration
####################

# Saved via: Get-Credential -Message 'Enter credentials for admin.jlamb' | Export-Clixml -Path 'C:\Users\Jason.Lamb\.creds\admin.jlamb.xml'
# Hardcoded (not $env:USERPROFILE) because this DPAPI-protected file can only be decrypted
# by the Jason.Lamb Windows account that created it, regardless of which account runs this script
$credentialPath = 'C:\Users\Jason.Lamb\.creds\admin.jlamb.xml'

# S:\ and G:\ map to these UNC paths (per `net use`) so the admin.jlamb credential
# can be used via New-PSDrive without depending on the current user's drive mappings
$sourceUNC = '\\altfs01v\Common\IT Public'
$targetUNC = '\\altfs01v\Groups\IT'

$sourceDriveName = 'MoveSITPublicSrc'
$targetDriveName = 'MoveSITPublicDst'

# Files/folders to KEEP in S:\IT Public (not moved to G:\IT)
# Add patterns or names that should stay in the public folder
# Examples: 'SharedFolder', '*.txt', 'readme.md', 'archive'
$keepInPublic = @(
    'MPM Backup Restore'
    'OfficeSetup.exe'
    'Ninite TeamViewer Installer.exe'
    'Ninite Everything Installer.exe'
    'Map-AltronicDrives.bat'
    'classic.theme'
    'HR-Training Public Desktop'
)

####################
# Connect as admin.jlamb
####################

if (-not (Test-Path -LiteralPath $credentialPath)) {
    Write-Host "Credential file not found: $credentialPath" -ForegroundColor Red
    Write-Host "Create it first, e.g.:" -ForegroundColor Yellow
    Write-Host "  Get-Credential -Message 'Enter credentials for admin.jlamb' | Export-Clixml -Path '$credentialPath'" -ForegroundColor Yellow
    exit 1
}
$credential = Import-Clixml -Path $credentialPath

Remove-PSDrive -Name $sourceDriveName, $targetDriveName -ErrorAction SilentlyContinue
try {
    New-PSDrive -Name $sourceDriveName -PSProvider FileSystem -Root $sourceUNC -Credential $credential -Scope Script -ErrorAction Stop | Out-Null
    New-PSDrive -Name $targetDriveName -PSProvider FileSystem -Root $targetUNC -Credential $credential -Scope Script -ErrorAction Stop | Out-Null
} catch {
    Write-Host "Failed to connect as $($credential.UserName): $_" -ForegroundColor Red
    exit 1
}

$sourceDir = "${sourceDriveName}:\"
$targetDir = "${targetDriveName}:\"

####################
# Validation
####################

if (-not (Test-Path $sourceDir)) {
    Write-Host "Source directory not found: $sourceDir" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $targetDir)) {
    Write-Host "Target directory not found: $targetDir" -ForegroundColor Red
    exit 1
}

####################
# Move Files
####################

$movedCount = 0
$skippedCount = 0
$errorCount = 0

Get-ChildItem -Path $sourceDir -Recurse -Force | ForEach-Object {
    $item = $_
    $relativePath = $item.FullName.Substring($sourceDir.Length).TrimStart('\')
    $targetPath = Join-Path $targetDir $relativePath

    # Check if item should be kept in public folder
    $shouldKeep = $false
    foreach ($pattern in $keepInPublic) {
        if ($item.Name -like $pattern -or $relativePath -like $pattern) {
            $shouldKeep = $true
            break
        }
    }

    if ($shouldKeep) {
        Write-Host "  [KEEP] $relativePath (staying in public)" -ForegroundColor DarkGray
        $skippedCount++
        return
    }

    # Handle directories
    if ($item.PSIsContainer) {
        if (-not (Test-Path $targetPath)) {
            try {
                New-Item -ItemType Directory -Path $targetPath -Force | Out-Null
                Write-Host "  [MKDIR] $relativePath" -ForegroundColor Cyan
            } catch {
                Write-Host "  [ERROR] Failed to create directory: $relativePath" -ForegroundColor Red
                Write-Host "          $_" -ForegroundColor Red
                $errorCount++
            }
        }
        return
    }

    # Handle files: check for conflicts
    if (Test-Path $targetPath) {
        Write-Host "  [EXISTS] $relativePath (skipped, target already exists)" -ForegroundColor Yellow
        $skippedCount++
        return
    }

    # Move the file
    try {
        $targetParent = Split-Path $targetPath
        if (-not (Test-Path $targetParent)) {
            New-Item -ItemType Directory -Path $targetParent -Force | Out-Null
        }
        Move-Item -Path $item.FullName -Destination $targetPath -Force
        Write-Host "  [MOVED] $relativePath" -ForegroundColor Green
        $movedCount++
    } catch {
        Write-Host "  [ERROR] Failed to move: $relativePath" -ForegroundColor Red
        Write-Host "          $_" -ForegroundColor Red
        $errorCount++
    }
}

####################
# Summary
####################

Write-Host "`nSummary:" -ForegroundColor Cyan
Write-Host "  Moved:   $movedCount" -ForegroundColor Green
Write-Host "  Skipped: $skippedCount" -ForegroundColor Yellow
Write-Host "  Errors:  $errorCount" -ForegroundColor Red

Remove-PSDrive -Name $sourceDriveName, $targetDriveName -ErrorAction SilentlyContinue

if ($errorCount -gt 0) {
    exit 1
}

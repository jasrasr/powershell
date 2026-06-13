# Filename: git-update-all.ps1
# Revision : 1.0.0
# Description : Run git-update.ps1 against every Git repository below a parent folder.
# Author : Jason Lamb
# Created Date : 2026-06-13
# Modified Date : 2026-06-13
# Changelog :
# 1.0.0 initial release

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateScript({ Test-Path $_ -PathType Container })]
    [string]$ParentPath = (Get-Location).Path,

    [Parameter(Mandatory = $false)]
    [ValidateScript({ Test-Path $_ -PathType Leaf })]
    [string]$GitUpdateScript = (Join-Path $PSScriptRoot 'git-update.ps1'),

    [Parameter(Mandatory = $false)]
    [switch]$Quick
)

function Find-GitRepository {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $resolvedParent = (Resolve-Path -Path $Path).Path
    $gitMarkers = @()

    $rootGitPath = Join-Path $resolvedParent '.git'
    if (Test-Path -LiteralPath $rootGitPath) {
        $gitMarkers += Get-Item -LiteralPath $rootGitPath -Force
    }

    $gitMarkers += Get-ChildItem -Path $resolvedParent -Recurse -Force -Filter '.git' -ErrorAction SilentlyContinue

    $repoPaths = foreach ($marker in $gitMarkers) {
        if ($marker.PSIsContainer) {
            Split-Path -Parent $marker.FullName
        } else {
            $marker.DirectoryName
        }
    }

    $repoPaths |
        Sort-Object -Unique |
        ForEach-Object {
            [pscustomobject]@{
                Name = Split-Path -Leaf $_
                Path = $_
            }
        }
}

. $GitUpdateScript

if (-not (Get-Command -Name git-update -CommandType Function -ErrorAction SilentlyContinue)) {
    throw "git-update function was not loaded from '$GitUpdateScript'."
}

$repositories = @(Find-GitRepository -Path $ParentPath)

if ($repositories.Count -eq 0) {
    Write-Host "No Git repositories found under '$ParentPath'." -ForegroundColor Yellow
    return
}

Write-Host "Found $($repositories.Count) Git repositor$(if ($repositories.Count -eq 1) { 'y' } else { 'ies' }) under '$ParentPath'." -ForegroundColor Cyan

$originalLocation = (Get-Location).ProviderPath

try {
    foreach ($repository in $repositories) {
        Write-Host ""
        Write-Host "=== $($repository.Name) ===" -ForegroundColor Magenta
        Write-Host $repository.Path -ForegroundColor DarkGray

        Push-Location -LiteralPath $repository.Path
        try {
            if ($Quick) {
                git-update -Quick
            } else {
                git-update
            }
        }
        catch {
            Write-Host "git-update failed for '$($repository.Path)': $_" -ForegroundColor Red
        }
        finally {
            Pop-Location
        }
    }
}
finally {
    Set-Location -LiteralPath $originalLocation
}

Write-Host ""
Write-Host "Finished running git-update for discovered repositories." -ForegroundColor Green

# Example usage:
#   .\git-update-all.ps1 -ParentPath "C:\Users\jason\Github" -Quick
#   .\git-update-all.ps1

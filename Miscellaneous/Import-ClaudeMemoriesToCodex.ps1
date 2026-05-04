# Filename: Import-ClaudeMemoriesToCodex.ps1
# Revision : 1.0.0
# Description : Import Claude Code CLI memory files into Codex memories, filtering global instructions down to durable user preferences
# Author : Jason Lamb (with help from Codex)
# Created Date : 2026-05-04
# Modified Date : 2026-05-04
# Changelog :
# 1.0.0 initial release

[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$ClaudePath = (Join-Path $HOME '.claude'),
    [string]$CodexPath = (Join-Path $HOME '.codex\memories'),
    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Convert-ToSlug {
    param(
        [Parameter(Mandatory)]
        [string]$Text
    )

    $slug = $Text.ToLowerInvariant()
    $slug = $slug -replace '[^a-z0-9]+', '-'
    $slug = $slug.Trim('-')

    if ([string]::IsNullOrWhiteSpace($slug)) {
        return 'memory'
    }

    return $slug
}

function Get-MarkdownSections {
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    $lines = Get-Content -LiteralPath $Path
    $sections = New-Object System.Collections.Generic.List[object]
    $currentTitle = ''
    $currentLines = New-Object System.Collections.Generic.List[string]

    foreach ($line in $lines) {
        if ($line -match '^(##)\s+(.+?)\s*$') {
            if ($currentTitle) {
                $sections.Add([pscustomobject]@{
                    Title   = $currentTitle
                    Content = ($currentLines -join [Environment]::NewLine).Trim()
                })
            }

            $currentTitle = $Matches[2].Trim()
            $currentLines = New-Object System.Collections.Generic.List[string]
            continue
        }

        if ($currentTitle) {
            $currentLines.Add($line)
        }
    }

    if ($currentTitle) {
        $sections.Add([pscustomobject]@{
            Title   = $currentTitle
            Content = ($currentLines -join [Environment]::NewLine).Trim()
        })
    }

    return $sections
}

function New-CodexMemoryFile {
    param(
        [Parameter(Mandatory)]
        [string]$TargetPath,

        [Parameter(Mandatory)]
        [string]$Content,

        [switch]$Overwrite
    )

    if ((Test-Path -LiteralPath $TargetPath) -and -not $Overwrite) {
        Write-Host "Skipping existing memory: $TargetPath" -ForegroundColor DarkYellow
        return
    }

    if ($PSCmdlet.ShouldProcess($TargetPath, 'Write memory file')) {
        Set-Content -LiteralPath $TargetPath -Value $Content -Encoding UTF8
        Write-Host "Wrote memory: $TargetPath" -ForegroundColor Green
    }
}

if (-not (Test-Path -LiteralPath $ClaudePath -PathType Container)) {
    throw "Claude path not found: $ClaudePath"
}

if (-not (Test-Path -LiteralPath $CodexPath -PathType Container)) {
    New-Item -ItemType Directory -Path $CodexPath -Force | Out-Null
}

$claudeMemoryPath = Join-Path $ClaudePath 'memory'
$claudeGlobalPath = Join-Path $ClaudePath 'CLAUDE.md'

if (Test-Path -LiteralPath $claudeMemoryPath -PathType Container) {
    Get-ChildItem -LiteralPath $claudeMemoryPath -Filter *.md -File | ForEach-Object {
        $targetName = ($_.BaseName -replace '_', '-')
        $targetPath = Join-Path $CodexPath "$targetName.md"
        $content = Get-Content -LiteralPath $_.FullName -Raw
        New-CodexMemoryFile -TargetPath $targetPath -Content $content.Trim() -Overwrite:$Force
    }
}

if (Test-Path -LiteralPath $claudeGlobalPath -PathType Leaf) {
    $wantedSections = @(
        'PowerShell Script Header',
        'PowerShell Script Footer',
        'File Save Locations',
        'PowerShell Module Dependencies',
        'PowerShell Module Connections (Connect-* cmdlets)',
        'Screenshots'
    )

    $skipPatterns = @(
        'GitHub Auto-Sync',
        'Claude',
        'hook',
        'PostToolUse'
    )

    $sections = Get-MarkdownSections -Path $claudeGlobalPath | Where-Object {
        $title = $_.Title
        ($wantedSections -contains $title) -and -not ($skipPatterns | Where-Object { $title -like "*$_*" })
    }

    foreach ($section in $sections) {
        if ([string]::IsNullOrWhiteSpace($section.Content)) {
            continue
        }

        $slug = Convert-ToSlug -Text $section.Title
        $targetPath = Join-Path $CodexPath "$slug.md"
        $body = @(
            "$($section.Title)"
            ''
            $section.Content.Trim()
        ) -join [Environment]::NewLine

        New-CodexMemoryFile -TargetPath $targetPath -Content $body -Overwrite:$Force
    }
}

# Example Usage:
#   .\Import-ClaudeMemoriesToCodex.ps1
#   .\Import-ClaudeMemoriesToCodex.ps1 -Force
#   .\Import-ClaudeMemoriesToCodex.ps1 -WhatIf
#   .\Import-ClaudeMemoriesToCodex.ps1 -ClaudePath "C:\Users\Jason.Lamb\.claude" -CodexPath "C:\Users\Jason.Lamb\.codex\memories"

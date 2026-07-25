# Filename: Find-ScriptsMissingHeader.ps1
# Revision : 1.1.0
# Description : Scans a folder for PowerShell scripts that are missing Jason-style
#               commented headers or are missing required header fields. Can also
#               export AI-ready prompt files with script context and Git history.
# Author : Jason Lamb (with help from Codex)
# Created Date : 2026-07-25
# Modified Date : 2026-07-25
# Changelog :
# 1.0.0 initial release
# 1.1.0 optionally flag scripts whose Revision header is still 1.0 or 1.0.0
#       even though Git shows multiple commits touched the file

[CmdletBinding()]
param(
    # Folder to scan for PowerShell scripts.
    [string]$Path = (Get-Location).Path,

    # Search child folders recursively.
    [switch]$Recurse,

    # PowerShell file patterns to inspect.
    [string[]]$Include = @('*.ps1', '*.psm1'),

    # Required Jason-style header labels.
    [string[]]$RequiredFields = @(
        'Filename',
        'Revision',
        'Description',
        'Author',
        'Created Date',
        'Modified Date',
        'Changelog'
    ),

    # Only return files missing a full header.
    [switch]$MissingOnly,

    # Optional CSV export path for the audit results.
    [string]$CsvPath,

    # Return audit objects to the pipeline in addition to the default table output.
    [switch]$PassThru,

    # Check whether Revision values like 1.0 / 1.0.0 look stale compared to Git history.
    [switch]$CheckRevisionHistory,

    # Create one AI prompt text file per flagged script in this folder.
    [string]$PromptOutputPath,

    # Include Git commit history in AI prompt files when the script is inside a Git repo.
    [switch]$IncludeGitHistory,

    # Number of commit subjects to include in prompt context.
    [ValidateRange(1, 50)]
    [int]$GitCommitCount = 8,

    # Number of script lines to include in prompt context.
    [ValidateRange(20, 250)]
    [int]$PreviewLineCount = 80
)

$ErrorActionPreference = 'Stop'

function Get-HeaderAuditResult {
    param(
        [Parameter(Mandatory)]
        [string]$FilePath,

        [Parameter(Mandatory)]
        [string[]]$Fields
    )

    $lines = Get-Content -LiteralPath $FilePath -ErrorAction Stop
    $headerWindow = if ($lines.Count -gt 40) { $lines[0..39] } else { $lines }

    $presentFields = foreach ($field in $Fields) {
        if ($headerWindow -match "^\s*#\s*$([regex]::Escape($field))\s*:") {
            $field
        }
    }

    $revisionValue = $null
    foreach ($line in $headerWindow) {
        if ($line -match '^\s*#\s*Revision\s*:\s*(?<value>.+?)\s*$') {
            $revisionValue = $Matches.value.Trim()
            break
        }
    }

    $missingFields = $Fields | Where-Object { $_ -notin $presentFields }
    $headerLabelCount = @($presentFields).Count

    $status = if ($headerLabelCount -eq 0) {
        'MissingHeader'
    } elseif ($missingFields.Count -gt 0) {
        'IncompleteHeader'
    } else {
        'HasHeader'
    }

    [PSCustomObject]@{
        ScriptPath     = $FilePath
        FileName       = [System.IO.Path]::GetFileName($FilePath)
        Status         = $status
        PresentFields  = ($presentFields -join ', ')
        MissingFields  = ($missingFields -join ', ')
        Revision       = $revisionValue
        HasFullHeader  = ($status -eq 'HasHeader')
    }
}

function Get-GitContext {
    param(
        [Parameter(Mandatory)]
        [string]$FilePath,

        [Parameter(Mandatory)]
        [int]$CommitCount
    )

    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        return $null
    }

    $directory = Split-Path -Path $FilePath -Parent
    $repoRoot = git -C $directory rev-parse --show-toplevel 2>$null
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($repoRoot)) {
        return $null
    }

    $resolvedRepoRoot = [System.IO.Path]::GetFullPath($repoRoot.Trim())
    $resolvedFilePath = [System.IO.Path]::GetFullPath($FilePath)

    if (-not $resolvedFilePath.StartsWith($resolvedRepoRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $null
    }

    $relativePath = [System.IO.Path]::GetRelativePath($resolvedRepoRoot, $resolvedFilePath)
    $format = '%h%x1f%ad%x1f%s'
    $rawLog = git -C $resolvedRepoRoot log --follow "--date=short" "--pretty=format:$format" "-n" $CommitCount -- $relativePath 2>$null
    $rawCount = git -C $resolvedRepoRoot rev-list --count HEAD -- $relativePath 2>$null
    $commitTotal = if ($LASTEXITCODE -eq 0 -and $rawCount -match '^\d+$') {
        [int]$rawCount
    } else {
        $null
    }

    if ($LASTEXITCODE -ne 0 -or -not $rawLog) {
        return [PSCustomObject]@{
            RepoRoot        = $resolvedRepoRoot
            RelativePath    = $relativePath
            CommitCount     = $commitTotal
            CommitSummaries = @()
        }
    }

    $summaries = foreach ($line in $rawLog) {
        $parts = $line -split [char]0x1f, 3
        if ($parts.Count -ge 3) {
            '{0} {1} {2}' -f $parts[1], $parts[0], $parts[2]
        }
    }

    [PSCustomObject]@{
        RepoRoot         = $resolvedRepoRoot
        RelativePath     = $relativePath
        CommitCount      = $commitTotal
        CommitSummaries  = @($summaries)
    }
}

function Test-RevisionNeedsAttention {
    param(
        [Parameter(Mandatory)]
        [pscustomobject]$AuditResult,

        [pscustomobject]$GitContext
    )

    if (-not $AuditResult.Revision) {
        return $null
    }

    if ($AuditResult.Revision -notin @('1.0', '1.0.0')) {
        return $null
    }

    if (-not $GitContext -or $null -eq $GitContext.CommitCount) {
        return $null
    }

    if ($GitContext.CommitCount -le 1) {
        return $null
    }

    return "Revision header is $($AuditResult.Revision) but Git shows $($GitContext.CommitCount) commits touched this file"
}

function New-AiPromptFile {
    param(
        [Parameter(Mandatory)]
        [pscustomobject]$AuditResult,

        [Parameter(Mandatory)]
        [string]$OutputFolder,

        [Parameter(Mandatory)]
        [int]$PreviewLines,

        [switch]$UseGitHistory,

        [Parameter(Mandatory)]
        [int]$CommitCount
    )

    $scriptPreview = Get-Content -LiteralPath $AuditResult.ScriptPath -TotalCount $PreviewLines
    $gitContext = if ($UseGitHistory) {
        Get-GitContext -FilePath $AuditResult.ScriptPath -CommitCount $CommitCount
    }

    $commitBlock = if ($gitContext -and $gitContext.CommitSummaries.Count -gt 0) {
        @(
            'Git commit history (newest first):'
            $gitContext.CommitSummaries
        ) -join [Environment]::NewLine
    } elseif ($UseGitHistory) {
        'Git commit history: not available for this file.'
    } else {
        'Git commit history: not requested.'
    }

    $prompt = @(
        'Create or repair a Jason-style PowerShell comment header for this script.'
        ''
        'Rules:'
        '- Return only the header comment block.'
        '- Do not change any code.'
        '- Use this exact field order:'
        '  Filename'
        '  Revision'
        '  Description'
        '  Author'
        '  Created Date'
        '  Modified Date'
        '  Changelog'
        '- Keep the description concise but specific to what the script does.'
        '- If the script appears to have a change history, use the Git commits below to draft a short changelog.'
        '- If history is unclear, use a minimal changelog such as 1.0.0 initial release.'
        '- Preserve any existing field values when they are already present and sensible.'
        ''
        "Script path: $($AuditResult.ScriptPath)"
        "Audit status: $($AuditResult.Status)"
        "Missing fields: $($AuditResult.MissingFields)"
        "Current revision: $($AuditResult.Revision)"
        "Revision history warning: $($AuditResult.RevisionWarning)"
        ''
        $commitBlock
        ''
        'Script preview:'
        '```powershell'
        ($scriptPreview -join [Environment]::NewLine)
        '```'
    ) -join [Environment]::NewLine

    $safeName = [System.IO.Path]::GetFileNameWithoutExtension($AuditResult.FileName)
    $promptFile = Join-Path -Path $OutputFolder -ChildPath "$safeName.header-prompt.txt"
    Set-Content -LiteralPath $promptFile -Value $prompt -Encoding UTF8
    return $promptFile
}

if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
    throw "Path does not exist or is not a folder: $Path"
}

if ($PromptOutputPath) {
    New-Item -ItemType Directory -Path $PromptOutputPath -Force | Out-Null
}

$files = foreach ($pattern in $Include) {
    Get-ChildItem -LiteralPath $Path -File -Filter $pattern -Recurse:$Recurse
}

$auditResults = $files |
    Sort-Object -Property FullName -Unique |
    ForEach-Object {
        Get-HeaderAuditResult -FilePath $_.FullName -Fields $RequiredFields
    }

if ($CheckRevisionHistory -or $IncludeGitHistory) {
    foreach ($result in $auditResults) {
        $gitContext = Get-GitContext -FilePath $result.ScriptPath -CommitCount $GitCommitCount
        $revisionWarning = Test-RevisionNeedsAttention -AuditResult $result -GitContext $gitContext

        $result | Add-Member -NotePropertyName GitCommitCount -NotePropertyValue $(if ($gitContext) { $gitContext.CommitCount } else { $null })
        $result | Add-Member -NotePropertyName RevisionWarning -NotePropertyValue $revisionWarning

        if ($CheckRevisionHistory -and $revisionWarning -and $result.Status -eq 'HasHeader') {
            $result.Status = 'RevisionHistoryMismatch'
        }
    }
}

if ($MissingOnly -or $PromptOutputPath) {
    $auditResults = $auditResults | Where-Object {
        (-not $_.HasFullHeader) -or
        ($CheckRevisionHistory -and -not [string]::IsNullOrWhiteSpace($_.RevisionWarning))
    }
}

if ($PromptOutputPath) {
    foreach ($result in $auditResults) {
        $promptFile = New-AiPromptFile `
            -AuditResult $result `
            -OutputFolder $PromptOutputPath `
            -PreviewLines $PreviewLineCount `
            -UseGitHistory:$IncludeGitHistory `
            -CommitCount $GitCommitCount

        $result | Add-Member -NotePropertyName PromptFile -NotePropertyValue $promptFile
    }
}

if ($CsvPath) {
    $auditResults | Export-Csv -LiteralPath $CsvPath -NoTypeInformation -Encoding UTF8
}

if ($PassThru) {
    $auditResults
} else {
    $auditResults |
        Select-Object FileName, Status, Revision, GitCommitCount, MissingFields, RevisionWarning, ScriptPath, PromptFile |
        Format-Table -AutoSize
}

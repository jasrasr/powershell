# Filename: get-github-repo-issues.ps1
# Revision : 1.1.0
# Description : Export open GitHub issues and create a Codex-ready task prompt
# Author : Jason Lamb (with help from Codex CLI)
# Created Date : 2026-06-03
# Modified Date : 2026-06-03
# Changelog :
# 1.0.0 initial release
# 1.1.0 made repository input and output paths generic for public sharing

<#
.SYNOPSIS
Exports open GitHub issues and creates a Codex-ready task prompt.

.DESCRIPTION
Uses GitHub CLI to export open GitHub issues to JSON, then creates a prompt file
that can be passed to Codex CLI. Codex can then generate a markdown task report
from the exported issues.

.PARAMETER Repo
GitHub repository in owner/name format.

.PARAMETER OutputFolder
Folder where the JSON, prompt, task report path, and log files will be created.

.PARAMETER IssueLimit
Maximum number of open issues to export.

.PARAMETER RunCodex
Runs Codex CLI immediately with the generated prompt text.
#>

param (
    [Parameter(Mandatory = $true)]
    [ValidatePattern("^[^/]+/[^/]+$")]
    [string]$Repo,

    [string]$OutputFolder = (Join-Path $env:USERPROFILE "powershell-exports"),

    [ValidateRange(1, 1000)]
    [int]$IssueLimit = 100,

    [switch]$RunCodex
)

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

if (-not (Test-Path -Path $OutputFolder)) {
    New-Item -Path $OutputFolder -ItemType Directory -Force | Out-Null
}

$jsonPath = Join-Path $OutputFolder "github-issues-$timestamp.json"
$promptPath = Join-Path $OutputFolder "codex-github-issue-task-prompt-$timestamp.txt"
$taskPath = Join-Path $OutputFolder "github-issue-tasks-$timestamp.md"
$logPath = Join-Path $OutputFolder "github-issue-task-export-$timestamp.log"

function Write-Log {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    $logLine = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Message"
    Write-Host $logLine
    Add-Content -Path $logPath -Value $logLine
}

Write-Log "Starting GitHub issue export."
Write-Log "Repository : $Repo"
Write-Log "Output folder : $OutputFolder"

$ghCheck = Get-Command gh -ErrorAction SilentlyContinue

if (-not $ghCheck) {
    throw "GitHub CLI was not found. Install GitHub CLI first, then run: gh auth login"
}

$codexCheck = Get-Command codex -ErrorAction SilentlyContinue

if ($RunCodex -and -not $codexCheck) {
    throw "Codex CLI was not found. Install/sign in to Codex CLI first, then try again."
}

Write-Log "Exporting open issues to JSON."

$ghArgs = @(
    "issue",
    "list",
    "--repo",
    $Repo,
    "--state",
    "open",
    "--limit",
    $IssueLimit,
    "--json",
    "number,title,body,labels,assignees,url,createdAt,updatedAt"
)

& gh @ghArgs | Out-File -Path $jsonPath -Encoding utf8

if ($LASTEXITCODE -ne 0) {
    throw "GitHub CLI issue export failed with exit code $LASTEXITCODE."
}

Write-Log "Issue JSON exported : $jsonPath"

$prompt = @"
Read this GitHub issues JSON file:

$jsonPath

Create a markdown task report here:

$taskPath

Requirements:
- Group issues by script area or feature area.
- Create GitHub-flavored markdown task checkboxes.
- Include issue number, title, URL, labels, and assignees when available.
- Create acceptance criteria for each issue.
- Flag unclear issues as "Needs clarification".
- Do not change GitHub issues directly.
- Do not invent requirements that are not in the issue body.
- Use concise project language.
"@

$prompt | Out-File -Path $promptPath -Encoding utf8

Write-Log "Codex prompt created : $promptPath"

if ($RunCodex) {
    Write-Log "Running Codex CLI."
    codex $prompt

    if ($LASTEXITCODE -ne 0) {
        throw "Codex CLI failed with exit code $LASTEXITCODE."
    }

    Write-Log "Codex CLI run completed."
}
else {
    Write-Log "Run Codex manually with:"
    Write-Log "codex `"$(Get-Content -Path $promptPath -Raw)`""
}

Write-Host ""
Write-Host "Created files :"
Write-Host "JSON   : $jsonPath"
Write-Host "Prompt : $promptPath"
Write-Host "Tasks  : $taskPath"
Write-Host "Log    : $logPath"

# Example Usage:
#   .\get-github-repo-issues.ps1 -Repo "owner/repository"
#   .\get-github-repo-issues.ps1 -Repo "owner/repository" -OutputFolder "$env:USERPROFILE\powershell-exports"
#   .\get-github-repo-issues.ps1 -Repo "owner/repository" -IssueLimit 50
#   .\get-github-repo-issues.ps1 -Repo "owner/repository" -RunCodex

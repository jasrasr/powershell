# Filename: get-github-repo-issues.ps1
# Revision : 1.3.0
# Description : Export open GitHub issues and create a Markdown task report plus a Codex-ready prompt
# Author : Jason Lamb (with help from Codex CLI)
# Created Date : 2026-06-03
# Modified Date : 2026-06-04
# Changelog :
# 1.0.0 initial release
# 1.1.0 made repository input and output paths generic for public sharing
# 1.2.0 added support for common GitHub repository URL formats
# 1.3.0 creates the Markdown task report directly instead of only prompting Codex to create it

<#
.SYNOPSIS
Exports open GitHub issues, creates a Markdown task report, and creates a Codex-ready task prompt.

.DESCRIPTION
Uses GitHub CLI to export open GitHub issues to JSON, then creates a Markdown
task report and a prompt file that can be passed to Codex CLI for refinement.

.PARAMETER Repo
GitHub repository as owner/name or a GitHub URL.

.PARAMETER OutputFolder
Folder where the JSON, prompt, task report path, and log files will be created.

.PARAMETER IssueLimit
Maximum number of open issues to export.

.PARAMETER RunCodex
Runs Codex CLI immediately with the generated prompt text.
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$Repo,

    [string]$OutputFolder = (Join-Path $env:USERPROFILE "powershell-exports"),

    [ValidateRange(1, 1000)]
    [int]$IssueLimit = 100,

    [switch]$RunCodex
)

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

function ConvertTo-GitHubRepoSlug {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Repo
    )

    $repoValue = $Repo.Trim()

    if ($repoValue -match "^(?:https://)?github\.com/([^/\s]+)/([^/\s]+?)(?:\.git)?/?$") {
        return "$($Matches[1])/$($Matches[2])"
    }

    if ($repoValue -match "^([^/\s]+)/([^/\s]+?)(?:\.git)?$") {
        return "$($Matches[1])/$($Matches[2])"
    }

    throw "Repository must be in one of these formats: owner/repository, github.com/owner/repository, github.com/owner/repository.git, or https://github.com/owner/repository.git"
}

$repoSlug = ConvertTo-GitHubRepoSlug -Repo $Repo

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

function ConvertTo-MarkdownListValue {
    param (
        [AllowNull()]
        [object[]]$Items,

        [Parameter(Mandatory = $true)]
        [string]$PropertyName,

        [string]$EmptyValue = "None"
    )

    if (-not $Items) {
        return $EmptyValue
    }

    $values = @(
        foreach ($item in $Items) {
            if ($null -ne $item.$PropertyName -and -not [string]::IsNullOrWhiteSpace([string]$item.$PropertyName)) {
                [string]$item.$PropertyName
            }
        }
    )

    if (-not $values) {
        return $EmptyValue
    }

    return ($values -join ", ")
}

function Get-GitHubIssueArea {
    param (
        [Parameter(Mandatory = $true)]
        [pscustomobject]$Issue
    )

    $ignoredLabelNames = @(
        "bug",
        "documentation",
        "duplicate",
        "enhancement",
        "good first issue",
        "help wanted",
        "invalid",
        "question",
        "wontfix"
    )

    foreach ($label in @($Issue.labels)) {
        if ($null -ne $label.name -and $ignoredLabelNames -notcontains $label.name.ToLowerInvariant()) {
            return [string]$label.name
        }
    }

    if ($Issue.title -match "^\s*([^:/\[\]-]+)\s*[:/\[\]-]") {
        return $Matches[1].Trim()
    }

    return "General"
}

function Get-GitHubIssueAcceptanceCriteria {
    param (
        [AllowNull()]
        [string]$Body
    )

    if ([string]::IsNullOrWhiteSpace($Body)) {
        return @("Needs clarification: issue body is empty.")
    }

    $criteria = New-Object System.Collections.Generic.List[string]
    $lines = $Body -split "`r?`n"
    $capture = $false

    foreach ($line in $lines) {
        if ($line -match "^\s{0,3}#{1,6}\s*(acceptance criteria|acceptance|done when|definition of done|requirements?)\s*:?\s*$") {
            $capture = $true
            continue
        }

        if ($capture -and $line -match "^\s{0,3}#{1,6}\s+") {
            break
        }

        if ($capture -and $line -match "^\s*(?:[-*]|\d+[.)]|\[[ xX]\])\s+(.+?)\s*$") {
            $criteria.Add($Matches[1].Trim())
            continue
        }

        if ($capture -and [string]::IsNullOrWhiteSpace($line)) {
            continue
        }

        if ($capture -and -not [string]::IsNullOrWhiteSpace($line)) {
            $criteria.Add($line.Trim())
        }
    }

    if ($criteria.Count -eq 0) {
        return @("Needs clarification: acceptance criteria are not stated in the issue body.")
    }

    return @($criteria)
}

function New-GitHubIssueTaskReport {
    param (
        [Parameter(Mandatory = $true)]
        [object[]]$Issues,

        [Parameter(Mandatory = $true)]
        [string]$RepoSlug
    )

    $markdown = New-Object System.Collections.Generic.List[string]
    $markdown.Add("# GitHub Issue Tasks")
    $markdown.Add("")
    $markdown.Add("Repository: $RepoSlug")
    $markdown.Add("Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
    $markdown.Add("")

    if (-not $Issues -or $Issues.Count -eq 0) {
        $markdown.Add("No open issues were returned by GitHub CLI.")
        return $markdown
    }

    $groupedIssues = $Issues | Group-Object { Get-GitHubIssueArea -Issue $_ } | Sort-Object Name

    foreach ($group in $groupedIssues) {
        $markdown.Add("## $($group.Name)")
        $markdown.Add("")

        foreach ($issue in ($group.Group | Sort-Object number)) {
            $labels = ConvertTo-MarkdownListValue -Items @($issue.labels) -PropertyName "name"
            $assignees = ConvertTo-MarkdownListValue -Items @($issue.assignees) -PropertyName "login" -EmptyValue "Unassigned"
            $criteria = Get-GitHubIssueAcceptanceCriteria -Body $issue.body
            $needsClarification = $criteria | Where-Object { $_ -like "Needs clarification:*" }

            $markdown.Add("- [ ] #$($issue.number) [$($issue.title)]($($issue.url))")
            $markdown.Add("  - Labels: $labels")
            $markdown.Add("  - Assignees: $assignees")

            if ($needsClarification) {
                $markdown.Add("  - Status: Needs clarification")
            }

            $markdown.Add("  - Acceptance criteria:")

            foreach ($criterion in $criteria) {
                $markdown.Add("    - $criterion")
            }

            $markdown.Add("")
        }
    }

    return $markdown
}

Write-Log "Starting GitHub issue export."
Write-Log "Repository : $repoSlug"
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
    $repoSlug,
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

$issues = Get-Content -Path $jsonPath -Raw | ConvertFrom-Json
$taskReport = New-GitHubIssueTaskReport -Issues @($issues) -RepoSlug $repoSlug
$taskReport | Out-File -Path $taskPath -Encoding utf8

Write-Log "Markdown task report created : $taskPath"

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
#   .\get-github-repo-issues.ps1 -Repo "github.com/owner/repository"
#   .\get-github-repo-issues.ps1 -Repo "github.com/owner/repository.git"
#   .\get-github-repo-issues.ps1 -Repo "https://github.com/owner/repository.git"
#   .\get-github-repo-issues.ps1 -Repo "owner/repository" -OutputFolder "$env:USERPROFILE\powershell-exports"
#   .\get-github-repo-issues.ps1 -Repo "owner/repository" -IssueLimit 50
#   .\get-github-repo-issues.ps1 -Repo "owner/repository" -RunCodex

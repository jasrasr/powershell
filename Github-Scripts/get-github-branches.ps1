# Filename: get-github-branches.ps1
# Revision : 1.1.10
# Description : List local and remote branches for a GitHub repository with latest commit details and export options.
# Author : Jason Lamb (with help from Codex CLI)
# Created Date : 2026-07-21
# Modified Date : 2026-07-21
# Changelog :
# 1.0.0 initial release
# 1.1.0 add local repo auto-detection, remote branch support, protected filter, and export options
# 1.1.1 harden branch normalization for local and remote sources
# 1.1.2 shorten displayed commit ids
# 1.1.3 fix local branch metadata lookup
# 1.1.4 fix local metadata separator handling
# 1.1.5 add branch source column
# 1.1.6 enrich remote branch metadata and merge local-plus-remote details
# 1.1.7 add author display name mapping
# 1.1.8 add practical local working tree status column
# 1.1.9 rename working tree status labels
# 1.1.10 colorize working tree status in screen output

param(
    [Parameter(Mandatory = $false)]
    [string]$Repository,

    [Parameter(Mandatory = $false)]
    [string]$Owner,

    [Parameter(Mandatory = $false)]
    [string]$CsvPath,

    [Parameter(Mandatory = $false)]
    [string]$MarkdownPath,

    [Parameter(Mandatory = $false)]
    [switch]$ProtectedOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$AuthorDisplayMap = @{
    'matthewcaras' = 'Matt Caras'
}

function Get-GitHubRepoInfoFromGitRemote {
    $remote = git remote get-url origin 2>$null
    if (-not $remote) {
        return $null
    }

    if ($remote -match '^git@github\.com:(?<owner>[^/]+)/(?<repo>[^/]+?)(?:\.git)?$') {
        return [pscustomobject]@{
            Owner = $Matches.owner
            Repo  = $Matches.repo
        }
    }

    if ($remote -match '^https?://github\.com/(?<owner>[^/]+)/(?<repo>[^/]+?)(?:\.git)?/?$') {
        return [pscustomobject]@{
            Owner = $Matches.owner
            Repo  = $Matches.repo
        }
    }

    return $null
}

function Prompt-ForRepositoryInput {
    Write-Warning 'Unable to determine the repository from the current folder.'
    Write-Host 'Enter one of the following forms:' -ForegroundColor Yellow
    Write-Host '  -Owner my-org -Repository my-repo'
    Write-Host '  -Repository my-org/my-repo'
    Write-Host '  -Repository https://github.com/my-org/my-repo'

    $repositoryInput = Read-Host 'Repository'
    $ownerInput = Read-Host 'Owner (optional, press Enter to skip)'

    return [pscustomobject]@{
        Repository = $repositoryInput
        Owner      = $ownerInput
    }
}

function Resolve-AuthorDisplayName {
    param(
        [Parameter(Mandatory = $false)]
        [string]$AuthorName
    )

    if (-not $AuthorName) {
        return $AuthorName
    }

    if ($AuthorDisplayMap.ContainsKey($AuthorName)) {
        return $AuthorDisplayMap[$AuthorName]
    }

    return $AuthorName
}

function Get-BranchWorkingTreeStatus {
    param(
        [Parameter(Mandatory = $true)]
        [string]$BranchName,

        [Parameter(Mandatory = $true)]
        [string]$Source,

        [Parameter(Mandatory = $false)]
        [string]$CurrentBranch,

        [Parameter(Mandatory = $false)]
        [bool]$IsWorkTreeDirty = $false
    )

    if ($Source -eq 'Remote') {
        return 'RemoteOnly'
    }

    if ($CurrentBranch -and $BranchName -eq $CurrentBranch) {
        if ($IsWorkTreeDirty) {
            return 'Red'
        }

        return 'Green'
    }

    return 'NotCheckedOut'
}

function Show-BranchTable {
    param(
        [Parameter(Mandatory = $true)]
        [object[]]$Rows
    )

    $columns = @(
        'BranchName',
        'CommitId',
        'LastCommittedDate',
        'Author',
        'Protected',
        'Source',
        'WorkingTreeStatus'
    )

    $widths = @{}
    foreach ($column in $columns) {
        $widths[$column] = $column.Length
    }

    foreach ($row in $Rows) {
        foreach ($column in $columns) {
            $value = [string]$row.$column
            if ($value.Length -gt $widths[$column]) {
                $widths[$column] = $value.Length
            }
        }
    }

    $headerLine = (($columns | ForEach-Object { $_.PadRight($widths[$_]) }) -join ' ')
    $separatorLine = (($columns | ForEach-Object { ('-' * $widths[$_]) }) -join ' ')
    Write-Host $headerLine
    Write-Host $separatorLine

    foreach ($row in $Rows) {
        foreach ($column in $columns) {
            $value = [string]$row.$column
            $paddedValue = $value.PadRight($widths[$column])

            if ($column -eq 'WorkingTreeStatus') {
                $color = $null
                switch ($row.WorkingTreeStatus) {
                    'Green' { $color = 'Green' }
                    'Red' { $color = 'Red' }
                    default { $color = $null }
                }

                if ($color) {
                    Write-Host $paddedValue -ForegroundColor $color
                }
                else {
                    Write-Host $paddedValue
                }
            }
            else {
                Write-Host ($paddedValue + ' ') -NoNewline
            }
        }
    }
}

if (-not $Repository) {
    $detectedRepo = Get-GitHubRepoInfoFromGitRemote
    if ($detectedRepo) {
        $Owner = $detectedRepo.Owner
        $Repository = $detectedRepo.Repo
    }
    else {
        $prompted = Prompt-ForRepositoryInput
        $Repository = $prompted.Repository
        if ($prompted.Owner) {
            $Owner = $prompted.Owner
        }
    }
}

if ($Repository -match '^https?://github\.com/(?<owner>[^/]+)/(?<repo>[^/]+?)(?:\.git)?/?$') {
    $Owner = $Matches.owner
    $Repository = $Matches.repo
}
elseif ($Repository -match '^(?<owner>[^/]+)/(?<repo>[^/]+)$') {
    $Owner = $Matches.owner
    $Repository = $Matches.repo
}

if (-not $Owner -or -not $Repository) {
    throw 'Specify -Owner and -Repository, or use one of the supported repository formats.'
}

function Get-BranchRecord {
    param(
        [Parameter(Mandatory = $true)]
        [string]$BranchName,

        [Parameter(Mandatory = $false)]
        $BranchObject,

        [Parameter(Mandatory = $false)]
        [switch]$ProtectedDefault,

        [Parameter(Mandatory = $false)]
        [string]$Source = 'Local'
    )

    $commitSha = $null
    $commitDateText = $null
    $authorName = $null
    $isProtected = [bool]$ProtectedDefault

    if ($BranchObject -and $BranchObject.PSObject.Properties.Match('commit').Count -gt 0) {
        $commitNode = $BranchObject.commit

        if ($commitNode -and $commitNode.PSObject.Properties.Match('sha').Count -gt 0) {
            $commitSha = [string]$commitNode.sha
        }

        if ($commitNode -and $commitNode.PSObject.Properties.Match('protected').Count -gt 0) {
            $isProtected = [bool]$commitNode.protected
        }

        if ($commitSha) {
            try {
                $commitDetails = gh api "repos/$Owner/$Repository/commits/$commitSha" | ConvertFrom-Json
                if ($commitDetails -and $commitDetails.PSObject.Properties.Match('commit').Count -gt 0) {
                    $detailCommit = $commitDetails.commit
                    if ($detailCommit -and $detailCommit.PSObject.Properties.Match('author').Count -gt 0) {
                        if ($detailCommit.author -and $detailCommit.author.PSObject.Properties.Match('date').Count -gt 0) {
                            $commitDateText = [string]$detailCommit.author.date
                        }
                        if ($detailCommit.author -and $detailCommit.author.PSObject.Properties.Match('name').Count -gt 0) {
                            $authorName = [string]$detailCommit.author.name
                        }
                    }
                    if (-not $commitDateText -and $detailCommit -and $detailCommit.PSObject.Properties.Match('committer').Count -gt 0) {
                        if ($detailCommit.committer -and $detailCommit.committer.PSObject.Properties.Match('date').Count -gt 0) {
                            $commitDateText = [string]$detailCommit.committer.date
                        }
                    }
                }
            }
            catch {
            }
        }
    }
    else {
        $commitSha = (git rev-parse $BranchName 2>$null).Trim()

        if ($commitSha) {
            $commitMeta = git log -1 --format=%cI%x09%an $BranchName 2>$null
            if ($commitMeta) {
                $parts = $commitMeta -split "`t"
                if ($parts.Count -ge 2) {
                    $commitDateText = $parts[0].Trim()
                    $authorName = $parts[1].Trim()
                }
            }
        }
    }

    $commitDate = $null
    if ($commitDateText) {
        try {
            $commitDate = [datetime]::Parse($commitDateText)
        }
        catch {
            $commitDate = $null
        }
    }

    $shortCommitId = $commitSha
    if ($shortCommitId -and $shortCommitId.Length -gt 7) {
        $shortCommitId = $shortCommitId.Substring(0, 7)
    }

    [pscustomobject]@{
        BranchName        = $BranchName
        CommitId          = $shortCommitId
        LastCommittedDate = $commitDate
        Author            = Resolve-AuthorDisplayName -AuthorName $authorName
        Protected         = $isProtected
        Source            = $Source
        WorkingTreeStatus = $null
    }
}

function Merge-BranchRecord {
    param(
        [Parameter(Mandatory = $true)]
        $TargetRecord,

        [Parameter(Mandatory = $true)]
        $SourceRecord
    )

    if (-not $TargetRecord.CommitId -and $SourceRecord.CommitId) {
        $TargetRecord.CommitId = $SourceRecord.CommitId
    }

    if (-not $TargetRecord.LastCommittedDate -and $SourceRecord.LastCommittedDate) {
        $TargetRecord.LastCommittedDate = $SourceRecord.LastCommittedDate
    }

    if (-not $TargetRecord.Author -and $SourceRecord.Author) {
        $TargetRecord.Author = $SourceRecord.Author
    }

    if (-not $TargetRecord.Protected -and $SourceRecord.Protected) {
        $TargetRecord.Protected = $SourceRecord.Protected
    }
}

$remoteBranches = @()
try {
    $remoteBranches = @(gh api "repos/$Owner/$Repository/branches?per_page=100" --paginate | ConvertFrom-Json)
}
catch {
    Write-Warning "Unable to load remote branches from GitHub for $Owner/$Repository."
}

$localBranchNames = @(git branch --format='%(refname:short)' 2>$null)
$currentBranch = (git branch --show-current 2>$null).Trim()
$statusPorcelain = @(git status --porcelain 2>$null)
$isWorkTreeDirty = $false
if ($statusPorcelain.Count -gt 0) {
    $isWorkTreeDirty = $true
}
$rowIndex = @{}

foreach ($branch in $remoteBranches) {
    if ($branch -and $branch.PSObject.Properties.Match('name').Count -gt 0) {
        $rowIndex[$branch.name] = Get-BranchRecord -BranchName $branch.name -BranchObject $branch -Source 'Remote'
    }
}

foreach ($localBranch in $localBranchNames) {
    if (-not $localBranch) {
        continue
    }

    if ($rowIndex.ContainsKey($localBranch)) {
        $localRecord = Get-BranchRecord -BranchName $localBranch -Source 'Local'
        Merge-BranchRecord -TargetRecord $rowIndex[$localBranch] -SourceRecord $localRecord
        $rowIndex[$localBranch].Source = 'Local+Remote'
    }
    else {
        $rowIndex[$localBranch] = Get-BranchRecord -BranchName $localBranch -Source 'Local'
    }
}

$rows = $rowIndex.Values

foreach ($row in $rows) {
    $row.WorkingTreeStatus = Get-BranchWorkingTreeStatus -BranchName $row.BranchName -Source $row.Source -CurrentBranch $currentBranch -IsWorkTreeDirty $isWorkTreeDirty
}

if (-not $rows) {
    Write-Output 'No branches found.'
    exit 0
}

$sortedRows = $rows |
    Where-Object { -not $ProtectedOnly -or $_.Protected } |
    Sort-Object LastCommittedDate -Descending |
    Select-Object BranchName, CommitId, LastCommittedDate, Author, Protected, Source, WorkingTreeStatus

if ($CsvPath) {
    $sortedRows | Export-Csv -LiteralPath $CsvPath -NoTypeInformation
}

if ($MarkdownPath) {
    $markdownLines = @()
    $markdownLines += '| Branch Name | Commit Id | Last Committed Date/Time | Author | Protected | Source | Working Tree Status |'
    $markdownLines += '| --- | --- | --- | --- | --- | --- | --- |'
    foreach ($row in $sortedRows) {
        $markdownLines += "| $($row.BranchName) | $($row.CommitId) | $($row.LastCommittedDate) | $($row.Author) | $($row.Protected) | $($row.Source) | $($row.WorkingTreeStatus) |"
    }

    $markdownLines | Set-Content -LiteralPath $MarkdownPath -Encoding UTF8
}

Show-BranchTable -Rows $sortedRows

# Example Usage:
#   .\get-github-branches.ps1
#   .\get-github-branches.ps1 -Owner my-org -Repository my-repo
#   .\get-github-branches.ps1 -Repository my-org/my-repo
#   .\get-github-branches.ps1 -Repository https://github.com/my-org/my-repo
#   .\get-github-branches.ps1 -CsvPath .\branches.csv
#   .\get-github-branches.ps1 -MarkdownPath .\branches.md
#   .\get-github-branches.ps1 -ProtectedOnly

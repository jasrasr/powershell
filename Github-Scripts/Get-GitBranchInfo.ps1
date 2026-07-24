# Filename: Get-GitBranchInfo.ps1
# Revision : 1.0.0
# Description : Lists Git branches in a local repository with name, ID (commit SHA),
#               and last commit date/time, sorted newest-first. Always includes the
#               main branch. Read-only: does not checkout, pull, or modify anything.
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-07-19
# Modified Date : 2026-07-19
# Changelog :
# 1.0.0 initial release

[CmdletBinding()]
param(
    # Path to the local Git repository. Defaults to the current directory.
    [string]$RepoPath = (Get-Location).Path,

    # Include remote-tracking branches (refs/remotes) in addition to local branches.
    [switch]$IncludeRemote,

    # Export the results to a CSV file at this path instead of / in addition to the table.
    [string]$ExportPath
)

# --- Validate git is available ---
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "Git is not installed or not on PATH. Install Git and try again."
    return
}

# --- Validate the target is a git repository ---
if (-not (Test-Path -LiteralPath $RepoPath)) {
    Write-Error "RepoPath does not exist: $RepoPath"
    return
}

Push-Location -LiteralPath $RepoPath
try {
    $insideRepo = (git rev-parse --is-inside-work-tree 2>$null)
    if ($insideRepo -ne 'true') {
        Write-Error "Not a Git repository: $RepoPath"
        return
    }

    # Build the list of ref namespaces to inspect.
    $refs = @('refs/heads/')
    if ($IncludeRemote) { $refs += 'refs/remotes/' }

    # Use a unit-separator delimiter (unlikely to appear in a ref name) for reliable parsing.
    $delim = [char]0x1f
    $format = "%(refname:short)$delim%(objectname)$delim%(objectname:short)$delim%(committerdate:iso8601)$delim%(authorname)$delim%(contents:subject)"

    # --sort=-committerdate => newest commit first.
    $lines = git for-each-ref --sort=-committerdate $refs --format=$format 2>$null

    if (-not $lines) {
        Write-Warning "No branches found in $RepoPath."
        return
    }

    $currentBranch = (git rev-parse --abbrev-ref HEAD 2>$null)

    $branches = foreach ($line in $lines) {
        $parts = $line -split $delim
        [PSCustomObject]@{
            Current        = if ($parts[0] -eq $currentBranch) { '*' } else { '' }
            BranchName     = $parts[0]
            CommitID       = $parts[1]
            ShortID        = $parts[2]
            LastCommitDate = [datetime]$parts[3]
            Author         = $parts[4]
            Subject        = $parts[5]
        }
    }

    # Display: friendly table (short ID + local date/time), newest first.
    $branches |
        Select-Object Current, BranchName, ShortID,
            @{ Name = 'LastCommit'; Expression = { $_.LastCommitDate.ToString('yyyy-MM-dd HH:mm:ss') } },
            Author, Subject |
        Format-Table -AutoSize

    # Optional CSV export (includes full commit SHA and ISO date).
    if ($ExportPath) {
        $branches | Export-Csv -Path $ExportPath -NoTypeInformation -Encoding UTF8
        Write-Host "Exported $($branches.Count) branch(es) to $ExportPath" -ForegroundColor Green
    }
}
finally {
    Pop-Location
}

# Example Usage:
#   .\Get-GitBranchInfo.ps1
#   .\Get-GitBranchInfo.ps1 -RepoPath "C:\path\to\repo"
#   .\Get-GitBranchInfo.ps1 -IncludeRemote
#   .\Get-GitBranchInfo.ps1 -ExportPath "C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\powershell-exports\branches.csv"
#   .\Get-GitBranchInfo.ps1 -RepoPath "C:\path\to\repo" -IncludeRemote -ExportPath ".\branches.csv"

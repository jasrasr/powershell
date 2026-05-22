# Filename: Remove-GitHistory.ps1
# Revision : 1.0.0
# Description : Permanently removes specified files or folders from all git commit history using git-filter-repo
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-05-22
# Modified Date : 2026-05-22
# Changelog :
# 1.0.0 initial release

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory = $false)]
    [string]$RepoPath = (Get-Location).Path,

    [Parameter(Mandatory = $true)]
    [string[]]$PathsToRemove,

    [Parameter(Mandatory = $false)]
    [string]$RemoteName = "origin",

    [Parameter(Mandatory = $false)]
    [switch]$ForcePush,

    [Parameter(Mandatory = $false)]
    [switch]$SkipConfirm
)

# ── Prerequisites ────────────────────────────────────────────────────────────

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "git is not installed or not in PATH."
    exit 1
}

$filterRepoAvailable = & git filter-repo --version 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "git-filter-repo is not installed." -ForegroundColor Red
    Write-Host "Install it with:  pip install git-filter-repo" -ForegroundColor Yellow
    Write-Host "Then re-run this script." -ForegroundColor Yellow
    exit 1
}

# ── Validate repo ────────────────────────────────────────────────────────────

$RepoPath = Resolve-Path $RepoPath
$gitDir = git -C $RepoPath rev-parse --git-dir 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Error "'$RepoPath' is not a git repository."
    exit 1
}

# ── Gather remote info before filter-repo removes it ─────────────────────────

$remoteUrl = git -C $RepoPath remote get-url $RemoteName 2>$null
$currentBranch = git -C $RepoPath symbolic-ref --short HEAD 2>$null

# ── Confirm ───────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Remove-GitHistory — DESTRUCTIVE OPERATION" -ForegroundColor Red
Write-Host "══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Repo   : $RepoPath" -ForegroundColor White
Write-Host "  Remote : $RemoteName  ($remoteUrl)" -ForegroundColor White
Write-Host ""
Write-Host "  Paths to remove from ALL history:" -ForegroundColor Yellow
foreach ($p in $PathsToRemove) {
    Write-Host "    - $p" -ForegroundColor Yellow
}
Write-Host ""
Write-Host "  This rewrites every commit in the repository." -ForegroundColor Red
Write-Host "  All collaborators must re-clone after a force-push." -ForegroundColor Red
Write-Host ""

if (-not $SkipConfirm) {
    $response = Read-Host "  Type YES to continue"
    if ($response -ne "YES") {
        Write-Host "Aborted." -ForegroundColor Gray
        exit 0
    }
}

# ── Build filter-repo args ────────────────────────────────────────────────────

$filterArgs = @("filter-repo")
foreach ($path in $PathsToRemove) {
    $filterArgs += "--path"
    $filterArgs += $path
}
$filterArgs += "--invert-paths"
$filterArgs += "--force"

# ── Run filter-repo ───────────────────────────────────────────────────────────

Write-Host ""
Write-Host "Running git filter-repo..." -ForegroundColor Cyan
& git -C $RepoPath @filterArgs

if ($LASTEXITCODE -ne 0) {
    Write-Error "git filter-repo failed. See output above."
    exit 1
}

Write-Host "History rewrite complete." -ForegroundColor Green

# ── Restore remote (filter-repo removes remote refs intentionally) ────────────

$remoteExists = git -C $RepoPath remote 2>$null | Where-Object { $_ -eq $RemoteName }
if (-not $remoteExists -and $remoteUrl) {
    Write-Host "Restoring remote '$RemoteName'..." -ForegroundColor Cyan
    git -C $RepoPath remote add $RemoteName $remoteUrl
}

# ── Force push ────────────────────────────────────────────────────────────────

if ($ForcePush) {
    if ($PSCmdlet.ShouldProcess("$RemoteName", "Force-push all branches and tags")) {
        Write-Host "Force-pushing to $RemoteName..." -ForegroundColor Cyan
        git -C $RepoPath push $RemoteName --force --all
        git -C $RepoPath push $RemoteName --force --tags
        Write-Host "Force-push complete." -ForegroundColor Green
    }
} else {
    Write-Host ""
    Write-Host "Next step — force-push to publish the rewritten history:" -ForegroundColor Yellow
    Write-Host "  git push $RemoteName --force --all" -ForegroundColor White
    Write-Host "  git push $RemoteName --force --tags" -ForegroundColor White
    Write-Host ""
    Write-Host "Or re-run with -ForcePush to do it automatically." -ForegroundColor Gray
}

Write-Host ""
Write-Host "Done." -ForegroundColor Green

# Example Usage:
#   .\Remove-GitHistory.ps1 -PathsToRemove ".claude","SESSION-NOTES.md"
#   .\Remove-GitHistory.ps1 -PathsToRemove ".env" -RepoPath "C:\repos\my-project"
#   .\Remove-GitHistory.ps1 -PathsToRemove ".claude","secrets.json" -ForcePush
#   .\Remove-GitHistory.ps1 -PathsToRemove "passwords.txt" -RemoteName "upstream" -ForcePush -SkipConfirm

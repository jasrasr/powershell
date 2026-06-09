# Filename: Remove-GitHistory.ps1
# Revision : 1.1.3
# Description : Permanently removes specified files or folders from all git commit history using git-filter-repo
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-05-22
# Modified Date : 2026-05-22
# Changelog :
# 1.1.3 fix pip error suppression; add Python Scripts to PATH after install so git finds git-filter-repo
# 1.1.2 re-launch as admin automatically if Python install requires elevation
# 1.1.1 fix Windows Store Python stub detection by verifying commands actually run
# 1.1.0 auto-install Python and git-filter-repo if missing
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

& git filter-repo --version 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "git-filter-repo is not installed. Attempting to install..." -ForegroundColor Yellow

    # Resolve pip — use try/catch so missing commands fail silently (Store stubs throw terminating errors)
    $pipCmd = $null; $pipExe = $null
    try   { $null = & pip --version 2>$null;          if ($LASTEXITCODE -eq 0) { $pipCmd = { pip install git-filter-repo };          $pipExe = "pip"    } } catch {}
    if (-not $pipCmd) {
        try { $null = & python -m pip --version 2>$null; if ($LASTEXITCODE -eq 0) { $pipCmd = { python -m pip install git-filter-repo }; $pipExe = "python" } } catch {}
    }
    if (-not $pipCmd) {
        try { $null = & py -m pip --version 2>$null;     if ($LASTEXITCODE -eq 0) { $pipCmd = { py -m pip install git-filter-repo };     $pipExe = "py"     } } catch {}
    }

    if (-not $pipCmd) {
        Write-Host "Python is not installed. Installing via winget..." -ForegroundColor Cyan
        if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
            Write-Error "winget is not available. Install Python manually from https://python.org, then run: pip install git-filter-repo"
            exit 1
        }

        $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
        if (-not $isAdmin) {
            Write-Host "Installation requires administrator privileges. Re-launching as admin..." -ForegroundColor Yellow
            $argList = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
            foreach ($key in $PSBoundParameters.Keys) {
                $val = $PSBoundParameters[$key]
                if ($val -is [switch]) {
                    if ($val) { $argList += " -$key" }
                } elseif ($val -is [string[]]) {
                    $argList += " -$key " + (($val | ForEach-Object { "`"$_`"" }) -join ",")
                } else {
                    $argList += " -$key `"$val`""
                }
            }
            Start-Process powershell -ArgumentList $argList -Verb RunAs
            exit 0
        }

        winget install --id Python.Python.3 --silent --accept-package-agreements --accept-source-agreements
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Python installation failed. Install manually from https://python.org"
            exit 1
        }
        # Refresh PATH so pip is available in this session
        $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" +
                    [System.Environment]::GetEnvironmentVariable("PATH", "User")
        $pipCmd = { pip install git-filter-repo }
    }

    Write-Host "Installing git-filter-repo..." -ForegroundColor Cyan
    & $pipCmd
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to install git-filter-repo. Try manually: pip install git-filter-repo"
        exit 1
    }

    # Add Python user Scripts dir to PATH for this session (pip installs there but doesn't update PATH)
    $userScripts = $null
    try { $userScripts = (& $pipExe -m site --user-scripts 2>$null) } catch {}
    if ($userScripts -and (Test-Path $userScripts) -and ($env:PATH -notlike "*$userScripts*")) {
        $env:PATH += ";$userScripts"
        Write-Host "Added $userScripts to PATH for this session." -ForegroundColor Cyan
    }

    # Verify install succeeded
    & git filter-repo --version 2>$null | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Error "git-filter-repo installed but not found by git. You may need to restart your terminal and re-run."
        exit 1
    }
    Write-Host "git-filter-repo installed successfully." -ForegroundColor Green
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

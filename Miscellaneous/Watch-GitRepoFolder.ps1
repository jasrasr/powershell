<#
.SYNOPSIS
Monitors a local Git repository folder for file/folder changes and automatically commits and pushes to GitHub.

.DESCRIPTION
This script uses FileSystemWatcher to detect file/folder additions, modifications, renames, and deletions
in a specified Git repository directory. When changes are detected, the script automatically stages,
commits with intelligent messages, and pushes to the remote GitHub repository.

The script includes debouncing to avoid duplicate commits from rapid file operations, comprehensive
logging, and graceful error handling. It runs continuously until manually stopped (Ctrl+C).

.PARAMETER RepoPath
The local path to the Git repository to monitor. Must be a valid Git repository with a remote origin.
Default: Current working directory.

.PARAMETER CommitNameOverride
Optional. If specified, uses this as the commit author name instead of Git's configured user.name.

.PARAMETER LogLevel
Verbosity level for logging: 'Info', 'Warn', 'Error'. Default: 'Info'.

.EXAMPLE
.\Watch-GitRepoFolder.ps1 -RepoPath "C:\repos\my-project"

.EXAMPLE
.\Watch-GitRepoFolder.ps1 -RepoPath "C:\repos\my-project" -CommitNameOverride "Automated Sync"

.NOTES
Filename: Watch-GitRepoFolder.ps1
Revision: 1.0
Author: Jason Lamb with help from Claude
Created: 2026-04-15
Modified: 2026-04-15
Changelog:
    v1.0 - Initial release. FileSystemWatcher-based monitoring with auto-commit/push.

Requirements:
    - Git must be installed and available in PATH
    - The folder must be a valid Git repository (has .git folder)
    - GitHub remote origin must be configured
    - Adequate credentials (SSH key or PAT) for pushing

Known Limitations:
    - Binary files will be detected but not intelligently staged
    - Does not handle merge conflicts—user intervention required
    - Rapid file operations within debounce window are batched into single commit
#>

param(
    [Parameter(Mandatory = $false)]
    [ValidateScript({ Test-Path $_ -PathType Container })]
    [string]$RepoPath = (Get-Location).Path,

    [Parameter(Mandatory = $false)]
    [string]$CommitNameOverride,

    [Parameter(Mandatory = $false)]
    [ValidateSet('Info', 'Warn', 'Error')]
    [string]$LogLevel = 'Info'
)

# ============================================================================
# INITIALIZATION & CONFIGURATION
# ============================================================================

$ErrorActionPreference = 'Continue'
$WarningPreference = 'Continue'

# Validate repository exists and is a Git repo
if (-not (Test-Path (Join-Path $RepoPath '.git') -PathType Container)) {
    Write-Error "Path '$RepoPath' is not a valid Git repository (no .git folder found)."
    exit 1
}

# Set up logging
$PSExports = if ($env:PSExports) { $env:PSExports } else { [System.Environment]::GetEnvironmentVariable('PSExports', 'User') }
if (-not $PSExports) {
    $PSExports = Join-Path $env:USERPROFILE 'PSExports'
    if (-not (Test-Path $PSExports)) { New-Item -ItemType Directory -Path $PSExports -Force | Out-Null }
}

$LogFile = Join-Path $PSExports "Watch-GitRepoFolder_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
$RepoName = Split-Path $RepoPath -Leaf

function Write-Log {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('Info', 'Warn', 'Error', 'Success')]
        [string]$Level,

        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $logEntry = "[$timestamp] [$Level] $Message"

    # Write to console
    switch ($Level) {
        'Info'    { Write-Host $logEntry -ForegroundColor Cyan }
        'Warn'    { Write-Host $logEntry -ForegroundColor Yellow }
        'Error'   { Write-Host $logEntry -ForegroundColor Red }
        'Success' { Write-Host $logEntry -ForegroundColor Green }
    }

    # Write to file
    Add-Content -Path $LogFile -Value $logEntry -ErrorAction SilentlyContinue
}

Write-Log -Level 'Info' -Message "=== Git Repo Listener Started ==="
Write-Log -Level 'Info' -Message ("Repository: " + $RepoPath)
Write-Log -Level 'Info' -Message ("Log File: " + $LogFile)

# ============================================================================
# GIT OPERATIONS
# ============================================================================

function Get-GitConfig {
    param([string]$ConfigKey)

    try {
        $value = & git -C $RepoPath config --get $ConfigKey
        if ($LASTEXITCODE -eq 0) {
            return $value
        }
    }
    catch { }
    return $null
}

function Get-CommitAuthor {
    if ($CommitNameOverride) {
        return $CommitNameOverride
    }

    $userName = Get-GitConfig 'user.name'
    return if ($userName) { $userName } else { 'Automated Sync' }
}

function Get-GitStatus {
    try {
        $status = & git -C $RepoPath status --porcelain
        if ($LASTEXITCODE -eq 0) {
            return @($status | Where-Object { $_ })
        }
    }
    catch {
        Write-Log -Level 'Warn' -Message "Failed to get git status: $_"
    }
    return @()
}

function Get-ChangedFiles {
    $statusLines = Get-GitStatus
    $changedFiles = @()

    foreach ($line in $statusLines) {
        # Format: " M filename", "?? filename", " D filename", etc.
        $status = $line.Substring(0, 2)
        $filePath = $line.Substring(3)

        $changedFiles += @{
            Status = $status.Trim()
            Path   = $filePath
        }
    }

    return $changedFiles
}

function Invoke-GitStageAll {
    try {
        & git -C $RepoPath add -A
        if ($LASTEXITCODE -eq 0) {
            Write-Log -Level 'Info' -Message "Staged all changes for commit"
            return $true
        }
        else {
            Write-Log -Level 'Warn' -Message "Git add -A returned exit code $LASTEXITCODE"
            return $false
        }
    }
    catch {
        Write-Log -Level 'Error' -Message "Error staging changes: $_"
        return $false
    }
}

function Get-IntelligentCommitMessage {
    param([System.Collections.ArrayList]$FileChanges)

    $summary = @{
        Added    = @()
        Modified = @()
        Deleted  = @()
        Renamed  = @()
        Untracked = @()
    }

    foreach ($change in $FileChanges) {
        $status = $change.Status
        $path = $change.Path

        switch ($status) {
            'A'  { $summary.Added += $path }
            'M'  { $summary.Modified += $path }
            'D'  { $summary.Deleted += $path }
            'R'  { $summary.Renamed += $path }
            '??' { $summary.Untracked += $path }
        }
    }

    $messageParts = @()

    if ($summary.Added.Count -gt 0) {
        $messageParts += "Added $($summary.Added.Count) file$(if ($summary.Added.Count -gt 1) { 's' })"
    }
    if ($summary.Modified.Count -gt 0) {
        $messageParts += "Modified $($summary.Modified.Count) file$(if ($summary.Modified.Count -gt 1) { 's' })"
    }
    if ($summary.Deleted.Count -gt 0) {
        $messageParts += "Deleted $($summary.Deleted.Count) file$(if ($summary.Deleted.Count -gt 1) { 's' })"
    }
    if ($summary.Renamed.Count -gt 0) {
        $messageParts += "Renamed $($summary.Renamed.Count) file$(if ($summary.Renamed.Count -gt 1) { 's' })"
    }

    if ($messageParts.Count -eq 0) {
        return "Auto: Repository sync"
    }

    if ($messageParts.Count -eq 1 -and $summary.Added.Count -eq 1) {
        return ("Add: " + $($summary.Added[0]))
    }
    elseif ($messageParts.Count -eq 1 -and $summary.Modified.Count -eq 1) {
        return ("Update: " + $($summary.Modified[0]))
    }
    elseif ($messageParts.Count -eq 1 -and $summary.Deleted.Count -eq 1) {
        return ("Remove: " + $($summary.Deleted[0]))
    }

    return ("Auto: " + ($messageParts -join ' | '))
}

function Invoke-GitCommit {
    param([string]$Message)

    try {
        $author = Get-CommitAuthor
        & git -C $RepoPath commit -m $Message --author "$author <noreply@github.com>"

        if ($LASTEXITCODE -eq 0) {
            Write-Log -Level 'Success' -Message ("Committed: " + $Message)
            return $true
        }
        else {
            Write-Log -Level 'Warn' -Message "Commit returned exit code $LASTEXITCODE"
            return $false
        }
    }
    catch {
        Write-Log -Level 'Error' -Message "Error committing changes: $_"
        return $false
    }
}

function Invoke-GitPush {
    try {
        & git -C $RepoPath push
        if ($LASTEXITCODE -eq 0) {
            Write-Log -Level 'Success' -Message "Pushed to remote origin"
            return $true
        }
        else {
            Write-Log -Level 'Error' -Message "Git push failed with exit code $LASTEXITCODE. Manual intervention may be required."
            return $false
        }
    }
    catch {
        Write-Log -Level 'Error' -Message "Error pushing to remote: $_"
        return $false
    }
}

# ============================================================================
# FILE SYSTEM WATCHER
# ============================================================================

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $RepoPath
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true
$watcher.NotifyFilter = [System.IO.NotifyFilters]::FileName -bor [System.IO.NotifyFilters]::DirectoryName -bor [System.IO.NotifyFilters]::LastWrite

# Debounce mechanism: collect changes and process periodically
$changeQueue = [System.Collections.ArrayList]::Synchronized(@())
$debounceTimer = $null
$debounceInterval = 2000  # milliseconds

function Process-PendingChanges {
    if ($changeQueue.Count -eq 0) {
        return
    }

    Write-Log -Level 'Info' -Message "Processing $($changeQueue.Count) file system event(s)..."

    # Stage all changes
    if (-not (Invoke-GitStageAll)) {
        Write-Log -Level 'Warn' -Message "Failed to stage changes; skipping commit"
        $changeQueue.Clear()
        return
    }

    # Get current status for commit message
    $changedFiles = Get-ChangedFiles
    if ($changedFiles.Count -eq 0) {
        Write-Log -Level 'Info' -Message "No changes to commit after staging"
        return
    }

    # Generate and execute commit
    $commitMessage = Get-IntelligentCommitMessage -FileChanges $changedFiles
    if (-not (Invoke-GitCommit -Message $commitMessage)) {
        Write-Log -Level 'Warn' -Message "Commit failed; skipping push"
        $changeQueue.Clear()
        return
    }

    # Push to remote
    Invoke-GitPush | Out-Null

    $changeQueue.Clear()
    Write-Log -Level 'Info' -Message "Cycle complete"
}

function Restart-DebounceTimer {
    if ($debounceTimer) {
        $debounceTimer.Stop()
        $debounceTimer.Dispose()
    }

    $debounceTimer = New-Object System.Timers.Timer
    $debounceTimer.Interval = $debounceInterval
    $debounceTimer.AutoReset = $false

    $debounceTimer.add_Elapsed({
        Write-Host ""  # Blank line for readability
        Process-PendingChanges
    })

    $debounceTimer.Start()
}

# Register file system watcher events
$onChanged = {
    $changeQueue.Add(@{
        Type      = 'Changed'
        FullPath  = $Event.SourceEventArgs.FullPath
        Name      = $Event.SourceEventArgs.Name
        Timestamp = Get-Date
    }) | Out-Null

    Write-Log -Level 'Info' -Message "Detected change: $($Event.SourceEventArgs.Name)"
    Restart-DebounceTimer
}

$onCreated = {
    $changeQueue.Add(@{
        Type      = 'Created'
        FullPath  = $Event.SourceEventArgs.FullPath
        Name      = $Event.SourceEventArgs.Name
        Timestamp = Get-Date
    }) | Out-Null

    Write-Log -Level 'Info' -Message "Detected creation: $($Event.SourceEventArgs.Name)"
    Restart-DebounceTimer
}

$onDeleted = {
    $changeQueue.Add(@{
        Type      = 'Deleted'
        FullPath  = $Event.SourceEventArgs.FullPath
        Name      = $Event.SourceEventArgs.Name
        Timestamp = Get-Date
    }) | Out-Null

    Write-Log -Level 'Info' -Message "Detected deletion: $($Event.SourceEventArgs.Name)"
    Restart-DebounceTimer
}

$onRenamed = {
    $changeQueue.Add(@{
        Type         = 'Renamed'
        OldFullPath  = $Event.SourceEventArgs.OldFullPath
        NewFullPath  = $Event.SourceEventArgs.FullPath
        OldName      = $Event.SourceEventArgs.OldName
        NewName      = $Event.SourceEventArgs.Name
        Timestamp    = Get-Date
    }) | Out-Null

    Write-Log -Level 'Info' -Message "Detected rename: $($Event.SourceEventArgs.OldName) → $($Event.SourceEventArgs.Name)"
    Restart-DebounceTimer
}

Register-ObjectEvent -InputObject $watcher -EventName 'Changed' -Action $onChanged -SourceIdentifier 'FSW_Changed' | Out-Null
Register-ObjectEvent -InputObject $watcher -EventName 'Created' -Action $onCreated -SourceIdentifier 'FSW_Created' | Out-Null
Register-ObjectEvent -InputObject $watcher -EventName 'Deleted' -Action $onDeleted -SourceIdentifier 'FSW_Deleted' | Out-Null
Register-ObjectEvent -InputObject $watcher -EventName 'Renamed' -Action $onRenamed -SourceIdentifier 'FSW_Renamed' | Out-Null

# ============================================================================
# MAIN LOOP
# ============================================================================

Write-Log -Level 'Success' -Message "Listener active. Monitoring: $RepoPath"
Write-Log -Level 'Info' -Message "Press Ctrl+C to stop monitoring"
Write-Log -Level 'Info' -Message "Debounce interval: $($debounceInterval)ms"

try {
    while ($true) {
        Start-Sleep -Milliseconds 500
    }
}
catch [System.OperationCanceledException] {
    Write-Log -Level 'Info' -Message "Received stop signal"
}
finally {
    # Cleanup
    Write-Log -Level 'Info' -Message "Cleaning up..."

    Unregister-Event -SourceIdentifier 'FSW_Changed' -ErrorAction SilentlyContinue
    Unregister-Event -SourceIdentifier 'FSW_Created' -ErrorAction SilentlyContinue
    Unregister-Event -SourceIdentifier 'FSW_Deleted' -ErrorAction SilentlyContinue
    Unregister-Event -SourceIdentifier 'FSW_Renamed' -ErrorAction SilentlyContinue

    if ($debounceTimer) {
        $debounceTimer.Stop()
        $debounceTimer.Dispose()
    }

    $watcher.EnableRaisingEvents = $false
    $watcher.Dispose()

    Write-Log -Level 'Success' -Message "=== Listener Stopped ==="
}
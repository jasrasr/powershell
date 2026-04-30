<#
.SYNOPSIS
Monitors multiple Git repositories in a parent folder and automatically commits/pushes with AI-generated commit messages.

.DESCRIPTION
This script discovers all Git repositories within a specified parent directory and monitors each one
for file/folder changes using FileSystemWatcher. When changes are detected in any repo, the script
uses Claude's AI model to analyze the changes and generate intelligent, contextual commit messages.

The script manages multiple watchers concurrently, handles cross-repo interactions, and maintains
separate logs for each repository. It includes debouncing to prevent duplicate commits from rapid
file operations and comprehensive error handling.

.PARAMETER ParentPath
The parent directory containing multiple Git repositories. Script auto-discovers all .git folders.
Default: Current working directory.

.PARAMETER AnthropicApiKey
The API key for Anthropic Claude AI. Can also be set via $env:ANTHROPIC_API_KEY.
Required for AI-generated commit messages.

.PARAMETER DebounceIntervalMs
Time in milliseconds to wait before processing changes. Higher values batch more changes together.
Default: 2000

.PARAMETER SkipAI
Switch to disable AI commit messages and use simple templated messages instead.

.PARAMETER DryRun
Switch to preview what would happen without actually committing/pushing.

.EXAMPLE
.\Watch-MultiGitRepos.ps1 -ParentPath "C:\repos" -AnthropicApiKey "sk-ant-..."

.EXAMPLE
.\Watch-MultiGitRepos.ps1 -ParentPath "C:\src" -DebounceIntervalMs 3000 -SkipAI

.NOTES
Filename: Watch-MultiGitRepos.ps1
Revision: 1.0
Author: Jason Lamb with help from Claude
Created: 2026-04-15
Modified: 2026-04-15
Changelog:
    v1.0 - Initial release. Multi-repo monitoring with Claude AI integration for commit messages.

Requirements:
    - Git must be installed and available in PATH
    - Anthropic API key (for AI-generated messages; optional if -SkipAI is used)
    - Adequate GitHub credentials (SSH key or PAT) for pushing

Environment Variables:
    $env:ANTHROPIC_API_KEY - API key (used if -AnthropicApiKey not provided)
    $env:PSExports - Output directory for logs (default: ~/PSExports)

Known Limitations:
    - AI model calls have a small latency (usually <1s); adjust debounce interval if needed
    - Binary file changes provide limited context to AI
    - Merge conflicts require manual intervention
    - Rate limits on Anthropic API should be considered for high-frequency commits
#>

param(
    [Parameter(Mandatory = $false)]
    [ValidateScript({ Test-Path $_ -PathType Container })]
    [string]$ParentPath = (Get-Location).Path,

    [Parameter(Mandatory = $false)]
    [string]$AnthropicApiKey,

    [Parameter(Mandatory = $false)]
    [int]$DebounceIntervalMs = 2000,

    [Parameter(Mandatory = $false)]
    [switch]$SkipAI,

    [Parameter(Mandatory = $false)]
    [switch]$DryRun
)

# ============================================================================
# INITIALIZATION & CONFIGURATION
# ============================================================================

$ErrorActionPreference = 'Continue'
$WarningPreference = 'Continue'

# Get API key from parameter or environment
if (-not $AnthropicApiKey) {
    $AnthropicApiKey = $env:ANTHROPIC_API_KEY
}

if (-not $SkipAI -and -not $AnthropicApiKey) {
    Write-Warning "No Anthropic API key provided. Use -SkipAI or set `$env:ANTHROPIC_API_KEY"
    $SkipAI = $true
}

# Set up logging
$PSExports = if ($env:PSExports) { $env:PSExports } else { [System.Environment]::GetEnvironmentVariable('PSExports', 'User') }
if (-not $PSExports) {
    $PSExports = Join-Path $env:USERPROFILE 'PSExports'
    if (-not (Test-Path $PSExports)) { New-Item -ItemType Directory -Path $PSExports -Force | Out-Null }
}

$LogDir = Join-Path $PSExports "MultiGitWatch_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
New-Item -ItemType Directory -Path $LogDir -Force | Out-Null

# Global repositories hash
$repositories = @{}
$changeQueues = @{}
$debounceTimers = @{}

function Write-Log {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RepoName,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Info', 'Warn', 'Error', 'Success')]
        [string]$Level,

        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $logEntry = "[$timestamp] [$Level] $Message"

    # Write to console with repo context
    $consoleMsg = "[$RepoName] $logEntry"
    switch ($Level) {
        'Info'    { Write-Host $consoleMsg -ForegroundColor Cyan }
        'Warn'    { Write-Host $consoleMsg -ForegroundColor Yellow }
        'Error'   { Write-Host $consoleMsg -ForegroundColor Red }
        'Success' { Write-Host $consoleMsg -ForegroundColor Green }
    }

    # Write to repo-specific log file
    $logFile = Join-Path $LogDir "$RepoName.log"
    Add-Content -Path $logFile -Value $logEntry -ErrorAction SilentlyContinue
}

Write-Host "`n" -NoNewline
Write-Host "=== Multi-Git Repo Listener ===" -ForegroundColor Magenta
Write-Host "Parent Directory: $ParentPath" -ForegroundColor Cyan
Write-Host "Log Directory: $LogDir" -ForegroundColor Cyan
Write-Host "AI Commit Messages: $(if ($SkipAI) { 'DISABLED' } else { 'ENABLED' })" -ForegroundColor Cyan
Write-Host "Dry Run Mode: $(if ($DryRun) { 'ON' } else { 'OFF' })" -ForegroundColor Cyan
Write-Host "`n"

# ============================================================================
# REPOSITORY DISCOVERY
# ============================================================================

function Find-GitRepositories {
    param([string]$ParentPath)

    $repos = @()

    try {
        # Find all .git directories - use -Force to include hidden folders
        $gitFolders = @(Get-ChildItem -Path $ParentPath -Recurse -Directory -Filter '.git' -Force -ErrorAction SilentlyContinue)
        
        foreach ($gitFolder in $gitFolders) {
            $gitPath = $gitFolder.FullName
            $repoPath = Split-Path -Parent $gitPath
            $repoName = Split-Path -Leaf $repoPath

            $repos += @{
                Name = $repoName
                Path = $repoPath
            }
        }
    }
    catch {
        Write-Host "Error finding repositories: $_" -ForegroundColor Yellow
    }

    return $repos
}

$discoveredRepos = Find-GitRepositories -ParentPath $ParentPath

if ($discoveredRepos.Count -eq 0) {
    Write-Host "No Git repositories found in $ParentPath" -ForegroundColor Red
    exit 1
}

Write-Host "Discovered repositories:" -ForegroundColor Green
$discoveredRepos | ForEach-Object {
    Write-Host "  - $($_.Name) @ $($_.Path)" -ForegroundColor Green
}
Write-Host "`n"

# ============================================================================
# ANTHROPIC CLAUDE AI INTEGRATION
# ============================================================================

function Invoke-ClaudeAPI {
    param(
        [string]$SystemPrompt,
        [string]$UserMessage,
        [int]$MaxTokens = 150
    )

    try {
        $headers = @{
            'x-api-key'       = $AnthropicApiKey
            'anthropic-version' = '2023-06-01'
            'content-type'    = 'application/json'
        }

        $body = @{
            model      = 'claude-opus-4-1'
            max_tokens = $MaxTokens
            system     = $SystemPrompt
            messages   = @(
                @{ role = 'user'; content = $UserMessage }
            )
        } | ConvertTo-Json -Depth 10

        $response = Invoke-RestMethod `
            -Uri 'https://api.anthropic.com/v1/messages' `
            -Method Post `
            -Headers $headers `
            -Body $body `
            -ErrorAction Stop

        if ($response.content -and $response.content[0].text) {
            return $response.content[0].text.Trim()
        }
        return $null
    }
    catch {
        Write-Warning "Claude API error: $_"
        return $null
    }
}

function Get-AICommitMessage {
    param(
        [string]$RepoName,
        [string]$RepoPath,
        [System.Collections.ArrayList]$FileChanges
    )

    # Build detailed change summary with diffs
    $changeSummary = @()
    $diffContext = @()

    foreach ($change in $FileChanges) {
        $status = switch ($change.Status) {
            'A'  { 'Added' }
            'M'  { 'Modified' }
            'D'  { 'Deleted' }
            'R'  { 'Renamed' }
            '??' { 'Untracked' }
            default { 'Changed' }
        }
        $changeSummary += ($status + ": " + $($change.Path))

        # Get actual diff/content for context (only for modified/added files)
        if ($change.Status -in @('M', 'A')) {
            $diff = Get-GitDiff -RepoPath $RepoPath -FilePath $change.Path -MaxLines 40
            if ($diff) {
                $diffContext += "`n--- $($change.Path) ---`n$diff"
            }
        }
    }

    # Build the user message with actual changes
    $fileList = $changeSummary -join "`n"
    $userMessage = @"
Repository: $RepoName

Changed files:
$fileList

Actual changes (diffs/new content):
$($diffContext -join "`n")

Generate a concise, conventional commit message (max 72 chars) for these changes.
Be specific about WHAT changed based on the diffs above. 
Use format: type(scope): description
Examples:
- "feat(parser): add support for JSON input"
- "fix(api): handle null values in response"
- "refactor(db): optimize query performance"
- "docs(readme): add installation instructions"
"@

    $systemPrompt = @"
You are a Git commit message expert. Your job is to analyze the provided diffs 
and file changes, then generate a professional, concise commit message.

Rules:
1. Message must be a SINGLE LINE, max 72 characters
2. Use conventional commit format: type(scope): description
3. Types: feat, fix, docs, style, refactor, test, chore
4. Be specific about what actually changed (based on the diffs)
5. Use imperative mood: "add" not "added", "fix" not "fixed"
6. No period at the end

Output ONLY the commit message, nothing else.
"@

    $message = Invoke-ClaudeAPI -SystemPrompt $systemPrompt -UserMessage $userMessage -MaxTokens 100

    if ($message) {
        # Clean up and ensure message fits in 72 chars
        $message = $message.Trim()
        
        if ($message.Length -gt 72) {
            $message = $message.Substring(0, 69) + "..."
        }
        return $message
    }

    return $null
}

# ============================================================================
# GIT OPERATIONS
# ============================================================================

function Get-GitConfig {
    param(
        [string]$RepoPath,
        [string]$ConfigKey
    )

    try {
        $value = & git -C $RepoPath config --get $ConfigKey 2>$null
        if ($LASTEXITCODE -eq 0) {
            return $value
        }
    }
    catch { }
    return $null
}

function Get-GitStatus {
    param([string]$RepoPath)

    try {
        $status = & git -C $RepoPath status --porcelain 2>$null
        if ($LASTEXITCODE -eq 0) {
            return @($status | Where-Object { $_ })
        }
    }
    catch { }
    return @()
}

function Get-ChangedFiles {
    param([string]$RepoPath)

    $statusLines = Get-GitStatus -RepoPath $RepoPath
    $changedFiles = @()

    foreach ($line in $statusLines) {
        if ($line.Length -lt 3) { continue }
        $status = $line.Substring(0, 2)
        $filePath = $line.Substring(3)
        $changedFiles += @{
            Status = $status.Trim()
            Path   = $filePath
        }
    }

    return $changedFiles
}

function Get-GitDiff {
    param(
        [string]$RepoPath,
        [string]$FilePath,
        [int]$MaxLines = 50
    )

    try {
        # For modified files, get the actual diff (what changed)
        $diff = & git -C $RepoPath diff --no-ext-diff -- $FilePath 2>$null
        
        if ($diff) {
            # Limit diff output to avoid huge API payloads
            $diffLines = $diff -split "`n" | Select-Object -First $MaxLines
            return $diffLines -join "`n"
        }

        # For new files, show first lines of the file itself
        $fullPath = Join-Path $RepoPath $FilePath
        if (Test-Path $fullPath -PathType Leaf) {
            $extension = [System.IO.Path]::GetExtension($FilePath)
            $isBinary = $extension -match '\.(exe|dll|bin|png|jpg|gif|pdf|zip|dll|exe|so)$'
            
            if (-not $isBinary) {
                $content = Get-Content -Path $fullPath -TotalCount 20 -ErrorAction SilentlyContinue
                return "=== NEW FILE ===`n" + ($content -join "`n")
            }
            else {
                return "[Binary file]"
            }
        }

        return "[Deleted file]"
    }
    catch { }
    return $null
}

function Invoke-GitStageAll {
    param([string]$RepoPath)

    try {
        & git -C $RepoPath add -A 2>$null
        return $LASTEXITCODE -eq 0
    }
    catch {
        return $false
    }
}

function Invoke-GitCommit {
    param(
        [string]$RepoPath,
        [string]$Message
    )

    try {
        $author = Get-GitConfig -RepoPath $RepoPath -ConfigKey 'user.name'
        if (-not $author) { $author = 'Automated Sync' }

        $args = @('-C', $RepoPath, 'commit', '-m', $Message, '--author', "$author <noreply@github.com>")
        & git $args 2>$null
        return $LASTEXITCODE -eq 0
    }
    catch {
        return $false
    }
}

function Invoke-GitPush {
    param([string]$RepoPath)

    try {
        & git -C $RepoPath push 2>$null
        return $LASTEXITCODE -eq 0
    }
    catch {
        return $false
    }
}

function Get-SimpleCommitMessage {
    param([System.Collections.ArrayList]$FileChanges)

    $summary = @{
        Added    = 0
        Modified = 0
        Deleted  = 0
        Renamed  = 0
    }

    foreach ($change in $FileChanges) {
        switch ($change.Status) {
            'A'  { $summary.Added++ }
            'M'  { $summary.Modified++ }
            'D'  { $summary.Deleted++ }
            'R'  { $summary.Renamed++ }
        }
    }

    $parts = @()
    if ($summary.Added -gt 0) { $parts += "Add $($summary.Added)f" }
    if ($summary.Modified -gt 0) { $parts += "Mod $($summary.Modified)f" }
    if ($summary.Deleted -gt 0) { $parts += "Del $($summary.Deleted)f" }
    if ($summary.Renamed -gt 0) { $parts += "Ren $($summary.Renamed)f" }

    if ($parts.Count -eq 0) {
        return "Auto: Repository sync"
    }

    return "Auto: $($parts -join ' | ')"
}

# ============================================================================
# CHANGE PROCESSING
# ============================================================================

function Process-RepositoryChanges {
    param(
        [string]$RepoName,
        [string]$RepoPath
    )

    $changeQueue = $changeQueues[$RepoName]
    if ($changeQueue.Count -eq 0) {
        return
    }

    Write-Log -RepoName $RepoName -Level 'Info' -Message "Processing $($changeQueue.Count) change event(s)..."

    # Stage all changes
    if (-not (Invoke-GitStageAll -RepoPath $RepoPath)) {
        Write-Log -RepoName $RepoName -Level 'Warn' -Message "Failed to stage changes"
        $changeQueue.Clear()
        return
    }

    # Get current status
    $changedFiles = Get-ChangedFiles -RepoPath $RepoPath
    if ($changedFiles.Count -eq 0) {
        Write-Log -RepoName $RepoName -Level 'Info' -Message "No changes to commit after staging"
        return
    }

    # Generate commit message
    $commitMessage = $null
    if (-not $SkipAI) {
        $commitMessage = Get-AICommitMessage -RepoName $RepoName -RepoPath $RepoPath -FileChanges $changedFiles
        Write-Log -RepoName $RepoName -Level 'Info' -Message ("AI generated message: " + $commitMessage)
    }

    # Fallback to simple message if AI fails or disabled
    if (-not $commitMessage) {
        $commitMessage = Get-SimpleCommitMessage -FileChanges $changedFiles
        Write-Log -RepoName $RepoName -Level 'Info' -Message ("Using simple message: " + $commitMessage)
    }

    # Commit
    if ($DryRun) {
        Write-Log -RepoName $RepoName -Level 'Info' -Message ("[DRY RUN] Would commit: " + $commitMessage)
    }
    else {
        if (-not (Invoke-GitCommit -RepoPath $RepoPath -Message $commitMessage)) {
            Write-Log -RepoName $RepoName -Level 'Warn' -Message "Commit failed; skipping push"
            $changeQueue.Clear()
            return
        }
        Write-Log -RepoName $RepoName -Level 'Success' -Message ("Committed: " + $commitMessage)
    }

    # Push
    if ($DryRun) {
        Write-Log -RepoName $RepoName -Level 'Info' -Message "[DRY RUN] Would push to remote"
    }
    else {
        if (Invoke-GitPush -RepoPath $RepoPath) {
            Write-Log -RepoName $RepoName -Level 'Success' -Message "Pushed to remote"
        }
        else {
            Write-Log -RepoName $RepoName -Level 'Error' -Message "Push failed; manual intervention may be required"
        }
    }

    $changeQueue.Clear()
}

# ============================================================================
# FILE SYSTEM WATCHERS
# ============================================================================

function Create-RepositoryWatcher {
    param(
        [string]$RepoName,
        [string]$RepoPath
    )

    # Initialize change queue and timers for this repo
    $changeQueues[$RepoName] = [System.Collections.ArrayList]::Synchronized(@())
    $debounceTimers[$RepoName] = $null

    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = $RepoPath
    $watcher.IncludeSubdirectories = $true
    $watcher.EnableRaisingEvents = $true
    $watcher.NotifyFilter = [System.IO.NotifyFilters]::FileName -bor `
                            [System.IO.NotifyFilters]::DirectoryName -bor `
                            [System.IO.NotifyFilters]::LastWrite

    function Restart-DebounceTimer {
        if ($debounceTimers[$RepoName]) {
            $debounceTimers[$RepoName].Stop()
            $debounceTimers[$RepoName].Dispose()
        }

        $timer = New-Object System.Timers.Timer
        $timer.Interval = $DebounceIntervalMs
        $timer.AutoReset = $false

        $timer.add_Elapsed({
            Write-Host ""  # Blank line for readability
            Process-RepositoryChanges -RepoName $RepoName -RepoPath $RepoPath
        })

        $debounceTimers[$RepoName] = $timer
        $timer.Start()
        
        # Show countdown with progress bar
        $startTime = Get-Date
        while ($true) {
            $elapsed = (Get-Date) - $startTime
            $remainingMs = $DebounceIntervalMs - [int]$elapsed.TotalMilliseconds
            
            if ($remainingMs -le 0 -or -not ($debounceTimers[$RepoName] -and $debounceTimers[$RepoName].Enabled)) {
                # Clear the progress line
                Write-Host "`r                                                                    " -NoNewline
                break
            }
            
            $percent = [int](($DebounceIntervalMs - $remainingMs) / $DebounceIntervalMs * 100)
            $barLength = 15
            $filledLength = [int]($barLength * $percent / 100)
            $bar = "=" * $filledLength + "-" * ($barLength - $filledLength)
            
            $remainingSec = [math]::Ceiling($remainingMs / 1000)
            Write-Host -NoNewline ("`r[$RepoName] Timer: [$bar] ${remainingSec}s  ")
            
            Start-Sleep -Milliseconds 200
        }
    }

    $onChanged = {
        $changeQueues[$RepoName].Add(@{
            Type      = 'Changed'
            Path      = $Event.SourceEventArgs.Name
            Timestamp = Get-Date
        }) | Out-Null

        Write-Log -RepoName $RepoName -Level 'Info' -Message ("Detected change: " + $($Event.SourceEventArgs.Name))
        Restart-DebounceTimer
    }

    $onCreated = {
        $changeQueues[$RepoName].Add(@{
            Type      = 'Created'
            Path      = $Event.SourceEventArgs.Name
            Timestamp = Get-Date
        }) | Out-Null

        Write-Log -RepoName $RepoName -Level 'Info' -Message ("Detected creation: " + $($Event.SourceEventArgs.Name))
        Restart-DebounceTimer
    }

    $onDeleted = {
        $changeQueues[$RepoName].Add(@{
            Type      = 'Deleted'
            Path      = $Event.SourceEventArgs.Name
            Timestamp = Get-Date
        }) | Out-Null

        Write-Log -RepoName $RepoName -Level 'Info' -Message ("Detected deletion: " + $($Event.SourceEventArgs.Name))
        Restart-DebounceTimer
    }

    $onRenamed = {
        $changeQueues[$RepoName].Add(@{
            Type      = 'Renamed'
            OldName   = $Event.SourceEventArgs.OldName
            NewName   = $Event.SourceEventArgs.Name
            Timestamp = Get-Date
        }) | Out-Null

        Write-Log -RepoName $RepoName -Level 'Info' -Message ("Detected rename: " + $($Event.SourceEventArgs.OldName) + " -> " + $($Event.SourceEventArgs.Name))
        Restart-DebounceTimer
    }

    $eventSource = "FSW_$RepoName"
    Register-ObjectEvent -InputObject $watcher -EventName 'Changed' -Action $onChanged -SourceIdentifier "${eventSource}_Changed" | Out-Null
    Register-ObjectEvent -InputObject $watcher -EventName 'Created' -Action $onCreated -SourceIdentifier "${eventSource}_Created" | Out-Null
    Register-ObjectEvent -InputObject $watcher -EventName 'Deleted' -Action $onDeleted -SourceIdentifier "${eventSource}_Deleted" | Out-Null
    Register-ObjectEvent -InputObject $watcher -EventName 'Renamed' -Action $onRenamed -SourceIdentifier "${eventSource}_Renamed" | Out-Null

    Write-Log -RepoName $RepoName -Level 'Success' -Message "Listener active"

    return @{
        Watcher = $watcher
        EventSource = $eventSource
    }
}

# ============================================================================
# SETUP & MAIN LOOP
# ============================================================================

$watchers = @{}
foreach ($repo in $discoveredRepos) {
    $watchers[$repo.Name] = Create-RepositoryWatcher -RepoName $repo.Name -RepoPath $repo.Path
}

Write-Host "All repositories are being monitored. Press Ctrl+C to stop." -ForegroundColor Yellow
Write-Host "Log files are in: $LogDir`n" -ForegroundColor Cyan

try {
    while ($true) {
        Start-Sleep -Milliseconds 500
    }
}
catch [System.OperationCanceledException] {
    Write-Host "`nReceived stop signal" -ForegroundColor Yellow
}
finally {
    Write-Host "Cleaning up..." -ForegroundColor Yellow

    foreach ($repo in $discoveredRepos) {
        $repoName = $repo.Name
        $watcherInfo = $watchers[$repoName]

        # Unregister events
        Unregister-Event -SourceIdentifier "$($watcherInfo.EventSource)_Changed" -ErrorAction SilentlyContinue
        Unregister-Event -SourceIdentifier "$($watcherInfo.EventSource)_Created" -ErrorAction SilentlyContinue
        Unregister-Event -SourceIdentifier "$($watcherInfo.EventSource)_Deleted" -ErrorAction SilentlyContinue
        Unregister-Event -SourceIdentifier "$($watcherInfo.EventSource)_Renamed" -ErrorAction SilentlyContinue

        # Stop debounce timer
        if ($debounceTimers[$repoName]) {
            $debounceTimers[$repoName].Stop()
            $debounceTimers[$repoName].Dispose()
        }

        # Dispose watcher
        $watcherInfo.Watcher.EnableRaisingEvents = $false
        $watcherInfo.Watcher.Dispose()

        Write-Log -RepoName $repoName -Level 'Info' -Message "Cleanup complete"
    }

    Write-Host "`nAll listeners stopped." -ForegroundColor Green
}
<#
.SYNOPSIS
Demonstrates the debounce timing behavior with simulated file change events.

.DESCRIPTION
This script simulates FileSystemWatcher events and shows how the debounce mechanism
batches changes together. Useful for understanding timing and tuning debounce interval.

.PARAMETER DurationSeconds
How long to run the simulation. Default: 30

.PARAMETER DebounceIntervalMs
Debounce interval to test (1000-10000ms). Default: 2000

.PARAMETER SimulationType
'quick-saves' | 'rapid-fire' | 'batch-copy' | 'mixed'

.EXAMPLE
.\Test-DebounceVisualization.ps1 -SimulationType 'quick-saves' -DebounceIntervalMs 2000

.NOTES
Filename: Test-DebounceVisualization.ps1
Revision: 1.0
Author: Jason Lamb with help from Claude
Created: 2026-04-15
#>

param(
    [Parameter(Mandatory = $false)]
    [int]$DurationSeconds = 30,

    [Parameter(Mandatory = $false)]
    [int]$DebounceIntervalMs = 2000,

    [Parameter(Mandatory = $false)]
    [ValidateSet('quick-saves', 'rapid-fire', 'batch-copy', 'mixed')]
    [string]$SimulationType = 'quick-saves'
)

# ============================================================================
# SETUP
# ============================================================================

$startTime = Get-Date
$changeQueue = @()
$debounceTimer = $null
$commitCount = 0
$totalEvents = 0

function Get-ElapsedMs {
    $elapsed = (Get-Date) - $startTime
    return [int]$elapsed.TotalMilliseconds
}

function Write-Timeline {
    param([string]$Event, [string]$Color = 'Cyan')
    $elapsed = Get-ElapsedMs
    $seconds = $elapsed / 1000
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] +${elapsed}ms (${seconds:F1}s) | $Event" -ForegroundColor $Color
}

function Simulate-CommitProcess {
    Write-Timeline "==========================================================" Green
    Write-Timeline "Timer: DEBOUNCE TIMER FIRED - Processing changes" Green
    Write-Timeline "Queue contained: $($changeQueue.Count) events" Green
    
    # Show what would be committed
    $files = $changeQueue | Select-Object -Unique
    Write-Timeline "Files changed: $($files.Count) unique file(s)" Green
    
    foreach ($file in $files) {
        $count = @($changeQueue | Where-Object { $_ -eq $file }).Count
        Write-Timeline "  • $file ($count event$(if ($count -gt 1) { 's' }))" Green
    }

    Write-Timeline "-> Simulating: git add -A" Magenta
    Start-Sleep -Milliseconds 50
    
    Write-Timeline "-> Simulating: git diff for context" Magenta
    Start-Sleep -Milliseconds 30
    
    Write-Timeline "-> Calling Claude AI for commit message..." Yellow
    # Simulate Claude API delay (1-2 seconds)
    $delay = Get-Random -Minimum 1000 -Maximum 2000
    Start-Sleep -Milliseconds $delay
    
    $commitMsg = @(
        "feat: update core functionality",
        "fix: resolve edge case in parser",
        "docs: add README section",
        "refactor: optimize database queries",
        "style: format code consistently",
        "test: add integration tests",
        "chore: update dependencies"
    ) | Get-Random
    
    Write-Timeline "OK: AI generated: '$commitMsg'" Green
    
    Write-Timeline "-> Simulating: git commit" Magenta
    Start-Sleep -Milliseconds 100
    
    Write-Timeline "OK: Commit created" Green
    
    Write-Timeline "-> Simulating: git push" Magenta
    Start-Sleep -Milliseconds 500
    
    Write-Timeline "OK: Pushed to remote origin" Green
    
    $commitCount++
    $changeQueue = @()
    Write-Timeline "============================================================" Green
}

function Restart-DebounceTimer {
    if ($debounceTimer) {
        $debounceTimer.Stop()
        $debounceTimer.Dispose()
    }

    $debounceTimer = New-Object System.Timers.Timer
    $debounceTimer.Interval = $DebounceIntervalMs
    $debounceTimer.AutoReset = $false

    $debounceTimer.add_Elapsed({
        Simulate-CommitProcess
    })

    $debounceTimer.Start()
}

function Simulate-FileChange {
    param(
        [string]$FileName,
        [string]$Action = 'Modified'
    )

    $totalEvents++
    $elapsed = Get-ElapsedMs
    
    $changeQueue += $FileName
    
    Write-Timeline "Event #$totalEvents`: $Action - $FileName" Cyan
    Write-Timeline "   -> Added to queue (now: $($changeQueue.Count) event$(if ($changeQueue.Count -gt 1) { 's' }))" Cyan
    
    # Show timer status
    if ($debounceTimer -and $debounceTimer.Enabled) {
        Write-Timeline "   -> Debounce timer RESTARTED (will fire in ${DebounceIntervalMs}ms)" Yellow
    }
    else {
        Write-Timeline "   -> Debounce timer STARTED (will fire in ${DebounceIntervalMs}ms)" Yellow
    }
    
    Restart-DebounceTimer
}

# ============================================================================
# SCENARIOS
# ============================================================================

Write-Host "`n" -NoNewline
Write-Host "╔========================================================╗" -ForegroundColor Magenta
Write-Host "║     DEBOUNCE BEHAVIOR VISUALIZATION & SIMULATION      ║" -ForegroundColor Magenta
Write-Host "╚========================================================╝`n" -ForegroundColor Magenta

Write-Timeline "Starting debounce simulation ($SimulationType)" Magenta
Write-Timeline "Debounce interval: ${DebounceIntervalMs}ms" Magenta
Write-Timeline "Duration: ${DurationSeconds}s" Magenta
Write-Timeline "============================================================" Magenta
Write-Timeline ""

# Simulation patterns
$events = @()

switch ($SimulationType) {
    'quick-saves' {
        # IDE auto-save pattern: user edits, IDE saves multiple times
        $events += @(
            @{ delay = 500;  file = 'app.js';     action = 'Modified' }
            @{ delay = 600;  file = 'app.js';     action = 'Modified' }  # IDE auto-save again
            @{ delay = 1200; file = 'utils.js';   action = 'Modified' }
            @{ delay = 1400; file = 'utils.js';   action = 'Modified' }  # IDE auto-save again
            @{ delay = 3500; file = 'config.json'; action = 'Modified' }
            @{ delay = 4000; file = 'config.json'; action = 'Modified' }  # Last save
            @{ delay = 8000; file = 'routes.js';   action = 'Modified' }  # Next task
            @{ delay = 8200; file = 'routes.js';   action = 'Modified' }  # IDE auto-save
            @{ delay = 10000; file = 'middleware.js'; action = 'Added' }
        )
    }
    
    'rapid-fire' {
        # Bulk copy or build system updating many files
        $files = @('file1.js', 'file2.js', 'file3.js', 'file4.js', 'file5.js', 
                   'file6.js', 'file7.js', 'file8.js')
        for ($i = 0; $i -lt $files.Count; $i++) {
            $events += @{
                delay = 300 + ($i * 400)
                file = $files[$i]
                action = 'Modified'
            }
        }
    }
    
    'batch-copy' {
        # Copying many files from one folder to another
        $files = @('data_file_1.csv', 'data_file_2.csv', 'data_file_3.csv', 
                   'data_file_4.csv', 'config.yml', 'schema.sql', 'notes.md')
        for ($i = 0; $i -lt $files.Count; $i++) {
            $events += @{
                delay = 100 + ($i * 350)
                file = $files[$i]
                action = 'Added'
            }
        }
    }
    
    'mixed' {
        # Mixed real-world scenario
        $events += @(
            @{ delay = 300;  file = 'app.js';       action = 'Modified' }
            @{ delay = 600;  file = 'app.js';       action = 'Modified' }
            @{ delay = 2000; file = 'test.spec.js'; action = 'Created' }
            @{ delay = 6000; file = 'readme.md';    action = 'Modified' }
            @{ delay = 6300; file = 'package.json'; action = 'Modified' }
            @{ delay = 8500; file = 'styles.css';   action = 'Modified' }
            @{ delay = 10000; file = 'index.html';  action = 'Modified' }
            @{ delay = 11000; file = 'old.js';      action = 'Deleted' }
        )
    }
}

# ============================================================================
# RUN SIMULATION
# ============================================================================

$eventIndex = 0
$endTime = $startTime.AddSeconds($DurationSeconds)

while ((Get-Date) -lt $endTime -and $eventIndex -lt $events.Count) {
    $nextEvent = $events[$eventIndex]
    $nextEventTime = $startTime.AddMilliseconds($nextEvent.delay)
    
    # Wait until the next event time
    while ((Get-Date) -lt $nextEventTime -and (Get-Date) -lt $endTime) {
        Start-Sleep -Milliseconds 100
    }
    
    if ((Get-Date) -lt $endTime) {
        Simulate-FileChange -FileName $nextEvent.file -Action $nextEvent.action
        $eventIndex++
    }
}

# Keep running until duration expires or timer finishes
while ((Get-Date) -lt $endTime) {
    Start-Sleep -Milliseconds 500
}

# Cleanup
Write-Timeline ""
Write-Timeline "============================================================" Magenta

if ($changeQueue.Count -gt 0) {
    Write-Timeline "⚠️  Simulation ended with pending changes in queue" Yellow
    Write-Timeline "In production, these would be committed on exit" Yellow
    Simulate-CommitProcess
}

Write-Timeline ""
Write-Timeline "SIMULATION SUMMARY" Green
Write-Timeline "------------------" Green
Write-Timeline "Total file change events: $totalEvents" Green
Write-Timeline "Total commits created: $commitCount" Green
Write-Timeline "Batching efficiency: $(if ($totalEvents -gt 0) { "{0:P0}" -f (1 - ($commitCount / $totalEvents)) } else { "N/A" })" Green
Write-Timeline "Average events per commit: $(if ($commitCount -gt 0) { "{0:F1}" -f ($totalEvents / $commitCount) } else { "N/A" })" Green
Write-Timeline ""
Write-Timeline "Note: In production, timing would be affected by:" Yellow
Write-Timeline "  • Actual file I/O timing" Yellow
Write-Timeline "  • Network latency (~1-2s for Claude API)" Yellow
Write-Timeline "  • Network latency (~0.5-2s for git push)" Yellow
Write-Timeline ""

Write-Host "OK: Simulation complete!" -ForegroundColor Green
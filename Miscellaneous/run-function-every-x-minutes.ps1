# Revision : 1.0
# Description : Run a target function every N minutes until you stop it (Ctrl+C or create a stop file). Rev 1.0
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-10-09
# Modified Date : 2025-10-09

<#
.SYNOPSIS
    Repeatedly runs a function on a fixed interval until stopped.

.EXAMPLE
    # Define any function you want to run
    function Test-Heartbeat {
        Write-Host "Heartbeat at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Cyan
    }

    # Run it every 5 minutes (default) until you press Ctrl+C or create C:\Temp\stop.loop
    .\run-function-every-x-minutes.ps1 -FunctionName 'Test-Heartbeat'

.EXAMPLE
    # Run with custom interval and custom stop file
    .\run-function-every-x-minutes.ps1 -FunctionName 'Test-Heartbeat' -IntervalMinutes 2 -StopFile 'C:\Temp\stop.please'

.EXAMPLE
    # Pass arguments to your function
    function Do-Work { param($Name) Write-Host "Hello $Name at $(Get-Date)" -ForegroundColor Yellow }
    .\run-function-every-x-minutes.ps1 -FunctionName 'Do-Work' -FunctionArgs 'Jason' -IntervalMinutes 1
#>

[CmdletBinding()]
param(
    # The name of the function to invoke each cycle
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$FunctionName,

    # Optional arguments to pass to the function
    [object[]]$FunctionArgs = @(),

    # Interval in minutes between runs
    [ValidateRange(1, 1440)]
    [int]$IntervalMinutes = 5,

    # Create this empty file to request a graceful stop (checked once per second)
    [string]$StopFile = 'C:\Temp\stop.loop',

    # Suppress host chatter (logs still written)
    [switch]$Quiet
)

# --- Setup ---
$ExportFolder = 'C:\Temp\powershell-exports'
if (-not (Test-Path $ExportFolder)) {
    New-Item -Path $ExportFolder -ItemType Directory -Force | Out-Null
}

$TimeStamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$LogFile   = Join-Path $ExportFolder "invoke-repeated-$TimeStamp.log"

# Utility for consistent logging
function Write-Log {
    param(
        [string]$Message,
        [ConsoleColor]$Color = [ConsoleColor]::Gray
    )
    $stamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $line  = "[$stamp] $Message"
    $line | Out-File -FilePath $LogFile -Append -Encoding UTF8
    if (-not $Quiet) {
        Write-Host $line -ForegroundColor $Color
    }
}

# Validate function exists in current session
if (-not (Get-Command -Name $FunctionName -CommandType Function -ErrorAction SilentlyContinue)) {
    Write-Host "Function '$FunctionName' was not found in the current session. Define it before running." -ForegroundColor Red
    exit 1
}

# Informational header
Write-Log "Starting Invoke-Repeated for function '$FunctionName' every $IntervalMinutes minute(s)."
Write-Log "Stop file path : $StopFile"
Write-Log "Log file path  : $LogFile"

# Tip to user about stopping
if (-not $Quiet) {
    Write-Host "Press Ctrl+C to stop at any time, or create the stop file : $StopFile" -ForegroundColor DarkYellow
}

# Ensure stop-file directory exists (only the folder path)
try {
    $stopDir = Split-Path -Path $StopFile -ErrorAction Stop
    if ($stopDir -and -not (Test-Path $stopDir)) {
        New-Item -Path $stopDir -ItemType Directory -Force | Out-Null
        Write-Log "Created stop-file directory : $stopDir"
    }
}
catch {
    Write-Log "Could not prepare stop-file directory. Proceeding anyway. Error : $_" ([ConsoleColor]::DarkYellow)
}

# --- Main loop ---
$iteration = 0
try {
    while ($true) {
        $iteration++

        Write-Log "Iteration #$iteration : Invoking '$FunctionName' ..."
        try {
            & $FunctionName @FunctionArgs
            $exitCode = $LASTEXITCODE
            if ($null -ne $exitCode) {
                Write-Log "Iteration #$iteration : Function reported LASTEXITCODE $exitCode"
            } else {
                Write-Log "Iteration #$iteration : Function completed"
            }
        }
        catch {
            Write-Log "Iteration #$iteration : Error during function execution : $_" ([ConsoleColor]::Red)
        }

        # Sleep with 1-second checks so we can exit quickly if stop requested
        $totalSeconds = $IntervalMinutes * 60
        for ($i = 1; $i -le $totalSeconds; $i++) {
            if (Test-Path $StopFile) {
                Write-Log "Stop file detected : $StopFile. Exiting loop." ([ConsoleColor]::Yellow)
                Remove-Item -Path $StopFile -ErrorAction SilentlyContinue | Out-Null
                throw [System.OperationCanceledException]::new("Stop file triggered")
            }
            Start-Sleep -Seconds 1
        }
    }
}
catch [System.OperationCanceledException] {
    Write-Log "Loop cancelled by request : $($_.Exception.Message)" ([ConsoleColor]::Yellow)
}
catch {
    Write-Log "Unhandled error in loop : $_" ([ConsoleColor]::Red)
}
finally {
    Write-Log "Invoke-Repeated finished."
    if (-not $Quiet) {
        Write-Host "Finished. Full log path : $LogFile" -ForegroundColor Green
        # Auto-open the log for convenience
        try { Invoke-Item -Path $LogFile } catch { Write-Host "Could not open log : $_" -ForegroundColor DarkYellow }
    }
}

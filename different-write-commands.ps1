# Revision # 1
# This version demonstrates different types of output in PowerShell.
# It shows how to use Write-Host, Write-Output, Write-Verbose, Write-Debug, Write-Warning, Write-Error, and Write-Information.

function Show-WriteTypes {
    Write-Host "Write-Host     : This is a message to the console (no pipeline)" -ForegroundColor Cyan

    Write-Output "Write-Output   : This message is sent to the pipeline"
    
    Write-Verbose "Write-Verbose  : This is a verbose message (needs -Verbose)" -Verbose
    
    Write-Debug "Write-Debug    : This is a debug message (needs -Debug)" -Debug
    
    Write-Warning "Write-Warning  : This is a warning message"
    
    Write-Error "Write-Error    : This is an error message"
    
    Write-Information "Write-Information : This is an informational message"
}

# Run with verbose and debug switched on to see all output types
Show-WriteTypes -Verbose -Debug

# Revision # 2
# This version logs messages to a file as well as showing them in the console.
# It demonstrates how to use different write types in PowerShell and logs them to a specified file.

function Show-WriteTypes {
    param (
        [string]$LogFile = "C:\Temp\write-output-demo.log"
    )

    # Ensure log folder exists
    $logDir = Split-Path $LogFile
    if (-not (Test-Path $logDir)) {
        New-Item -Path $logDir -ItemType Directory -Force | Out-Null
    }

    # Helper to write to log file
    function Write-Log {
        param ([string]$Message)
        Add-Content -Path $LogFile -Value "$((Get-Date).ToString('s')) : $Message"
    }

    Write-Host "Write-Host     : This is a message to the console (no pipeline)" -ForegroundColor Cyan
    Write-Log  "Write-Host     : This is a message to the console (no pipeline)"

    Write-Output "Write-Output   : This message is sent to the pipeline"
    Write-Log    "Write-Output   : This message is sent to the pipeline"

    Write-Verbose "Write-Verbose  : This is a verbose message (needs -Verbose)" -Verbose
    Write-Log     "Write-Verbose  : This is a verbose message"

    Write-Debug "Write-Debug    : This is a debug message (needs -Debug)" -Debug
    Write-Log    "Write-Debug    : This is a debug message"

    Write-Warning "Write-Warning  : This is a warning message"
    Write-Log     "Write-Warning  : This is a warning message"

    Write-Error "Write-Error    : This is an error message"
    Write-Log   "Write-Error    : This is an error message"

    Write-Information "Write-Information : This is an informational message"
    Write-Log        "Write-Information : This is an informational message"
}

# Run with verbose and debug to show all
Show-WriteTypes -Verbose -Debug

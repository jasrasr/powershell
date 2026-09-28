@echo off
setlocal enabledelayedexpansion

REM Wrapper for set-timezone.ps1
REM Auto-downloads the script if not found

set "SCRIPT_DIR=%~dp0"
set "SCRIPT_FILE=!SCRIPT_DIR!set-timezone.ps1"

if not exist "!SCRIPT_FILE!" (
    echo.
    echo set-timezone.ps1 not found. Downloading from GitHub...
    echo.

    powershell.exe -NoProfile -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/jasrasr/powershell/main/Computer-Management-Scripts/set-timezone.ps1' -OutFile '!SCRIPT_FILE!'"

    if errorlevel 1 (
        echo.
        echo ERROR: Failed to download from GitHub.
        echo.
        echo Please check your internet connection and try again, or download manually from:
        echo https://github.com/jasrasr/powershell/blob/main/Computer-Management-Scripts/set-timezone.ps1
        echo.
        pause
        exit /b 1
    )

    echo Downloaded successfully!
    echo.
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "!SCRIPT_FILE!" %*
pause

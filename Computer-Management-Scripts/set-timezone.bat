@echo off
setlocal enabledelayedexpansion

REM ============================================================================
REM Script: set-timezone.bat
REM Description: Wrapper launcher for set-timezone.ps1 PowerShell script
REM Author: Jason Lamb
REM Created: 2026-09-28
REM Repository: https://github.com/jasrasr/powershell
REM ============================================================================
REM Purpose:
REM   This batch file serves as a launcher for the set-timezone.ps1 PowerShell
REM   script. It automatically downloads the script from GitHub if not present,
REM   then executes it with appropriate permissions and settings.
REM
REM Requirements:
REM   - Windows PowerShell 5.0+ or PowerShell Core
REM   - Internet connection (for initial download)
REM   - Administrator privileges (for timezone changes)
REM
REM Usage:
REM   set-timezone.bat [timezone-id]
REM   Example: set-timezone.bat "Eastern Standard Time"
REM
REM Notes:
REM   For script header templates and available AI models, see:
REM   ! Templates\header.ps1 and ! Templates\models.md
REM ============================================================================

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

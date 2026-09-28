@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0set-timezone.ps1" %*
pause

# Filename: Get-ComputerInfo-Local.ps1
# Revision : 1.0.0
# Description : Fallback wrapper that runs Get-ComputerInfo.ps1 without uploading to the API.
#               Fetches the latest version from GitHub and invokes it with -NoUpload.
#               Use when API upload is unavailable or not needed.
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-05-06
# Modified Date : 2026-05-06
# Changelog :
# 1.0.0 initial release

$script = Invoke-RestMethod "https://raw.githubusercontent.com/jasrasr/powershell/main/Computer-Management-Scripts/Get-ComputerInfo.ps1"
& ([ScriptBlock]::Create($script)) -NoUpload

# Example Usage:
#   irm "jasr.me/al-comp-local" | iex
#   .\Get-ComputerInfo-Local.ps1

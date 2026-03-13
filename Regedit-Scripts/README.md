# Regedit-Scripts

## Purpose
Registry editing scripts that backup, modify, or clean Windows registry keys.

## Files
| Name | Type | Rev | Description |
| --- | --- | --- | --- |
| `autodesk-programs-unofficial-from-support.ps1` | ps1 | 3cfac93 | Define the base registry path |
| `clear-win-upgrade-block.ps1` | ps1 | 3cfac93 | Remove upgrade block by clearing TargetReleaseVersion and DisableOSUpgrade. Adds ping check, unreachable hosts in red, successes in green, before/after reports in yellow. Creates per-target log folder if missing to prevent path errors. Rev 1.7 |
| `detect-reg-for-autodesk-v2.ps1` | ps1 | 3cfac93 | Get Date and Time |
| `detect-reg-for-autodesk.ps1` | ps1 | 3cfac93 | PowerShell script |
| `enable-remote-registry-for-remote-computer.ps1` | ps1 | 3cfac93 | Remotely enables RemoteRegistry service and key firewall rules, with interactive computer name prompt |
| `get-os-version-and-log-to-txt-file-with-date-time-stamp.ps1` | ps1 | 3cfac93 | This script retrieves and logs the Windows version, build number, and relevant registry values related to Windows Update and upgrade notifications. |
| `get-os-version-update-to-screen.ps1` | ps1 | 3cfac93 | Check specific registry values (local or remote) and output results to screen only. Rev 1.1 |
| `README.md` | md | 6fd63ee | Documentation |
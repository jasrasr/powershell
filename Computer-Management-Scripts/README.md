# Computer-Management-Scripts

## Purpose
General purpose workstation management scripts for inventory, configuration, and health checks.

## Files
| Name | Type | Rev | Description |
| --- | --- | --- | --- |
| `change-computer-name-remotely.ps1` | ps1 | 3cfac93 | Remotely rename one or more computers on the domain using a hashtable of OldName=NewName pairs, |
| `check-enable-winrm.ps1` | ps1 | 3cfac93 | check enable winrm |
| `chrome-clean.ps1` | ps1 | 3cfac93 | ---------- Settings ---------- |
| `datetime.ps1` | ps1 | 3cfac93 | PowerShell script |
| `Get-InstalledSoftware,ps1.ps1` | ps1 | 3cfac93 | Get InstalledSoftware,ps1 |
| `get-task-and-runas-user.ps1` | ps1 | 3cfac93 | Retrieves all scheduled tasks on the local system and extracts the Task Name, Task Folder, and the user the task runs as. If the RunAsUser field is empty, it is resolved based on the LogonType. Results are sorted and displayed in a formatted table. |
| `ping-and-reg-autodesk-access-revit-version.ps1` | ps1 | 3cfac93 | Query Autodesk Access and all Revit 2026 components (incl. FormIt Converter), return full table: Computer, RegistryPath, Publisher, DisplayVersion, DisplayName, InstallDate; run local when host matches; log to C:\temp\powershell-exports\  [Rev 1.7] |
| `README.md` | md | 6fd63ee | Documentation |
| `rename-computer-remotely` |  | 3cfac93 | File |
| `rename-computer-remotely-multiple.ps1` | ps1 | 3cfac93 | Remotely rename one or more computers using OldName=NewName hashtable. |
| `restart-egnyte.ps1` | ps1 | 3cfac93 | Restart only EgnyteClient/EgnyteDrive with rolling log; do NOT stop WebEdit/SyncService/Update  (Rev 1.6) |
| `set-ad-group-local-admin.ps1` | ps1 | 3cfac93 | Get the current computer's hostname |
| `setup-clone-git-via-powershell.ps1` | ps1 | 3cfac93 | Git setup and GitHub repo clone with OneDrive fallback, prompts for user config, updated Git v2.50.0 URL |
# Windows setup bootstrap

Installs a standard set of applications with WinGet and applies user-scoped Windows settings. The script is safe to run repeatedly: installed applications are skipped and registry values are set to the configured value.

## Public command

Configure the YOURLS keyword `setup` to redirect to:

```text
https://raw.githubusercontent.com/jasrasr/powershell/main/setup/setup.ps1
```

Then run this from Windows PowerShell 5.1 or PowerShell 7:

```powershell
irm https://jasr.me/setup | iex
```

Only use the short URL after confirming that its redirect still points at your GitHub account. Piping downloaded code into `iex` executes whatever that URL returns with your current user's permissions.

## Customize

Edit [`setup.json`](./setup.json) to add applications, npm tools, PowerShell modules, Windows capabilities, or settings. Find package IDs with:

```powershell
winget search <name>
```

Set an entry's `enabled` property to `false` to keep it in the catalog without installing or applying it.

Preview the actions without changing the computer:

```powershell
& ([scriptblock]::Create((irm https://jasr.me/setup))) -WhatIf
```

To test an unpublished configuration, pass its raw URL:

```powershell
& ([scriptblock]::Create((Get-Content -Raw .\setup.ps1))) -ConfigUrl 'https://example.com/setup.json' -WhatIf
```

## Requirements

- Windows 10 or Windows 11
- WinGet (included with a current version of Microsoft App Installer)
- Internet access

The defaults include PowerShell 7, Git, Visual Studio Code, 7-Zip, Chrome, PowerToys, Everything, Greenshot, 3D Clipboard, Node.js/npm, PHP, Chocolatey, Codex CLI, Claude Code, and the Exchange Online, Microsoft Graph, and Teams PowerShell modules. Active Directory RSAT is installed when the command runs in an elevated PowerShell session.

The profile setup preserves existing content. It adds a marked, replaceable block to the PowerShell 5.1 and PowerShell 7 all-hosts profiles and creates a shared `Profile.Common.ps1` with UTF-8 output and PSReadLine defaults.

3D Clipboard is not distributed through WinGet or Chocolatey, so the official version 1.5.1 installer is downloaded directly. The script verifies its pinned SHA-256 hash and valid Authenticode signature before running it. Dark mode is not changed; hidden files and file extensions are shown.

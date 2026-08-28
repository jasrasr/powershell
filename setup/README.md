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

Edit [`setup.json`](./setup.json) to add applications or change settings. Find package IDs with:

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

The initial defaults install PowerShell 7, Git, Visual Studio Code, 7-Zip, Chrome, and PowerToys. They also show file extensions and hidden files and enable dark mode for the current user. No execution policy or machine-wide security setting is changed.

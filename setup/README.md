# Windows setup bootstrap

Installs a standard set of applications with WinGet, applies saved application settings, loads the shared PowerShell profile from OneDrive, and applies user-scoped Windows settings. The script is safe to run repeatedly: installed applications are skipped unless their `upgrade` property is `true`, settings files are re-applied, and registry values are set to the configured value.

## Before you run it

1. Sign in to OneDrive for Business (Cooper) and let it sync. The script stops if `%OneDriveCommercial%` is missing, because the PowerShell profile loads `!commonpowershellprofilepath.ps1` from there. Turn this check off with `"requireOneDrive": false` in `setup.json`.
2. Run from Windows PowerShell 5.1 or PowerShell 7. PowerShell 7 does not need to be installed first; the script installs it.
3. Run elevated if you want the Active Directory RSAT tools. Without elevation that one step is skipped with a warning.

## Two ways to run it

**Local mode (recommended for a new computer).** Run the script from this folder, with `setup.json` and `config\` beside it. Settings files are copied from the folder, so nothing needs to be pushed to GitHub:

```powershell
powershell -ExecutionPolicy Bypass -File .\setup.ps1
```

Passing `-ConfigUrl` turns local mode off.

**Download mode.** Everything, including the settings files, is downloaded from GitHub. Commit and push `setup.json`, `setup.ps1` and `config\` first, or the settings steps print a warning and skip. Configure the YOURLS keyword `setup` to redirect to:

```text
https://raw.githubusercontent.com/jasrasr/powershell/main/setup/setup.ps1
```

Then run:

```powershell
irm https://jasr.me/setup | iex
```

Only use the short URL after confirming that its redirect still points at your GitHub account. Piping downloaded code into `iex` executes whatever that URL returns with your current user's permissions.

Preview the actions without changing the computer (add `-WhatIf` to either mode):

```powershell
.\setup.ps1 -WhatIf
& ([scriptblock]::Create((irm https://jasr.me/setup))) -WhatIf
```

## What it does, in order

1. Loads `setup.json` and checks OneDrive.
2. Bootstraps WinGet if it is missing.
3. Installs applications with WinGet: PowerShell 7 and Preview, Windows Terminal, Git, VS Code, 7-Zip, Chrome, PowerToys, Everything, Greenshot, Node.js LTS, PHP, and Chocolatey.
4. Installs 3D Clipboard from the vendor installer. It is not in WinGet, so the script verifies a pinned SHA-256 hash and a valid Authenticode signature first.
5. Installs the global npm tools Claude Code and Codex CLI.
6. Installs the Exchange Online, Microsoft Graph, and Teams PowerShell modules.
7. Installs the Active Directory RSAT capability (elevated sessions only).
8. Installs VS Code extensions.
9. Applies application settings (see below).
10. Adds a block to the PowerShell 5.1 and 7 profiles that loads the shared profile from OneDrive.
11. Shows file extensions and hidden files, then restarts Explorer.
12. **Final pass:** re-checks the PowerShell 7 and Preview upgrades, then installs any missing configured modules and updates all installed modules in fresh PowerShell 7 and Windows PowerShell 5.1 processes, so no module is locked by the running session.
13. **Verification:** confirms every enabled app, npm tool, module, and settings file is present and lists anything missing.

## PowerShell profile

The script does not write profile content of its own. It adds a marked block, replaced on each run, to `Documents\PowerShell\profile.ps1` and `Documents\WindowsPowerShell\profile.ps1`:

```powershell
if ($env:OneDriveCommercial) {
    $commonpowershellprofilepath = Join-Path $env:OneDriveCommercial '!commonpowershellprofilepath.ps1'
    if (Test-Path $commonpowershellprofilepath) { . $commonpowershellprofilepath }
}
```

Everything else lives in the synced `!commonpowershellprofilepath.ps1`. Existing profile content outside the marked block is preserved.

## Application settings

`appSettings` in `setup.json` copies saved files into place after the installs. Saved files live in [`config/`](./config):

| App | Saved file | Applied to |
|-----|------------|------------|
| Greenshot | `Greenshot.ini` | `%APPDATA%\Greenshot\Greenshot.ini` |
| Everything | `Everything.ini` | `%APPDATA%\Everything\Everything.ini` |
| Windows Terminal | `terminal-settings.json` | `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json` |
| PowerToys | `powertoys-settings.zip` | extracted into `%LOCALAPPDATA%\Microsoft\PowerToys` |
| 3D Clipboard | `3dclipboard.reg` | imported into `HKCU\Software\Vince Valenti\3D Clipboard` |

Entry properties: `name`, `source` (path relative to `setup.json`), `destination` (environment variables are expanded), `backup` (saves an existing file as `<file>.bak`), `stopProcess` (process or processes closed before writing), `enabled`, and these optional flags:

- `expandPathTokens`: replaces `%SCREENSHOTS%`, `%MYPICTURES%`, `%USERPROFILE%`, `%LOCALAPPDATA%`, and `%APPDATA%` in the saved file with this computer's paths. `%MYPICTURES%` and `%SCREENSHOTS%` are script placeholders, not environment variables. The Pictures folder is the first that exists of `%OneDriveCommercial%\Pictures`, `%OneDrive%\Pictures`, then `%USERPROFILE%\Pictures`. `%SCREENSHOTS%` is `<Pictures>\Screenshots`, which the script creates if it is missing; Greenshot uses it as its default save location. For zip entries the tokens are replaced inside the extracted `.json` files.
- `extract`: the source is a zip extracted into the destination folder.
- `registryImport`: the source is a `.reg` file imported with `reg import`.

A source that cannot be read is skipped with a warning.

### Exporting settings from a computer

- **Greenshot / Everything / Terminal:** copy the files listed above. Use `%MYPICTURES%` and `%USERPROFILE%` in place of your own paths.
- **PowerToys:** Settings > General > Back up, then unzip the `.ptb` (it is a zip), delete `manifest.json`, and re-zip. **Blank the Mouse Without Borders `SecurityKey` and `MachineID`, and clear `MachinePool` and `MachineMatrixString`, before committing.** Replace your user path in any JSON file with `%USERPROFILE%`.
- **3D Clipboard:** `reg export "HKCU\Software\Vince Valenti\3D Clipboard"`, then delete `NumberItems`, `SaveFile`, `Stats`, and the `WindowPositions` key. Do not copy `%APPDATA%\Vince Valenti\3D Clipboard\clips.dat`; it is the saved clipboard history, in cleartext.
- **VS Code:** not configured. `vscodeExtensions` lists extension IDs (`code --list-extensions` shows yours).

The repository is public. Check every file for secrets, tokens, computer names, and personal paths before committing.

## Mouse Without Borders

PowerToys installs with Mouse Without Borders enabled but with no security key. After setup, open PowerToys > Mouse Without Borders and enter the shared key from your password manager. Setup prints a reminder at the end (`postInstallNotes`).

## Customize

Edit [`setup.json`](./setup.json) to add applications, npm tools, PowerShell modules, Windows capabilities, or settings. Find package IDs with:

```powershell
winget search <name>
```

Set an entry's `enabled` property to `false` to keep it in the catalog without installing or applying it. Set `"finalPass": { "enabled": false }` to skip the final update and verification pass. Add `"upgrade": true` to an app or module to upgrade it on every run.

## Known issues

- If PowerShell 7 was installed with a different package type than the one WinGet offers (MSI versus MSIX), WinGet cannot upgrade it in place (exit code `-1978335090`). The script prints the fix: from a different shell, `winget uninstall --id Microsoft.PowerShell`, then `winget install --id Microsoft.PowerShell --source winget`.
- PowerToys settings are extracted directly into its settings folder rather than restored through PowerToys. Open PowerToys after setup and check that your settings appear.
- Dark mode is not changed.

## Requirements

- Windows 10 or Windows 11
- WinGet (included with a current version of Microsoft App Installer)
- OneDrive for Business signed in and synced
- Internet access

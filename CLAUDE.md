# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a collection of PowerShell automation scripts for IT operations, organized by domain (Active Directory, Exchange Online, Microsoft 365, file management, networking, etc.). Scripts are standalone `.ps1` files — there is no build system, compiled output, or package management.

**Requires PowerShell 7.0+** (cross-platform: Windows, Linux, macOS).

## Running Scripts

```powershell
# Run any script directly
.\ScriptName.ps1 -ParameterName ParameterValue

# Import the Notification Manager module (dot-source)
. .\Notifications\NotificationManager.ps1
```

Many AD and Exchange scripts require administrator privileges and Windows-specific modules. Install modules as needed:

```powershell
Install-Module -Name ExchangeOnlineManagement   # v3.0.0+
Install-Module -Name MicrosoftTeams             # v4.9.1+
Install-Module -Name Microsoft.Graph
Install-Module -Name PSWindowsUpdate
```

## Tests

The Notification system has an informal test runner using a custom `Test-Assert` function:

```powershell
# Run all notification system tests
.\Notifications\Test-Notifications.ps1
```

No other formal test infrastructure exists. Other `test.ps1` files scattered across directories are ad-hoc scripts, not test suites.

## Repository Structure

Scripts are grouped by IT domain:

| Directory | Purpose |
|-----------|---------|
| `AD-Scripts/` | Active Directory automation — user/group management, password audits, Azure AD sync |
| `MS-365-Scripts/` | Exchange Online, Microsoft Teams, Entra ID/Azure AD |
| `Server-Management-Scripts/` | Server infrastructure, task scheduling, logged-on user tracking |
| `File-Management-Scripts/` | File operations, CSV→XLSX conversion, path utilities |
| `Networking-Scripts/` | Network diagnostics and automation |
| `SCCM-Scripts/` | System Center Configuration Manager scripts |
| `SharePoint-Scripts/` | SharePoint administration |
| `Notifications/` | Featured system — see below |
| `Miscellaneous/` | 40+ utility scripts: Dell warranty lookup, password generators, etc. |
| `ChatGPT-CLI/` | ChatGPT integration for PowerShell |
| `PowerShell-Quiz/` | Interactive quiz engine with difficulty-tiered question sets |
| `HEIC-Convert-To-JPG/` | GUI image converter; `compile-to-exe.ps1` packages it via PS2EXE |
| `GRC-TWIT-SecurityNow-Transcripts/` | Resumable downloader for Security Now podcast transcripts/PDFs |

## Notification System Architecture

`Notifications/` is the most structured module in the repository. It uses dot-sourcing (not a formal PS module):

- **`NotificationManager.ps1`** — Core module. Defines all functions and manages persistent JSON storage at:
  - Windows: `$env:APPDATA\PowerShell\Notifications\notifications.json`
  - Linux/macOS: `$HOME/.local/share/powershell/notifications/notifications.json`
- **`Test-Notifications.ps1`** — Tests using a custom `Test-Assert` helper; always dot-sources `NotificationManager.ps1` via `$PSScriptRoot`
- **`Demo.ps1`**, **`Example-Usage.ps1`** — Usage demonstrations

Public functions exposed by `NotificationManager.ps1`: `New-Notification`, `Get-Notifications`, `Show-Notifications`, `Set-NotificationRead`, `Clear-Notifications`, `Get-NotificationStatistics`.

## Conventions

- Scripts are self-contained; shared logic is not extracted into shared modules (exception: `NotificationManager.ps1` is dot-sourced by consumers).
- Use `$PSScriptRoot` for paths relative to the current script file.
- Cross-platform path handling: check `$IsLinux -or $IsMacOS` before constructing paths.
- Script metadata (author, date, description) appears as comments at the top of each file.
- No `.editorconfig`, no PSScriptAnalyzer config, no CI pipeline.

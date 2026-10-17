# Project context

## Purpose

This repository is a collection of PowerShell 7.0+ automation scripts for IT operations. Scripts are organized by domain and are generally standalone, with the Notifications directory providing the most structured reusable component.

## Architecture

There is no build system, compiled output, package manager, or CI pipeline. Scripts are executed directly. Shared notification functionality is implemented in `Notifications/NotificationManager.ps1` and consumed by dot-sourcing it from demos and tests. Notification data is persisted as JSON under the platform's standard application-data location.

## Important paths

- `AD-Scripts/` — Active Directory automation.
- `MS-365-Scripts/` — Exchange Online, Teams, and Entra ID/Azure AD scripts.
- `Server-Management-Scripts/` — Server administration and scheduled-task utilities.
- `File-Management-Scripts/` — File and data-management utilities.
- `Networking-Scripts/` — Network diagnostics and automation.
- `SCCM-Scripts/` — Configuration Manager scripts.
- `SharePoint-Scripts/` — SharePoint administration.
- `Notifications/` — Notification manager, tests, demos, and examples.
- `Miscellaneous/` — General-purpose utilities.
- `ChatGPT-CLI/` — ChatGPT integration scripts.
- `PowerShell-Quiz/` — Interactive quiz engine.
- `HEIC-Convert-To-JPG/` — HEIC conversion utility and packaging script.
- `GRC-TWIT-SecurityNow-Transcripts/` — Resumable transcript/PDF downloader.

## Validation

Run the notification test runner with `.\Notifications\Test-Notifications.ps1`. Other scripts are validated by running them with PowerShell 7.0+ and, where applicable, the required Windows or cloud modules and administrator permissions. The repository has no general automated test suite.


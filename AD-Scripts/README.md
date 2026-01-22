# AD-Scripts

## Purpose
Collection of Active Directory automation scripts for managing users, computers, and group policy from the command line.

## Files
| Name | Type | Rev | Description |
| --- | --- | --- | --- |
| `ad-audit.ps1` | ps1 | 3cfac93 | Audit AD "reactivations" (Event ID 4722) on a single DC (configurable). |
| `adjust-ad-groups-for-365-license-syncing.ps1` | ps1 | 3cfac93 | Active Directory management script |
| `azure-user-audit-logs.ps1` | ps1 | 3cfac93 | Azure AD management script |
| `change-active-directory-computer-description.ps1` | ps1 | 3cfac93 | Import the Active Directory module |
| `check-ad-members-in-all-groups-in-an-OU.ps1` | ps1 | 3cfac93 | check users in all groups |
| `check-azure-for-mfa-issues.ps1` | ps1 | 3cfac93 | check azure for mfa issues |
| `check-computer-in-AD.ps1` | ps1 | 3cfac93 | Check if a list of computer names exists in Active Directory |
| `check-password-expire-date.ps1` | ps1 | 3cfac93 | Import Active Directory module |
| `detect-weak-passwords.ps1` | ps1 | 3cfac93 | PowerShell script |
| `get-active-directory-audit-of-enable-disable-accounts-by-domain-admin.ps1` | ps1 | 3cfac93 | Define the Event IDs for account disabled and enabled |
| `get-manager-email-from-user-email.ps1` | ps1 | 3cfac93 | get ad user manager email |
| `get-user-department-location-from-email.ps1` | ps1 | 3cfac93 | Get Department from AD by matching full email address (mail attribute) |
| `get-users-cannotchangepassword.ps1` | ps1 | 3cfac93 | Active Directory query and reporting script |
| `get-users-change-password-on-next-logon` |  | 3cfac93 | File |
| `get-users-passwordlastset.ps1` | ps1 | 3cfac93 | Active Directory query and reporting script |
| `install-msgraph.ps1` | ps1 | 3cfac93 | install msgraph |
| `M365UserOffBoarding-Hardened.ps1` | ps1 | 3cfac93 | SAFE BY DEFAULT |
| `README.md` | md | 3cfac93 | Documentation |
| `remove-ad-group-members-via-ou.ps1` | ps1 | 3cfac93 | Enumerate all groups in an OU and remove members with mandatory OU prompt, YES/Y WhatIf confirmation, strict live-mode confirmation, and log path validation (Rev 1.6) |
| `rename-ad-group-with-hashtable.ps1` | ps1 | 3cfac93 | PowerShell script |
| `reset-user-password-enable-and-force.ps1` | ps1 | 3cfac93 | Define a character set for the password |
| `sync-ad-to-azure.ps1` | ps1 | 3cfac93 | PowerShell script |
| `verify-and-update-extensionattribute15.ps1` | ps1 | 3cfac93 | Get all users with Office attribute equal to "Cleveland" |
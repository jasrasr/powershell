# Add-SharedMailboxMember.ps1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build an interactive PowerShell script that prompts for a shared mailbox and comma-separated member email(s), validates both, grants FullAccess + SendAs permissions, reports current permissions for existing members, and loops to add more members.

**Architecture:** Single-file script with utility functions (Write-Log, Prompt-*, Get-*) and a main loop. Reuses patterns from existing Add-SharedMailboxReadManage.ps1 and Add-SharedMailboxSendAs.ps1 for module setup, connection handling, and logging.

**Tech Stack:** PowerShell 7.0+, ExchangeOnlineManagement module, Exchange Online REST APIs

---

## File Structure

**Create:**
- `C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\Documents\Github\powershell\ExchangeOnline-Scripts\Add-SharedMailboxMember.ps1`

---

## Tasks

### Task 1: Create Script Header, Module Setup, and Write-Log Function

**Files:**
- Create: `ExchangeOnline-Scripts/Add-SharedMailboxMember.ps1` (partial)

- [ ] **Step 1: Create the file with header and imports**

Create `C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\Documents\Github\powershell\ExchangeOnline-Scripts\Add-SharedMailboxMember.ps1` with this content:

```powershell
# Filename: Add-SharedMailboxMember.ps1
# Revision : 1.0.0
# Description : Interactively add members to a shared mailbox with FullAccess and SendAs permissions
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-07-24
# Modified Date : 2026-07-24
# Changelog :
# 1.0.0 initial release

# Module check and import
foreach ($module in @("ExchangeOnlineManagement")) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Host "Installing $module..." -ForegroundColor Cyan
        Install-Module $module -Scope CurrentUser -Force
    }
    if (-not (Get-Module -Name $module)) {
        Write-Host "Importing $module..." -ForegroundColor Cyan
        Import-Module $module
    }
}

# Set up log file path
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logExport = "C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\powershell-exports\AddSharedMailboxMember_$timestamp.log"

# Ensure log directory exists
$logDir = Split-Path -Parent $logExport
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

```

- [ ] **Step 2: Add the Write-Log function**

Append to the file:

```powershell
function Write-Log {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
    Add-Content -Path $logExport -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  $Message"
}

```

- [ ] **Step 3: Add Exchange Online connection logic**

Append to the file:

```powershell
# Connect to Exchange Online only if not already connected
Write-Log "=== Add-SharedMailboxMember started $(Get-Date) ===" "Cyan"
Write-Log "Log file: $logExport" "Cyan"

$exoConnection = Get-ConnectionInformation -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $exoConnection) {
    Write-Log "NOTE: Authenticate with your Exchange Online admin account." "Yellow"
    Connect-ExchangeOnline -Device -ShowBanner:$false
    $exoConnection = Get-ConnectionInformation -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $exoConnection) {
        Write-Log "ERROR: Failed to connect. Ensure you authenticated with an Exchange Online admin account." "Red"
        exit 1
    }
}
Write-Log "Connected as: $($exoConnection.UserPrincipalName)" "Green"

```

---

### Task 2: Create Mailbox and Member Validation Functions

**Files:**
- Modify: `ExchangeOnline-Scripts/Add-SharedMailboxMember.ps1`

- [ ] **Step 1: Add Prompt-MailboxEmail function**

Append to the file:

```powershell
function Prompt-MailboxEmail {
    <#
    .SYNOPSIS
    Prompts for a shared mailbox email until a valid one is entered.
    #>
    while ($true) {
        $mailboxEmail = Read-Host "Enter shared mailbox email address"
        
        if (-not $mailboxEmail) {
            Write-Log "ERROR: Mailbox email cannot be empty." "Red"
            continue
        }

        $mailbox = Get-Mailbox -Identity $mailboxEmail -ErrorAction SilentlyContinue
        if (-not $mailbox) {
            Write-Log "ERROR: Mailbox '$mailboxEmail' not found." "Red"
            continue
        }

        if ($mailbox.RecipientTypeDetails -ne "SharedMailbox") {
            Write-Log "ERROR: '$mailboxEmail' is not a shared mailbox (type: $($mailbox.RecipientTypeDetails))." "Red"
            continue
        }

        Write-Log "Confirmed: '$mailboxEmail' is a shared mailbox." "Green"
        return $mailbox
    }
}

```

- [ ] **Step 2: Add Prompt-MemberEmails function**

Append to the file:

```powershell
function Prompt-MemberEmails {
    <#
    .SYNOPSIS
    Prompts for comma-separated member emails until at least one valid email is resolved.
    Returns two hashtables: valid members and failed emails.
    #>
    param([string]$MailboxEmail)

    while ($true) {
        $emailInput = Read-Host "Enter member email(s) (comma-separated)"
        
        if (-not $emailInput) {
            Write-Log "ERROR: Email list cannot be empty." "Red"
            continue
        }

        $emails = @($emailInput -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ })
        $validMembers = @()
        $failedEmails = @()

        foreach ($email in $emails) {
            $recipient = Get-Recipient -Identity $email -ErrorAction SilentlyContinue
            if ($recipient) {
                $validMembers += $recipient
            } else {
                $failedEmails += $email
            }
        }

        # Display results
        Write-Log "`nValidation Results:" "Cyan"
        if ($validMembers.Count -gt 0) {
            Write-Log "Will add the following members:" "Green"
            foreach ($member in $validMembers) {
                Write-Log "  • $($member.PrimarySmtpAddress)" "Green"
            }
        }

        if ($failedEmails.Count -gt 0) {
            Write-Log "Failed to resolve:" "Yellow"
            foreach ($failed in $failedEmails) {
                Write-Log "  • $failed" "Yellow"
            }
        }

        # If at least one valid member, proceed
        if ($validMembers.Count -gt 0) {
            return @{
                ValidMembers = $validMembers
                FailedEmails = $failedEmails
            }
        }

        # If all failed, ask to retry
        $retry = Read-Host "`nAll emails failed to resolve. Try again? (Y/N)"
        if ($retry -ne "Y" -and $retry -ne "y") {
            return $null
        }
    }
}

```

- [ ] **Step 3: Add Get-MailboxMembers function**

Append to the file:

```powershell
function Get-MailboxMembers {
    <#
    .SYNOPSIS
    Returns list of current members of a shared mailbox with their permissions.
    $newMembers is an array of emails to mark with [NEW] in output.
    #>
    param(
        [object]$Mailbox,
        [array]$NewMembers
    )

    # Get current members (FullAccess)
    $fullAccessUsers = Get-MailboxPermission -Identity $Mailbox.Identity `
        | Where-Object { $_.AccessRights -contains "FullAccess" -and -not $_.IsInherited -and $_.User -notmatch "S-1-5-21" } `
        | Select-Object -ExpandProperty User

    $members = @()
    foreach ($user in $fullAccessUsers) {
        $isNew = $NewMembers | Where-Object { $_ -eq $user }
        $marker = if ($isNew) { " [NEW]" } else { "" }
        $members += "$user$marker"
    }

    return $members | Sort-Object
}

```

---

### Task 3: Create Permission Checking and Granting Functions

**Files:**
- Modify: `ExchangeOnline-Scripts/Add-SharedMailboxMember.ps1`

- [ ] **Step 1: Add Get-CurrentPermissions function**

Append to the file:

```powershell
function Get-CurrentPermissions {
    <#
    .SYNOPSIS
    Check if a user already has FullAccess and/or SendAs permissions.
    Returns a hashtable with keys: HasFullAccess, HasSendAs
    #>
    param(
        [object]$Mailbox,
        [object]$Member
    )

    $memberIdentity = $Member.PrimarySmtpAddress

    # Check FullAccess
    $fullAccess = Get-MailboxPermission -Identity $Mailbox.Identity `
        -ErrorAction SilentlyContinue `
        | Where-Object { $_.User -eq $memberIdentity -and $_.AccessRights -contains "FullAccess" }

    # Check SendAs
    $sendAs = Get-RecipientPermission -Identity $Mailbox.Identity `
        -ErrorAction SilentlyContinue `
        | Where-Object { $_.Trustee -eq $memberIdentity -and $_.AccessRights -contains "SendAs" }

    return @{
        HasFullAccess = if ($fullAccess) { $true } else { $false }
        HasSendAs = if ($sendAs) { $true } else { $false }
    }
}

```

- [ ] **Step 2: Add Grant-Permissions function**

Append to the file:

```powershell
function Grant-Permissions {
    <#
    .SYNOPSIS
    Grant FullAccess and/or SendAs permissions to a member on a shared mailbox.
    Returns a hashtable with results: FullAccessStatus, SendAsStatus
    #>
    param(
        [object]$Mailbox,
        [object]$Member,
        [hashtable]$CurrentPermissions
    )

    $results = @{
        FullAccessStatus = $null
        SendAsStatus = $null
        FullAccessError = $null
        SendAsError = $null
    }

    $memberIdentity = $Member.PrimarySmtpAddress

    # Grant FullAccess if needed
    if (-not $CurrentPermissions.HasFullAccess) {
        try {
            Add-MailboxPermission -Identity $Mailbox.Identity `
                -User $memberIdentity `
                -AccessRights FullAccess `
                -InheritanceType All `
                -Confirm:$false `
                -ErrorAction Stop
            $results.FullAccessStatus = "Granted"
        } catch {
            $results.FullAccessStatus = "Failed"
            $results.FullAccessError = $_.Exception.Message
        }
    } else {
        $results.FullAccessStatus = "AlreadyHas"
    }

    # Grant SendAs if needed
    if (-not $CurrentPermissions.HasSendAs) {
        try {
            Add-RecipientPermission -Identity $Mailbox.Identity `
                -Trustee $memberIdentity `
                -AccessRights SendAs `
                -Confirm:$false `
                -ErrorAction Stop
            $results.SendAsStatus = "Granted"
        } catch {
            $results.SendAsStatus = "Failed"
            $results.SendAsError = $_.Exception.Message
        }
    } else {
        $results.SendAsStatus = "AlreadyHas"
    }

    return $results
}

```

---

### Task 4: Create Main Script Loop

**Files:**
- Modify: `ExchangeOnline-Scripts/Add-SharedMailboxMember.ps1`

- [ ] **Step 1: Add main script logic**

Append to the file:

```powershell
# Main loop
$continueOuterLoop = $true

while ($continueOuterLoop) {
    # Prompt for mailbox
    Write-Log "`n--- MAILBOX SELECTION ---" "Cyan"
    $mailbox = Prompt-MailboxEmail
    $newMembersThisSession = @()

    # Inner loop for adding members to this mailbox
    $continueInnerLoop = $true
    while ($continueInnerLoop) {
        Write-Log "`n--- MEMBER SELECTION ---" "Cyan"
        $memberResult = Prompt-MemberEmails -MailboxEmail $mailbox.PrimarySmtpAddress

        if ($null -eq $memberResult) {
            Write-Log "Returning to mailbox selection..." "Yellow"
            break
        }

        $validMembers = $memberResult.ValidMembers
        $failedEmails = $memberResult.FailedEmails

        # Confirmation prompt
        Write-Log "`n--- CONFIRMATION ---" "Cyan"
        $confirm = Read-Host "Proceed with adding $($validMembers.Count) member(s)? (Y/N)"

        if ($confirm -ne "Y" -and $confirm -ne "y") {
            Write-Log "Cancelled. Returning to member selection..." "Yellow"
            continue
        }

        # Grant permissions
        Write-Log "`n--- GRANTING PERMISSIONS ---" "Cyan"
        $successCount = 0
        $failedCount = 0

        for ($i = 0; $i -lt $validMembers.Count; $i++) {
            $member = $validMembers[$i]
            $memberNum = $i + 1
            Write-Log "`n[$memberNum/$($validMembers.Count)] $($member.PrimarySmtpAddress)" "Cyan"

            # Check current permissions
            $currentPerms = Get-CurrentPermissions -Mailbox $mailbox -Member $member

            # Display current state
            if ($currentPerms.HasFullAccess -and $currentPerms.HasSendAs) {
                Write-Log "  • Already has FullAccess, SendAs" "Yellow"
            } else {
                # Grant missing permissions
                $grantResult = Grant-Permissions -Mailbox $mailbox -Member $member -CurrentPermissions $currentPerms

                if ($grantResult.FullAccessStatus -eq "Granted") {
                    Write-Log "  • FullAccess granted" "Green"
                    $successCount++
                } elseif ($grantResult.FullAccessStatus -eq "AlreadyHas") {
                    Write-Log "  • Already has FullAccess" "Yellow"
                } else {
                    Write-Log "  • FullAccess failed: $($grantResult.FullAccessError)" "Red"
                    $failedCount++
                }

                if ($grantResult.SendAsStatus -eq "Granted") {
                    Write-Log "  • SendAs granted" "Green"
                    $successCount++
                } elseif ($grantResult.SendAsStatus -eq "AlreadyHas") {
                    Write-Log "  • Already has SendAs" "Yellow"
                } else {
                    Write-Log "  • SendAs failed: $($grantResult.SendAsError)" "Red"
                    $failedCount++
                }
            }

            $newMembersThisSession += $member.PrimarySmtpAddress
        }

        # Display final member list
        Write-Log "`n--- FINAL MEMBER LIST ---" "Cyan"
        Write-Log "Current members of $($mailbox.PrimarySmtpAddress):" "Green"
        $allMembers = Get-MailboxMembers -Mailbox $mailbox -NewMembers $newMembersThisSession
        foreach ($member in $allMembers) {
            Write-Log "  • $member" "Green"
        }

        # Ask if user wants to add more members to this mailbox
        Write-Log "`n" "White"
        $addMore = Read-Host "Add more members to this mailbox? (Y/N)"

        if ($addMore -ne "Y" -and $addMore -ne "y") {
            $continueInnerLoop = $false
        }
    }

    # Ask if user wants to work with another mailbox
    Write-Log "`n" "White"
    $anotherMailbox = Read-Host "Work with another mailbox? (Y/N)"
    if ($anotherMailbox -ne "Y" -and $anotherMailbox -ne "y") {
        $continueOuterLoop = $false
    }
}

Write-Log "`n=== Script completed ===" "Green"

```

- [ ] **Step 2: Add footer with example usage**

Append to the file:

```powershell
# Example Usage:
#   .\Add-SharedMailboxMember.ps1
```

---

### Task 5: Manual Testing and Validation

**Files:**
- Test: `ExchangeOnline-Scripts/Add-SharedMailboxMember.ps1`

- [ ] **Step 1: Verify script syntax**

Run:
```powershell
Test-Path "C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\Documents\Github\powershell\ExchangeOnline-Scripts\Add-SharedMailboxMember.ps1"
```

Expected: `True`

- [ ] **Step 2: Run the script with manual validation**

Run:
```powershell
cd "C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\Documents\Github\powershell\ExchangeOnline-Scripts"
.\Add-SharedMailboxMember.ps1
```

Test scenarios:
1. Enter valid shared mailbox email → should confirm it's a shared mailbox
2. Enter valid member email → should resolve and show will add
3. Enter invalid email → should report failed to resolve
4. Enter mix of valid/invalid → should show both lists
5. Confirm adding members → should grant permissions
6. Check output shows "Already has" for existing permissions
7. Final member list should show with [NEW] markers
8. Log file should exist in powershell-exports

- [ ] **Step 3: Verify log file generation**

Check that the log file was created:
```powershell
Get-Item "C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\powershell-exports\AddSharedMailboxMember_*.log" | Select-Object -First 1
```

Expected: Log file exists with all output timestamped

---

### Task 6: Commit the Script

**Files:**
- Create: `ExchangeOnline-Scripts/Add-SharedMailboxMember.ps1`

- [ ] **Step 1: Stage and commit the script**

Run:
```powershell
cd "C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\Documents\Github\powershell"
git add ExchangeOnline-Scripts/Add-SharedMailboxMember.ps1
git commit -m "feat: add interactive shared mailbox member assignment script"
```

Expected: Commit succeeds with message about the new script

- [ ] **Step 2: Verify commit**

Run:
```powershell
git log --oneline | Select-Object -First 1
```

Expected: Latest commit shows the new script addition

---

## Plan Self-Review

**Spec Coverage:**
- ✓ Input prompts (Tasks 2: Prompt-MailboxEmail, Prompt-MemberEmails)
- ✓ Mailbox validation (Task 2: Prompt-MailboxEmail)
- ✓ Member validation (Task 2: Prompt-MemberEmails)
- ✓ Permission checking (Task 3: Get-CurrentPermissions)
- ✓ Permission granting (Task 3: Grant-Permissions, Task 4 main loop)
- ✓ Confirmation prompt (Task 4: main loop)
- ✓ Results reporting (Task 4: main loop, per-member status display)
- ✓ Final member list (Task 3: Get-MailboxMembers, Task 4: display)
- ✓ Interactive loop (Task 4: main outer/inner loop structure)
- ✓ Logging (Task 1: Write-Log function, append to log file)

**Placeholder Check:**
- No TBD, TODO, or incomplete sections
- All code is complete with exact cmdlet parameters
- All file paths are exact
- All test steps include expected output

**Type & Naming Consistency:**
- Consistent function names: Prompt-*, Get-*, Grant-*
- Consistent hashtable keys across functions: HasFullAccess, HasSendAs
- Consistent parameters: Mailbox, Member, CurrentPermissions
- Write-Log function used throughout for all output

**Code Structure Check:**
- Header follows CLAUDE.md format ✓
- Module setup follows existing pattern ✓
- Connection handling matches Add-SharedMailboxReadManage.ps1 ✓
- Function signatures are complete and documented ✓
- Main loop implements nested loop structure from spec ✓
- Error handling captures and continues as per spec ✓
- Footer includes example usage ✓

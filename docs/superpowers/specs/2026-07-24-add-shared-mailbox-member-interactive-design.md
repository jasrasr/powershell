# Add-SharedMailboxMember.ps1 — Interactive Design Spec

**Date:** 2026-07-24  
**Status:** Design Approved  
**Script Name:** Add-SharedMailboxMember.ps1  
**Version:** 1.0.0

---

## Overview

An interactive PowerShell script that adds one or more members to a shared mailbox in Exchange Online. The script prompts for mailbox email and member email(s), validates both, grants FullAccess and SendAs permissions, and displays the final membership list. Includes an interactive loop so users can add more members to the same mailbox without restarting.

---

## Requirements

- **Input:** Shared mailbox email, comma-separated member email list
- **Permissions:** Both FullAccess and SendAs (mandatory)
- **Validation:** Mailbox must exist and be type SharedMailbox; members must exist as valid recipients
- **Loop:** After adding members and showing results, ask "Add more members? (Y/N)" and loop or exit accordingly
- **Output:** Log file + console output showing validation results, success/failure per member, and final mailbox member list

---

## Workflow & State Machine

```
START
  ↓
[Mailbox Prompt] → User enters mailbox email
  ↓
[Validate Mailbox] → Check exists + is SharedMailbox type
  ├─ Not found/wrong type → Report error, loop back to Mailbox Prompt
  └─ Valid → Continue
  ↓
[Member Prompt] → User enters comma-separated emails
  ↓
[Parse & Validate Members] → Split by comma, resolve each
  ├─ Report: "Will add: [list]", "Failed to resolve: [list]"
  └─ If all failed, ask "Try again? (Y/N)" → Yes: back to Member Prompt, No: back to Mailbox Prompt
  ↓
[Confirmation Prompt] → "Proceed with adding [X] members? (Y/N)"
  ├─ No → Back to Member Prompt
  └─ Yes → Continue
  ↓
[Grant Permissions] → For each valid member:
  ├─ Add-MailboxPermission -Identity $mailbox -User $member -AccessRights FullAccess
  ├─ Add-RecipientPermission -Identity $mailbox -Trustee $member -AccessRights SendAs
  └─ Track success/failure
  ↓
[Report Results] → Show:
  ├─ Successfully added: [list]
  ├─ Failed to add: [list]
  └─ Current mailbox members: [complete list with [NEW] markers]
  ↓
[Loop Prompt] → "Add more members to this mailbox? (Y/N)"
  ├─ Yes → Back to Member Prompt
  └─ No → EXIT
```

---

## Validation Logic

### Mailbox Validation
- **Input:** Shared mailbox email (e.g., `billing@company.com`)
- **Process:** `Get-Mailbox -Identity $mailbox -ErrorAction SilentlyContinue`
- **Success:** `$mailbox.RecipientTypeDetails -eq "SharedMailbox"`
- **Failure:** Report "Mailbox not found" or "Not a shared mailbox (type: X)", then re-prompt for mailbox
- **No hard exit:** Keep script running so user can retry or re-authenticate

### Member Validation
- **Input:** Comma-separated email list (e.g., `user1@company.com, user2@company.com`)
- **Process:** 
  - Split on comma, trim whitespace
  - For each email, attempt: `Get-Recipient -Identity $email -ErrorAction SilentlyContinue`
- **Success:** Email exists as valid recipient
- **Failure:** Email doesn't resolve → mark as "failed to resolve" and skip in permission grant
- **Report before proceeding:** List all emails in two groups: "Will add" and "Failed to resolve"
- **If all failed:** Ask "Try again? (Y/N)"; if yes, back to member prompt; if no, back to mailbox prompt

---

## Permission Granting

For each successfully validated member:

1. **Check Current Permissions:**
   ```
   $fullAccess = Get-MailboxPermission -Identity $mailbox | Where-Object { $_.User -eq $member -and $_.AccessRights -contains "FullAccess" }
   $sendAs = Get-RecipientPermission -Identity $mailbox | Where-Object { $_.Trustee -eq $member -and $_.AccessRights -contains "SendAs" }
   ```

2. **Grant Missing Permissions:**
   - If does NOT have FullAccess, grant it:
     ```
     Add-MailboxPermission -Identity $mailbox -User $member -AccessRights FullAccess -InheritanceType All -Confirm:$false -ErrorAction Continue
     ```
   - If does NOT have SendAs, grant it:
     ```
     Add-RecipientPermission -Identity $mailbox -Trustee $member -AccessRights SendAs -Confirm:$false -ErrorAction Continue
     ```

3. **Report Current State:**
   - If member already has FullAccess and SendAs: "user@company.com already has FullAccess, SendAs"
   - If member has FullAccess but missing SendAs: grant SendAs, report "user@company.com already has FullAccess, granting SendAs"
   - If member has SendAs but missing FullAccess: grant FullAccess, report "user@company.com already has SendAs, granting FullAccess"
   - If member has neither: grant both, report "user@company.com — FullAccess granted, SendAs granted"

**Error Handling:** If permission grant fails, log the error but continue with the next member. Report all failures at the end.

---

## Output & Reporting

### Console & Log File
- All output mirrored to both console (with color) and timestamped log file
- Log file saved to: `C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\powershell-exports\AddSharedMailboxMember_YYYYMMDD_HHMMSS.log`
- Follow existing script patterns (Write-Log function)

### Report Sections (in order)

**1. Pre-Action Report:**
```
Will add the following members:
  • user1@company.com
  • user2@company.com

Failed to resolve:
  • invalid.email@company.com
```

**2. Permission Grant Results:**
```
Granting permissions...
[1/2] user1@company.com
  • FullAccess granted
  • SendAs granted
[2/2] user2@company.com
  • Already has FullAccess
  • SendAs granted
[3/3] user3@company.com
  • Already has FullAccess, SendAs
```

**3. Final Member List:**
```
Current members of billing@company.com:
  • admin@company.com
  • user1@company.com [NEW]
  • user2@company.com [NEW]
  • finance-team@company.com
```

---

## Code Structure

### Header
- Standard Jason Lamb header format (from CLAUDE.md)
- Filename, Revision, Description, Author, Created/Modified dates, Changelog

### Module & Connection
- Auto-install/import `ExchangeOnlineManagement` if needed (follow existing pattern from Add-SharedMailboxReadManage.ps1)
- Connect to Exchange Online with `Connect-ExchangeOnline -Device` only if not already connected
- Verify connection; exit with error if auth fails

### Functions
- `Write-Log` — console + file output with timestamp and color
- `Prompt-MailboxEmail` — loop until valid mailbox is entered
- `Prompt-MemberEmails` — loop until at least one valid email is resolved
- `Get-MailboxMembers` — return list of current members with permission types

### Main Loop
- Outer loop: mailbox prompt + inner loop (member additions)
- Inner loop: member prompt → validate → confirm → grant → report → loop?

### Footer
- Example usage block per CLAUDE.md

---

## Dependencies

- **PowerShell:** 7.0+ (per repo README)
- **Module:** ExchangeOnlineManagement (auto-installed)
- **Permissions:** Exchange Online admin role (for `Add-MailboxPermission` and `Add-RecipientPermission`)
- **Auth:** Device code flow (`-Device` flag)

---

## Success Criteria

- ✓ Script prompts for mailbox email
- ✓ Script validates mailbox exists and is SharedMailbox type
- ✓ Script prompts for comma-separated member emails
- ✓ Script validates each member exists; reports failed resolutions
- ✓ Script shows confirmation with member list before proceeding
- ✓ Script grants both FullAccess and SendAs to each member
- ✓ Script reports which permissions succeeded/failed per member
- ✓ Script displays final mailbox member list with [NEW] markers
- ✓ Script loops back to member prompt if user selects "add more"
- ✓ All output logged to timestamped file in powershell-exports

---

## Notes

- Does not disconnect Exchange Online at the end (per CLAUDE.md convention: only connect if needed, never disconnect)
- Reuses patterns from existing scripts (Add-SharedMailboxReadManage.ps1, Add-SharedMailboxSendAs.ps1)
- Interactive only — no CSV input, no file-based configuration

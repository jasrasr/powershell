# Handoff: Dynamic Distribution List scripts (2026-10-16)

Folder: `powershell/ExchangeOnline-Scripts` (OneDrive-synced; nothing is committed to git yet, so check `git status`).

## Goal
List the members of a dynamic distribution list (DDL), and compare a DDL against an email domain to find recipients who should be on it but are not. The test case is `allaltronic@altronic-llc.com` (domain `altronic-llc.com`).

## Scripts
1. `Get-DynamicDistributionListMembers.ps1` (v1.4.0)
   - Lists members. Prompts for the list and for Email or Full output.
   - Members print first, then the count, then any errors or warnings.
   - If the list has 0 members it warns and prints the `RecipientFilter` and `RecipientContainer`.
   - Checks that the signed-in account can run `Get-DynamicDistributionGroup` and `Get-Recipient`. If not, it offers to sign out and re-authenticate.
2. `Compare-DynamicDistributionListToDomain.ps1` (v1.0.0, new)
   - Reports domain recipients missing from the list.
   - Options: `-ExcludeInactive` (disabled accounts, uses `Get-User`), `-ExcludeShared` (shared, room and equipment mailboxes), `-ExcludeGroups` (groups and distribution lists).
   - Prompts for anything not passed as a parameter.
   - Both scripts are untested. Neither has been run since the edits.

## Open problem: AllAltronic returns 0 members
The script reports 0 members, so the compare shows all 234 domain users as "missing". That result is not meaningful until the 0 is explained.

The list's current filter, as the script printed it:
```
((((RecipientTypeDetails -eq 'UserMailbox') -and (EmailAddresses -like 'smtp:*@altronic-llc.com'))) -and (-not(Name -like 'SystemMailbox{*')) ... system mailbox exclusions ...)
RecipientContainer: CooperMachineryServices.onmicrosoft.com
```
This filter looks valid and should match many users, yet the preview returned nothing.

Hypothesis (unconfirmed): passing `-OrganizationalUnit $group.RecipientContainer` (the tenant root) to `Get-Recipient` causes the empty result.

A second filter was provided for comparison. I don't know which list it belongs to. It uses `CustomAttribute3 -eq 'Altronic'` and `RecipientType -eq 'UserMailbox'` (minus rooms and equipment), so it includes shared mailboxes and excludes `GuestMailUser`. It doesn't test the domain at all. If it belongs to AllAltronic, membership depends on `CustomAttribute3` being populated.

## Next steps
1. Run the three diagnostic counts in Exchange Online PowerShell:
   ```powershell
   $g = Get-DynamicDistributionGroup -Identity allaltronic@altronic-llc.com
   # A: same query as the script
   (Get-Recipient -RecipientPreviewFilter $g.RecipientFilter -OrganizationalUnit $g.RecipientContainer -ResultSize Unlimited).Count
   # B: same filter, no container
   (Get-Recipient -RecipientPreviewFilter $g.RecipientFilter -ResultSize Unlimited).Count
   # C: core condition only
   (Get-Recipient -RecipientTypeDetails UserMailbox -Filter "EmailAddresses -like 'smtp:*@altronic-llc.com'" -ResultSize Unlimited).Count
   ```
   - A is 0 and B is about 234: drop `-OrganizationalUnit` in the members script when the container is the tenant root.
   - A and B are both 0 and C is above 0: look at the filter's system-mailbox exclusions.
   - All three are 0: the signed-in account may lack read permission or scope.
2. Run the same kind of preview against the `CustomAttribute3` filter and check how many people it returns. If it is 0, the attribute isn't populated or is spelled differently.
3. Confirm which list the `CustomAttribute3` filter belongs to and what AllAltronic is meant to include.
4. Decide whether the compare script should accept a custom filter, so it can report domain users missing `CustomAttribute3`.
5. Run both scripts against a known list, confirm they work, then commit.

## Known limitations
- "Inactive" in the compare script means the account is disabled. It does not catch enabled accounts with no recent sign-in.
- The domain match uses the primary SMTP address only, so aliases in the domain are not counted.
- `-ExcludeInactive` needs `Get-User`, which may need a different admin role than the other cmdlets.
- The required admin roles in the permission-check message (Exchange Administrator, Global Reader, View-Only Recipients) were not checked against the tenant.

## Requirements
PowerShell 7+, the `ExchangeOnlineManagement` module (the scripts install it if missing), and an Exchange Online admin sign-in. Sign in with the admin account, not your regular one. A non-admin sign-in was the cause of the original "Get-DynamicDistributionGroup is not recognized" error.

# ============================================================
# Filename : Add-ContactsToDistributionList.ps1
# Revision : 3.6
# Description : Manages mail contacts in Microsoft 365 from a
#               CSV file. Supports Add, Update, and Remove
#               actions per contact including DL membership sync.
#               CSV format: Action, Name, Email, Company,
#               Email List, Status, Notes, Created By,
#               Modified, Modified By
# Author : Jason Lamb (with help from AI)
# Created Date : 2026-03-25
# Modified Date : 2026-03-25
# Changelog :
# 1.0 Initial release
# 1.1 Set default DistributionList to AltronicDistributorMgmtMailList
# 2.0 Reworked to match actual CSV format (Name, Email, Company, etc.)
#     Added empty row skipping, JSON array cleanup, Name splitting
# 2.1 Removed -DistributionList param; added $DLMap hashtable to map
#     Email List names to actual distribution list email addresses
# 2.2 Added full DLMap: Gas Engine Distributor, Packagers, GTI Bi-Fuel
# 2.3 Use email as -Name to avoid duplicate name conflicts in Exchange
# 2.4 Skip Connect-ExchangeOnline if already connected
# 2.5 Added per-action result tracking and CSV export to $psexports
# 2.6 Set alias from display name (e.g. Jason.Lamb) instead of email
#     Hide contact from GAL (HiddenFromAddressListsEnabled = $true)
# 2.7 Open exported CSV automatically when complete
# 2.8 Removed auto-disconnect from Exchange Online on completion
# 3.0 Added Update and Remove actions via Action column in CSV
# 3.1 Fixed alias generation - collapse consecutive periods, strip trailing periods
# 3.2 Skip contact creation for internal domains (cooperservices.com, altronic-llc.com)
#     but still add them to DLs as members
# 3.3 Default Action to "Add" when column is missing or empty in CSV
# 3.4 Treat "already a member" as Skipped instead of Failed when adding to DL
# 3.5 Added Delete action with other-group safety check before deletion
# 3.6 Added per-contact countdown showing current/total/remaining
#     Filter only requires Email (Name optional for deletes)
#     Added Skipped Users and Skipped Groups counters to summary
# ============================================================

<#
.SYNOPSIS
    Manages mail contacts in Microsoft 365 from a CSV — supports Add, Update, and Remove.
.PARAMETER CsvPath
    Path to the CSV file containing contact information.

.EXAMPLE
    & ".\Add-ContactsToDistributionList.ps1" -CsvPath ".\contacts.csv"

.NOTES
    Expected CSV columns:
      Action     - Add | Update | Remove
      Name       - Full name
      Email      - External email address
      Company    - Company name (may be JSON array format)
      Email List - JSON array of list names e.g. ["Distributor Management","GTI Bi-Fuel"]
      Status, Notes, Created By, Modified, Modified By (informational, not used by script)

    Action behaviors:
      Add    - Creates the contact if it does not exist; adds to all listed DLs
      Update - Updates Name/Company on existing contact; syncs DL memberships
               (adds to listed DLs, removes from any mapped DLs not in the list)
      Remove - Removes contact from all listed DLs; deletes the contact

    Update $DLMap in the script to map list names to distribution list email addresses.
    Requires Exchange Admin or Recipient Management role.
    Results are exported to $psexports as a CSV and opened on completion.
#>
param(
    [Parameter(Mandatory)]
    [string]$CsvPath
)

# ------------------------------------------------------------
# Internal domains - skip contact creation, add directly to DLs
# ------------------------------------------------------------
$InternalDomains = @(
    "cooperservices.com"
    "altronic-llc.com"
)

# ------------------------------------------------------------
# Distribution list name -> email address mapping
# Add more entries here as needed
# ------------------------------------------------------------
$DLMap = @{
    "Distributor Management" = "AltronicDistributorMgmtMailList@altronic-llc.com"
    "Gas Engine Distributor" = "AltronicDistributorMailList@altronic-llc.com"
    "Packagers"              = "AltronicPackagersMailList@altronic-llc.com"
    "GTI Bi-Fuel"            = "GTIDistributorMailList@altronic-llc.com"
}

# ------------------------------------------------------------
# Ensure ExchangeOnlineManagement module is available
# ------------------------------------------------------------
if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    Write-Host "Installing ExchangeOnlineManagement module..." -ForegroundColor Yellow
    Install-Module -Name ExchangeOnlineManagement -Scope CurrentUser -Force
}

Import-Module ExchangeOnlineManagement

# ------------------------------------------------------------
# Connect to Exchange Online (skip if already connected)
# ------------------------------------------------------------
if (-not (Get-ConnectionInformation -ErrorAction SilentlyContinue)) {
    Connect-ExchangeOnline
} else {
    Write-Host "Already connected to Exchange Online - skipping login" -ForegroundColor Gray
}

# ------------------------------------------------------------
# Validate CSV exists
# ------------------------------------------------------------
if (-not (Test-Path $CsvPath)) {
    Write-Error "CSV file not found: $CsvPath"
    exit 1
}

# Import and filter out empty rows (only email is required; Name can be blank for deletes)
$contacts = Import-Csv -Path $CsvPath | Where-Object { $_.Email -ne "" }

$results        = [System.Collections.Generic.List[PSCustomObject]]::new()
$successCount   = 0
$errorCount     = 0
$skippedUsers   = 0
$skippedGroups  = 0
$totalContacts  = ($contacts | Measure-Object).Count
$currentIndex   = 0

# Helper to add a result row
function Add-Result {
    param($Name, $Email, $Company, $Action, $DistList, $Status, $Notes)
    $results.Add([PSCustomObject]@{
        Name      = $Name
        Email     = $Email
        Company   = $Company
        Action    = $Action
        DistList  = $DistList
        Status    = $Status
        Notes     = $Notes
        Timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    })
}

foreach ($contact in $contacts) {
    $currentIndex++
    $remaining = $totalContacts - $currentIndex
    Write-Host "`n[$currentIndex of $totalContacts | $remaining remaining] Processing $($contact.Email)" -ForegroundColor White

    # Parse common fields
    $action      = if ($contact.Action) { $contact.Action.Trim() } else { "Add" }
    $nameParts   = $contact.Name.Trim().Split(" ", 2)
    $firstName   = $nameParts[0]
    $lastName    = if ($nameParts.Count -gt 1) { $nameParts[1] } else { "" }
    $displayName = $contact.Name.Trim()
    $email       = $contact.Email.Trim()
    $alias       = $displayName -replace '\s+', '.' -replace '[^a-zA-Z0-9.]', '' -replace '\.{2,}', '.' -replace '^\.+|\.+$', ''
    $company     = $contact.Company -replace '[\[\]\""]', '' | ForEach-Object { $_.Trim() }

    # Parse Email List JSON array
    $emailLists = $contact.'Email List' -replace '[\[\]\""]', '' -split ',' |
                  ForEach-Object { $_.Trim() } |
                  Where-Object { $_ -ne "" }

    # Resolve listed DL names to email addresses (skip unmapped)
    $targetDLs = $emailLists | Where-Object { $DLMap.ContainsKey($_) } |
                               ForEach-Object { $DLMap[$_] }

    $existing = Get-MailContact -Identity $email -ErrorAction SilentlyContinue
    $emailDomain   = $email.Split("@")[1].ToLower()
    $isInternal    = $InternalDomains -contains $emailDomain

    switch ($action) {

        # --------------------------------------------------------
        # ADD - Create contact (if external) and add to listed DLs
        # --------------------------------------------------------
        "Add" {
            if ($isInternal) {
                Write-Host "[$email] Internal domain - skipping contact creation" -ForegroundColor Yellow
                Add-Result $displayName $email $company "Create Contact" "" "Skipped" "Internal domain ($emailDomain) - no contact creation needed"
                $skippedUsers++
            } elseif ($existing) {
                Write-Host "[$email] Already exists - skipping creation" -ForegroundColor Yellow
                Add-Result $displayName $email $company "Create Contact" "" "Skipped" "Contact already exists"
                $skippedUsers++
            } else {
                try {
                    New-MailContact `
                        -FirstName $firstName `
                        -LastName $lastName `
                        -Name $email `
                        -Alias $alias `
                        -DisplayName $displayName `
                        -ExternalEmailAddress $email `
                        -ErrorAction Stop

                    if ($company) {
                        Set-Contact -Identity $email -Company $company -ErrorAction SilentlyContinue
                    }

                    Set-MailContact -Identity $email -HiddenFromAddressListsEnabled $true -ErrorAction SilentlyContinue

                    Write-Host "[$email] Created contact: $displayName" -ForegroundColor Green
                    $successCount++
                    Add-Result $displayName $email $company "Create Contact" "" "Created" "Contact created successfully"
                } catch {
                    Write-Warning "[$email] Failed to create contact: $_"
                    $errorCount++
                    Add-Result $displayName $email $company "Create Contact" "" "Failed" $_.Exception.Message
                }
            }

            foreach ($listName in $emailLists) {
                if (-not $DLMap.ContainsKey($listName)) {
                    Write-Warning "[$email] No mapping for list '$listName' - skipping"
                    Add-Result $displayName $email $company "Add to DL" $listName "Skipped" "No DL mapping found for '$listName'"
                    continue
                }
                $dlAddress = $DLMap[$listName]
                try {
                    Add-DistributionGroupMember -Identity $dlAddress -Member $email -ErrorAction Stop
                    Write-Host "  [$email] Added to '$dlAddress'" -ForegroundColor Cyan
                    $successCount++
                    Add-Result $displayName $email $company "Add to DL" $dlAddress "Success" "Added via list name '$listName'"
                } catch {
                    if ($_.Exception.Message -match "already a member") {
                        Write-Host "  [$email] Already a member of '$dlAddress' - skipping" -ForegroundColor Gray
                        Add-Result $displayName $email $company "Add to DL" $dlAddress "Skipped" "Already a member"
                        $skippedGroups++
                    } else {
                        Write-Warning "  [$email] Failed to add to '$dlAddress': $_"
                        $errorCount++
                        Add-Result $displayName $email $company "Add to DL" $dlAddress "Failed" $_.Exception.Message
                    }
                }
            }
        }

        # --------------------------------------------------------
        # UPDATE - Update contact properties and sync DL memberships
        # --------------------------------------------------------
        "Update" {
            if (-not $existing) {
                Write-Warning "[$email] Contact not found - cannot update"
                Add-Result $displayName $email $company "Update Contact" "" "Failed" "Contact not found"
                $errorCount++
                continue
            }

            try {
                Set-MailContact `
                    -Identity $email `
                    -DisplayName $displayName `
                    -HiddenFromAddressListsEnabled $true `
                    -ErrorAction Stop

                Set-Contact -Identity $email `
                    -FirstName $firstName `
                    -LastName $lastName `
                    -Company $company `
                    -ErrorAction Stop

                Write-Host "[$email] Updated contact: $displayName" -ForegroundColor Green
                $successCount++
                Add-Result $displayName $email $company "Update Contact" "" "Updated" "Contact properties updated"
            } catch {
                Write-Warning "[$email] Failed to update contact: $_"
                $errorCount++
                Add-Result $displayName $email $company "Update Contact" "" "Failed" $_.Exception.Message
            }

            # Sync DL memberships - add to listed, remove from mapped DLs not in list
            foreach ($dlAddress in $DLMap.Values) {
                $isMember   = $null -ne (Get-DistributionGroupMember -Identity $dlAddress -ErrorAction SilentlyContinue | Where-Object { $_.PrimarySmtpAddress -eq $email })
                $shouldBeIn = $targetDLs -contains $dlAddress

                if ($shouldBeIn -and -not $isMember) {
                    try {
                        Add-DistributionGroupMember -Identity $dlAddress -Member $email -ErrorAction Stop
                        Write-Host "  [$email] Added to '$dlAddress'" -ForegroundColor Cyan
                        $successCount++
                        Add-Result $displayName $email $company "Add to DL" $dlAddress "Success" "Added during sync"
                    } catch {
                        Write-Warning "  [$email] Failed to add to '$dlAddress': $_"
                        $errorCount++
                        Add-Result $displayName $email $company "Add to DL" $dlAddress "Failed" $_.Exception.Message
                    }
                } elseif (-not $shouldBeIn -and $isMember) {
                    try {
                        Remove-DistributionGroupMember -Identity $dlAddress -Member $email -Confirm:$false -ErrorAction Stop
                        Write-Host "  [$email] Removed from '$dlAddress'" -ForegroundColor DarkYellow
                        $successCount++
                        Add-Result $displayName $email $company "Remove from DL" $dlAddress "Success" "Removed during sync"
                    } catch {
                        Write-Warning "  [$email] Failed to remove from '$dlAddress': $_"
                        $errorCount++
                        Add-Result $displayName $email $company "Remove from DL" $dlAddress "Failed" $_.Exception.Message
                    }
                }
            }
        }

        # --------------------------------------------------------
        # REMOVE - Remove from listed DLs and delete contact
        # --------------------------------------------------------
        "Remove" {
            if (-not $existing) {
                Write-Warning "[$email] Contact not found - nothing to remove"
                Add-Result $displayName $email $company "Remove Contact" "" "Skipped" "Contact not found"
                continue
            }

            foreach ($listName in $emailLists) {
                if (-not $DLMap.ContainsKey($listName)) {
                    Write-Warning "[$email] No mapping for list '$listName' - skipping"
                    Add-Result $displayName $email $company "Remove from DL" $listName "Skipped" "No DL mapping found for '$listName'"
                    continue
                }
                $dlAddress = $DLMap[$listName]
                try {
                    Remove-DistributionGroupMember -Identity $dlAddress -Member $email -Confirm:$false -ErrorAction Stop
                    Write-Host "  [$email] Removed from '$dlAddress'" -ForegroundColor DarkYellow
                    $successCount++
                    Add-Result $displayName $email $company "Remove from DL" $dlAddress "Success" "Removed via list name '$listName'"
                } catch {
                    Write-Warning "  [$email] Failed to remove from '$dlAddress': $_"
                    $errorCount++
                    Add-Result $displayName $email $company "Remove from DL" $dlAddress "Failed" $_.Exception.Message
                }
            }

            try {
                Remove-MailContact -Identity $email -Confirm:$false -ErrorAction Stop
                Write-Host "[$email] Deleted contact: $displayName" -ForegroundColor Red
                $successCount++
                Add-Result $displayName $email $company "Delete Contact" "" "Deleted" "Contact deleted successfully"
            } catch {
                Write-Warning "[$email] Failed to delete contact: $_"
                $errorCount++
                Add-Result $displayName $email $company "Delete Contact" "" "Failed" $_.Exception.Message
            }
        }

        # --------------------------------------------------------
        # DELETE - Remove from listed DLs and delete contact
        #          Skips deletion if contact is in other groups
        # --------------------------------------------------------
        "Delete" {
            if (-not $existing) {
                Write-Warning "[$email] Contact not found - nothing to delete"
                Add-Result $displayName $email $company "Delete Contact" "" "Skipped" "Contact not found"
                continue
            }

            # Remove from each listed DL first
            foreach ($listName in $emailLists) {
                if (-not $DLMap.ContainsKey($listName)) { continue }
                $dlAddress = $DLMap[$listName]
                try {
                    Remove-DistributionGroupMember -Identity $dlAddress -Member $email -Confirm:$false -ErrorAction Stop
                    Write-Host "  [$email] Removed from '$dlAddress'" -ForegroundColor DarkYellow
                    Add-Result $displayName $email $company "Remove from DL" $dlAddress "Success" "Removed prior to deletion"
                } catch {
                    Write-Warning "  [$email] Failed to remove from '$dlAddress': $_"
                    Add-Result $displayName $email $company "Remove from DL" $dlAddress "Failed" $_.Exception.Message
                }
            }

            # Check for membership in any groups outside the mapped DLs
            $otherGroups = Get-DistributionGroup -ErrorAction SilentlyContinue | Where-Object {
                $DLMap.Values -notcontains $_.PrimarySmtpAddress
            } | Where-Object {
                $null -ne (Get-DistributionGroupMember -Identity $_.Identity -ResultSize Unlimited -ErrorAction SilentlyContinue |
                           Where-Object { $_.PrimarySmtpAddress -eq $email })
            }

            if ($otherGroups) {
                $groupList = ($otherGroups.DisplayName) -join ", "
                Write-Warning "[$email] Still a member of other groups ($groupList) - skipping deletion"
                $errorCount++
                Add-Result $displayName $email $company "Delete Contact" "" "Skipped" "Still a member of: $groupList"
            } else {
                try {
                    Remove-MailContact -Identity $email -Confirm:$false -ErrorAction Stop
                    Write-Host "[$email] Deleted contact" -ForegroundColor Red
                    $successCount++
                    Add-Result $displayName $email $company "Delete Contact" "" "Deleted" "Contact deleted successfully"
                } catch {
                    Write-Warning "[$email] Failed to delete contact: $_"
                    $errorCount++
                    Add-Result $displayName $email $company "Delete Contact" "" "Failed" $_.Exception.Message
                }
            }
        }

        default {
            Write-Warning "[$email] Unknown action '$action' - skipping (valid values: Add, Update, Remove, Delete)"
            Add-Result $displayName $email $company $action "" "Skipped" "Unknown action value '$action'"
        }
    }
}

# ------------------------------------------------------------
# Export results to $psexports
# ------------------------------------------------------------
$timestamp  = Get-Date -Format "yyyyMMdd_HHmmss"
$exportPath = Join-Path $psexports "ContactDeltaReport_$timestamp.csv"
$results | Export-Csv -Path $exportPath -NoTypeInformation

Write-Host "`nDone. Success: $successCount | Errors: $errorCount | Skipped Users: $skippedUsers | Skipped Groups: $skippedGroups" -ForegroundColor White
Write-Host "Report exported to: $exportPath" -ForegroundColor White

Invoke-Item $exportPath

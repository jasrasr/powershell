# ============================================================
# Filename : Add-ContactsToDistributionList.ps1
# Revision : 2.8
# Description : Imports contacts from a CSV file, creates them
#               as mail contacts in Microsoft 365, and adds
#               each contact to distribution lists based on the
#               Email List column mapping.
#               CSV format: Name, Email, Company, Email List,
#               Status, Notes, Created By, Modified, Modified By
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
# ============================================================

<#
.SYNOPSIS
    Imports contacts from a CSV and adds them to distribution lists in Microsoft 365
    based on the Email List column in the CSV.
.PARAMETER CsvPath
    Path to the CSV file containing contact information.

.EXAMPLE
    & ".\Add-ContactsToDistributionList.ps1" -CsvPath ".\contacts.csv"

.NOTES
    Expected CSV columns: Name, Email, Company, Email List, Status, Notes, Created By, Modified, Modified By
    The Email List column contains a JSON array of list names (e.g. ["Distributor Management","Gas Engine Distributor"]).
    Update $DLMap in the script to map list names to distribution list email addresses.
    Requires Exchange Admin or Recipient Management role.
    Results are exported to $psexports as a CSV.
#>
param(
    [Parameter(Mandatory)]
    [string]$CsvPath
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

# Import and filter out empty rows
$contacts = Import-Csv -Path $CsvPath | Where-Object { $_.Email -ne "" -and $_.Name -ne "" }

$results      = [System.Collections.Generic.List[PSCustomObject]]::new()
$successCount = 0
$errorCount   = 0

foreach ($contact in $contacts) {
    # Split full name into first/last
    $nameParts   = $contact.Name.Trim().Split(" ", 2)
    $firstName   = $nameParts[0]
    $lastName    = if ($nameParts.Count -gt 1) { $nameParts[1] } else { "" }
    $displayName = $contact.Name.Trim()
    $email       = $contact.Email.Trim()
    $alias       = $displayName -replace '\s+', '.' -replace '[^a-zA-Z0-9.]', ''

    # Strip JSON array formatting from Company field e.g. ["GenMar"] -> GenMar
    $company = $contact.Company -replace '[\[\]\""]', '' | ForEach-Object { $_.Trim() }

    # Parse Email List JSON array e.g. ["Distributor Management","Gas Engine Distributor"]
    $emailLists = $contact.'Email List' -replace '[\[\]\""]', '' -split ',' |
                  ForEach-Object { $_.Trim() } |
                  Where-Object { $_ -ne "" }

    # --------------------------------------------------------
    # Create contact if it doesn't exist
    # --------------------------------------------------------
    $contactStatus = ""
    $contactNote   = ""

    $existing = Get-MailContact -Identity $email -ErrorAction SilentlyContinue

    if ($existing) {
        $contactStatus = "Skipped"
        $contactNote   = "Contact already exists"
        Write-Host "Contact already exists: $email - skipping creation" -ForegroundColor Yellow
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

            $contactStatus = "Created"
            $contactNote   = "Contact created successfully"
            Write-Host "Created contact: $displayName ($email)" -ForegroundColor Green
        } catch {
            $contactStatus = "Failed"
            $contactNote   = $_.Exception.Message
            Write-Warning "Failed to create contact $email`: $_"
        }
    }

    $results.Add([PSCustomObject]@{
        Name          = $displayName
        Email         = $email
        Company       = $company
        Action        = "Create Contact"
        DistList      = ""
        Status        = $contactStatus
        Notes         = $contactNote
        Timestamp     = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    })

    # --------------------------------------------------------
    # Add contact to each mapped distribution list
    # --------------------------------------------------------
    foreach ($listName in $emailLists) {
        if ($DLMap.ContainsKey($listName)) {
            $dlAddress = $DLMap[$listName]
            try {
                Add-DistributionGroupMember `
                    -Identity $dlAddress `
                    -Member $email `
                    -ErrorAction Stop

                Write-Host "  Added to '$dlAddress' (via '$listName')" -ForegroundColor Cyan
                $successCount++

                $results.Add([PSCustomObject]@{
                    Name      = $displayName
                    Email     = $email
                    Company   = $company
                    Action    = "Add to DL"
                    DistList  = $dlAddress
                    Status    = "Success"
                    Notes     = "Added via list name '$listName'"
                    Timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
                })
            } catch {
                Write-Warning "  Failed to add $email to '$dlAddress': $_"
                $errorCount++

                $results.Add([PSCustomObject]@{
                    Name      = $displayName
                    Email     = $email
                    Company   = $company
                    Action    = "Add to DL"
                    DistList  = $dlAddress
                    Status    = "Failed"
                    Notes     = $_.Exception.Message
                    Timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
                })
            }
        } else {
            Write-Warning "  No mapping found for list '$listName' - skipping"

            $results.Add([PSCustomObject]@{
                Name      = $displayName
                Email     = $email
                Company   = $company
                Action    = "Add to DL"
                DistList  = $listName
                Status    = "Skipped"
                Notes     = "No DL mapping found for '$listName'"
                Timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
            })
        }
    }
}

# ------------------------------------------------------------
# Export results to $psexports
# ------------------------------------------------------------
$timestamp  = Get-Date -Format "yyyyMMdd_HHmmss"
$exportPath = Join-Path $psexports "AddContactsToDL_$timestamp.csv"
$results | Export-Csv -Path $exportPath -NoTypeInformation

Write-Host "`nDone. Success: $successCount | Errors: $errorCount" -ForegroundColor White
Write-Host "Report exported to: $exportPath" -ForegroundColor White

Invoke-Item $exportPath

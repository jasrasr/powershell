# ============================================================
# Filename : Add-ContactsToDistributionList.ps1
# Revision : 1.0
# Description : Imports contacts from a CSV file, creates them
#               as mail contacts in Microsoft 365, and adds
#               each contact to a specified distribution list.
# Author : Jason Lamb (with help from AI)
# Created Date : 2026-03-25
# Modified Date : 2026-03-25
# Changelog :
# 1.0 Initial release
# ============================================================

<#
.SYNOPSIS
    Imports contacts from a CSV and adds them to a distribution list in Microsoft 365.
.PARAMETER CsvPath
    Path to the CSV file containing contact information.
.PARAMETER DistributionList
    Email address or name of the distribution list to add contacts to.

.EXAMPLE
    .\Add-ContactsToDistributionList.ps1 -CsvPath ".\contacts.csv" -DistributionList "dl-newsletter@yourdomain.com"

.NOTES
    Expected CSV columns: FirstName, LastName, DisplayName, Email, Company, Phone
    Requires Exchange Admin or Recipient Management role.
#>
param(
    [Parameter(Mandatory)]
    [string]$CsvPath,

    [Parameter(Mandatory)]
    [string]$DistributionList
)

# ------------------------------------------------------------
# Ensure ExchangeOnlineManagement module is available
# ------------------------------------------------------------
if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    Write-Host "Installing ExchangeOnlineManagement module..." -ForegroundColor Yellow
    Install-Module -Name ExchangeOnlineManagement -Scope CurrentUser -Force
}

Import-Module ExchangeOnlineManagement

# ------------------------------------------------------------
# Connect to Exchange Online
# ------------------------------------------------------------
Connect-ExchangeOnline

# ------------------------------------------------------------
# Validate CSV exists
# ------------------------------------------------------------
if (-not (Test-Path $CsvPath)) {
    Write-Error "CSV file not found: $CsvPath"
    exit 1
}

$contacts = Import-Csv -Path $CsvPath
$successCount = 0
$errorCount = 0

foreach ($contact in $contacts) {
    try {
        # Check if contact already exists
        $existing = Get-MailContact -Identity $contact.Email -ErrorAction SilentlyContinue

        if ($existing) {
            Write-Host "Contact already exists: $($contact.Email) — skipping creation" -ForegroundColor Yellow
        } else {
            # Create the mail contact
            New-MailContact `
                -FirstName $contact.FirstName `
                -LastName $contact.LastName `
                -Name $contact.DisplayName `
                -DisplayName $contact.DisplayName `
                -ExternalEmailAddress $contact.Email `
                -OrganizationalUnit "Users"

            # Set additional properties if provided
            if ($contact.Company -or $contact.Phone) {
                Set-Contact -Identity $contact.Email `
                    -Company $contact.Company `
                    -Phone $contact.Phone
            }

            Write-Host "Created contact: $($contact.DisplayName) <$($contact.Email)>" -ForegroundColor Green
        }

        # Add contact to distribution list
        Add-DistributionGroupMember `
            -Identity $DistributionList `
            -Member $contact.Email `
            -ErrorAction Stop

        Write-Host "  Added to '$DistributionList'" -ForegroundColor Cyan
        $successCount++

    } catch {
        Write-Warning "Failed for $($contact.Email): $_"
        $errorCount++
    }
}

Write-Host "`nDone. Success: $successCount | Errors: $errorCount" -ForegroundColor White
Disconnect-ExchangeOnline -Confirm:$false

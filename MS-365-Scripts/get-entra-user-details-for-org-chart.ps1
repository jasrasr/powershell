# Filename: get-entra-user-details.ps1
# Revision: 1.7
# Description: Gets all Entra/Azure AD user details including first, last, display, email,
#              job title, department, company, manager, manager email, mailbox type, and status
#              Exports a full report and a trimmed org chart CSV
# Author: Jason Lamb (with help from Claude)
# Created Date: 2026-03-16
# Modified Date: 2026-03-16
# Changelog
# 1.0 Initial release - basic user export with department filter
# 1.1 Switched from AzureAD module to Microsoft.Graph
# 1.2 Added manager lookup using AdditionalProperties
# 1.3 Added progress bar, switched to List for performance
# 1.4 Added Status column (Active/Disabled/Shared), dual CSV export with timestamp
# 1.5 Switched output path to $PSExports, added summary with domain breakdown
# 1.6 Filter to active user mailboxes only, skip users with no manager assigned
# 1.7 Added Department and CompanyName columns, skip self-referencing managers (e.g. Annie Creager)

# ── CONFIG ─────────────────────────────────────────────────────────────────────
$outputDir  = $PSExports
$timestamp  = Get-Date -Format "yyyy-MM-dd_HHmm"
$exportPath = "$outputDir\orgchart_$timestamp.csv"
$latestPath = "$outputDir\orgchart.csv"
# ──────────────────────────────────────────────────────────────────────────────

# Ensure output folder exists
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
    Write-Host "Created folder: $outputDir" -ForegroundColor Cyan
}

# ── STEP 1: Connect ────────────────────────────────────────────────────────────
Write-Host "`nConnecting to Microsoft Graph..." -ForegroundColor Cyan
Connect-MgGraph -Scopes "User.Read.All", "Directory.Read.All" | Out-Null
Write-Host "Connected." -ForegroundColor Green

# ── STEP 2: Fetch user list ────────────────────────────────────────────────────
# Excludes: guests, disabled accounts, shared mailboxes (AccountEnabled = false)
Write-Host "`nFetching user list..." -ForegroundColor Cyan
$allUsers = Get-MgUser -All -Property Id, DisplayName, GivenName, Surname, UserPrincipalName, JobTitle, Department, CompanyName, UserType, AccountEnabled |
    Where-Object {
        $_.UserType       -ne "Guest" -and
        $_.AccountEnabled -eq $true
    }

$total = $allUsers.Count
Write-Host "Found $total users. Starting manager lookups..." -ForegroundColor Cyan

# ── STEP 3: Manager lookups with progress bar ──────────────────────────────────
$report = [System.Collections.Generic.List[PSCustomObject]]::new()
$i = 0

foreach ($user in $allUsers) {
    $i++
    $pct = [math]::Round(($i / $total) * 100)

    Write-Progress -Activity "Looking up managers" `
                   -Status "$i of $total — $($user.DisplayName)" `
                   -PercentComplete $pct

    try {
        $manager      = Get-MgUserManager -UserId $user.UserPrincipalName -ErrorAction Stop
        $managerName  = $manager.AdditionalProperties["displayName"]
        $managerEmail = $manager.AdditionalProperties["userPrincipalName"]
    } catch {
        $managerName  = "No Manager"
        $managerEmail = ""
    }

    # Skip users with no manager assigned
    if ($managerEmail -eq "") { continue }

    # Skip self-referencing managers (e.g. top of org like Annie Creager reports to herself)
    # These users will appear as root nodes in the org chart via the HTML's root detection
    if ($managerEmail -eq $user.UserPrincipalName.ToLower()) {
        $managerName  = ""
        $managerEmail = ""
    }

    $report.Add([PSCustomObject]@{
        DisplayName  = $user.DisplayName
        FirstName    = $user.GivenName
        LastName     = $user.Surname
        Email        = $user.UserPrincipalName
        JobTitle     = $user.JobTitle
        Department   = $user.Department
        CompanyName  = $user.CompanyName
        ManagerName  = $managerName
        ManagerEmail = $managerEmail
        MailboxType  = "User Mailbox"
        Status       = "Active"
    })
}

Write-Progress -Activity "Looking up managers" -Completed
Write-Host "Manager lookups complete." -ForegroundColor Green

# ── STEP 4: Export full report ─────────────────────────────────────────────────
Write-Host "`nExporting full report..." -ForegroundColor Cyan
$report | Sort-Object DisplayName |
    Export-Csv -Path $exportPath -NoTypeInformation
Write-Host "Full report : $exportPath" -ForegroundColor Green

# ── STEP 5: Export org chart CSV (trimmed for HTML viewer) ────────────────────
Write-Host "Exporting org chart CSV..." -ForegroundColor Cyan
$report | Sort-Object DisplayName |
    Select-Object DisplayName, Email, JobTitle, ManagerEmail, Department, CompanyName, Status |
    Export-Csv -Path $latestPath -NoTypeInformation
Write-Host "Org chart   : $latestPath" -ForegroundColor Green

# ── STEP 6: Summary ────────────────────────────────────────────────────────────
$exported      = $report.Count
$skipped       = $total - $exported
$noCompany     = ($report | Where-Object { $_.CompanyName -eq "" }).Count
$noDept        = ($report | Where-Object { $_.Department  -eq "" }).Count
$companies     = $report | Group-Object CompanyName | Sort-Object Count -Descending
$domains       = $report | Group-Object { ($_.Email -split "@")[1] } | Sort-Object Count -Descending

Write-Host "`n── Summary ───────────────────────────────────" -ForegroundColor Cyan
Write-Host "  Fetched (active, non-guest) : $total"
Write-Host "  Exported (has manager)      : $exported"
Write-Host "  Skipped (no manager)        : $skipped"   -ForegroundColor Yellow
Write-Host "  Missing CompanyName         : $noCompany" -ForegroundColor Yellow
Write-Host "  Missing Department          : $noDept"    -ForegroundColor Yellow
Write-Host "`n  Companies found :"
$companies | ForEach-Object { Write-Host "    $($_.Name.PadRight(45)) $($_.Count) users" }
Write-Host "`n  Domains found :"
$domains   | ForEach-Object { Write-Host "    $($_.Name.PadRight(45)) $($_.Count) users" }
Write-Host "──────────────────────────────────────────────" -ForegroundColor Cyan

# ── STEP 7: Open both files ────────────────────────────────────────────────────
Invoke-Item $exportPath
Invoke-Item $latestPath
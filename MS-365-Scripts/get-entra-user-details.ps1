# ── CONFIG ─────────────────────────────────────────────────────────────────────
$outputDir  = "C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\Documents\OrgChart"
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
Write-Host "`nFetching user list..." -ForegroundColor Cyan
$allUsers = Get-MgUser -All -Property Id, DisplayName, GivenName, Surname, UserPrincipalName, JobTitle, UserType, AccountEnabled |
    Where-Object { $_.UserType -ne "Guest" }

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

    $mailboxType = if ($user.AccountEnabled -eq $false) { "Shared Mailbox" } else { "User Mailbox" }
    $status      = if ($user.AccountEnabled -eq $false) { "Shared" } else { "Active" }

    $report.Add([PSCustomObject]@{
        DisplayName  = $user.DisplayName
        FirstName    = $user.GivenName
        LastName     = $user.Surname
        Email        = $user.UserPrincipalName
        JobTitle     = $user.JobTitle
        ManagerName  = $managerName
        ManagerEmail = $managerEmail
        MailboxType  = $mailboxType
        Status       = $status
    })
}

Write-Progress -Activity "Looking up managers" -Completed
Write-Host "Manager lookups complete." -ForegroundColor Green

# ── STEP 4: Export full report ─────────────────────────────────────────────────
Write-Host "`nExporting full report..." -ForegroundColor Cyan
$report | Sort-Object DisplayName |
    Export-Csv -Path $exportPath -NoTypeInformation

Write-Host "Full report: $exportPath" -ForegroundColor Green

# ── STEP 5: Export org chart CSV (4 cols + Status) ────────────────────────────
Write-Host "Exporting org chart CSV..." -ForegroundColor Cyan
$report | Sort-Object DisplayName |
    Select-Object DisplayName, Email, JobTitle, ManagerEmail, Status |
    Export-Csv -Path $latestPath -NoTypeInformation

Write-Host "Org chart CSV: $latestPath" -ForegroundColor Green

# ── STEP 6: Summary ────────────────────────────────────────────────────────────
$activeCount  = ($report | Where-Object { $_.Status -eq "Active"  }).Count
$sharedCount  = ($report | Where-Object { $_.Status -eq "Shared"  }).Count
$noMgrCount   = ($report | Where-Object { $_.ManagerEmail -eq ""  }).Count
$domains      = $report | Group-Object { ($_.Email -split "@")[1] } | Sort-Object Count -Descending

Write-Host "`n── Summary ───────────────────────────────────" -ForegroundColor Cyan
Write-Host "  Total users   : $total"
Write-Host "  Active        : $activeCount"
Write-Host "  Shared        : $sharedCount"
Write-Host "  No manager    : $noMgrCount"
Write-Host "`n  Domains found:"
$domains | ForEach-Object { Write-Host "    $($_.Name.PadRight(35)) $($_.Count) users" }
Write-Host "──────────────────────────────────────────────" -ForegroundColor Cyan

# ── STEP 7: Open both files ────────────────────────────────────────────────────
Invoke-Item $exportPath
Invoke-Item $latestPath
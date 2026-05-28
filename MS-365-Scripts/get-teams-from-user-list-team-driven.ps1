# Filename: get-teams-from-user-list-team-driven.ps1
# Revision : 1.2.0
# Description : Reads a CSV of users (column "Email") and exports every Microsoft Teams team
#               any of them are an Owner or Member of. Scans every Teams-enabled M365 group
#               in the tenant (team-driven approach). Output is deduped to one row per team
#               and includes the full owner/member roster plus which input users matched.
#               Prints start/end timestamps and total duration for tenant-scan benchmarking.
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-05-27
# Modified Date : 2026-05-27
# Changelog :
# 1.0.0 initial release (filename: get-teams-from-user-list.ps1)
# 1.1.0 renamed to -team-driven; added start/stop timestamps and duration tracking
# 1.2.0 added -OutputCsv parameter to override default export path

param(
    [Parameter(Mandatory = $false)]
    [string]$CsvPath,

    [Parameter(Mandatory = $false)]
    [string]$OutputCsv
)

# ---- Timing -----------------------------------------------------------------
$scriptStart = Get-Date
Write-Host "Script started: $($scriptStart.ToString('yyyy-MM-dd HH:mm:ss'))" -ForegroundColor Magenta

# ---- Module dependencies ----------------------------------------------------
foreach ($module in @("Microsoft.Graph.Authentication", "Microsoft.Graph.Users", "Microsoft.Graph.Groups")) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Host "Installing $module..." -ForegroundColor Cyan
        Install-Module $module -Scope CurrentUser -Force
    }
    if (-not (Get-Module -Name $module)) {
        Write-Host "Importing $module..." -ForegroundColor Cyan
        Import-Module $module
    }
}

# ---- Prompt for input CSV if not supplied -----------------------------------
if (-not $CsvPath) {
    $CsvPath = Read-Host "Enter the full path to the input CSV (must have an 'Email' column)"
}

if (-not (Test-Path -LiteralPath $CsvPath)) {
    Write-Host "Input CSV not found: $CsvPath" -ForegroundColor Red
    return
}

$inputRows = Import-Csv -LiteralPath $CsvPath
if (-not $inputRows -or -not ($inputRows[0].PSObject.Properties.Name -contains 'Email')) {
    Write-Host "Input CSV must have a column named 'Email'." -ForegroundColor Red
    return
}

$inputEmails = $inputRows |
    Where-Object { $_.Email -and $_.Email.Trim() } |
    ForEach-Object { $_.Email.Trim() } |
    Sort-Object -Unique

if (-not $inputEmails) {
    Write-Host "No email addresses found in the input CSV." -ForegroundColor Red
    return
}

Write-Host "Loaded $($inputEmails.Count) unique email(s) from input." -ForegroundColor Green

# ---- Connect to Microsoft Graph (only if not already connected) -------------
$graphContext = Get-MgContext
if (-not $graphContext) {
    Connect-MgGraph -Scopes "Group.Read.All","User.Read.All" -NoWelcome
    $graphContext = Get-MgContext
} else {
    Write-Host "Already connected to Microsoft Graph as $($graphContext.Account)" -ForegroundColor Green
}

# ---- Resolve each input email to an Mg user --------------------------------
Write-Host "`nResolving input users in Microsoft Graph..." -ForegroundColor Cyan

$inputUserIdToUpn = @{}
$missingUsers     = @()

foreach ($email in $inputEmails) {
    try {
        $u = Get-MgUser -UserId $email -ErrorAction Stop -Property Id,UserPrincipalName,Mail
        $inputUserIdToUpn[$u.Id] = $u.UserPrincipalName
    }
    catch {
        Write-Host "  Not found in Graph: $email" -ForegroundColor Yellow
        $missingUsers += $email
    }
}

if (-not $inputUserIdToUpn.Count) {
    Write-Host "No input users could be resolved in Microsoft Graph. Aborting." -ForegroundColor Red
    return
}

Write-Host "Resolved $($inputUserIdToUpn.Count) of $($inputEmails.Count) input user(s)." -ForegroundColor Green
if ($missingUsers.Count) {
    Write-Host "Unresolved users will be skipped: $($missingUsers -join ', ')" -ForegroundColor Yellow
}

# ---- Pull every Teams-enabled M365 group ------------------------------------
Write-Host "`nRetrieving all Teams-enabled M365 groups (this can take a minute)..." -ForegroundColor Cyan

$teams = Get-MgGroup -All `
    -Filter "resourceProvisioningOptions/Any(x:x eq 'Team')" `
    -Property Id,DisplayName,Mail,Visibility

Write-Host "Found $($teams.Count) Teams-enabled group(s) to scan." -ForegroundColor Green

# ---- Scan each team once; capture teams that contain any input user ---------
$results = New-Object System.Collections.Generic.List[object]
$teamIndex = 0

foreach ($team in $teams) {
    $teamIndex++
    Write-Progress -Activity "Scanning Teams" -Status "$teamIndex of $($teams.Count) - $($team.DisplayName)" `
        -PercentComplete ([int](($teamIndex / [Math]::Max($teams.Count,1)) * 100))

    try {
        $owners  = Get-MgGroupOwner  -GroupId $team.Id -All -ErrorAction Stop
        $members = Get-MgGroupMember -GroupId $team.Id -All -ErrorAction Stop
    }
    catch {
        Write-Host "  Skipping '$($team.DisplayName)' (failed to read roster): $($_.Exception.Message)" -ForegroundColor Yellow
        continue
    }

    $ownerIds  = @($owners  | ForEach-Object { $_.Id })
    $memberIds = @($members | ForEach-Object { $_.Id })

    $matchedIds = @()
    foreach ($inputId in $inputUserIdToUpn.Keys) {
        if ($ownerIds -contains $inputId -or $memberIds -contains $inputId) {
            $matchedIds += $inputId
        }
    }

    if (-not $matchedIds) { continue }

    $ownerUpns  = @($owners  | ForEach-Object { $_.AdditionalProperties.userPrincipalName } | Where-Object { $_ } | Sort-Object -Unique)
    $memberUpns = @($members | ForEach-Object { $_.AdditionalProperties.userPrincipalName } | Where-Object { $_ } | Sort-Object -Unique)
    $matchedUpns = @($matchedIds | ForEach-Object { $inputUserIdToUpn[$_] } | Sort-Object -Unique)

    $results.Add([PSCustomObject]@{
        TeamName          = $team.DisplayName
        TeamEmail         = $team.Mail
        Visibility        = $team.Visibility
        OwnerCount        = $ownerUpns.Count
        MemberCount       = $memberUpns.Count
        AllOwners         = ($ownerUpns  -join '; ')
        AllMembers        = ($memberUpns -join '; ')
        MatchedInputUsers = ($matchedUpns -join '; ')
    }) | Out-Null
}

Write-Progress -Activity "Scanning Teams" -Completed

if (-not $results.Count) {
    Write-Host "`nNo teams matched any user in the input CSV." -ForegroundColor Yellow
    $scriptEnd = Get-Date
    Write-Host "Script ended:   $($scriptEnd.ToString('yyyy-MM-dd HH:mm:ss'))" -ForegroundColor Magenta
    Write-Host "Total duration: $(($scriptEnd - $scriptStart).ToString('hh\:mm\:ss'))" -ForegroundColor Magenta
    return
}

$results = $results | Sort-Object TeamName

# ---- Screen output ----------------------------------------------------------
Write-Host "`n========================================" -ForegroundColor Yellow
Write-Host "TEAMS MATCHING INPUT USERS ($($results.Count))" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow

foreach ($r in $results) {
    Write-Host ""
    Write-Host "Team        : $($r.TeamName)" -ForegroundColor White
    Write-Host "Email       : $($r.TeamEmail)" -ForegroundColor Gray
    Write-Host "Visibility  : $($r.Visibility)" -ForegroundColor Gray
    Write-Host "Matched     : $($r.MatchedInputUsers)" -ForegroundColor Green
    Write-Host "Owners ($($r.OwnerCount))  : $($r.AllOwners)" -ForegroundColor Cyan
    Write-Host "Members ($($r.MemberCount)) : $($r.AllMembers)" -ForegroundColor DarkCyan
    Write-Host "----------------------------------------" -ForegroundColor DarkGray
}

# ---- CSV output -------------------------------------------------------------
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'

if ($OutputCsv) {
    $outFile = $OutputCsv
} else {
    $exportFolder = "C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\powershell-exports"
    $outFile = Join-Path -Path $exportFolder -ChildPath "TeamsByUserList-TeamDriven-$timestamp.csv"
}

$outFolder = Split-Path -Path $outFile -Parent
if ($outFolder -and -not (Test-Path -LiteralPath $outFolder)) {
    Write-Host "Output folder not found. Creating: $outFolder" -ForegroundColor Yellow
    New-Item -Path $outFolder -ItemType Directory -Force | Out-Null
}

$results | Export-Csv -Path $outFile -NoTypeInformation -Encoding UTF8

# ---- Timing summary ---------------------------------------------------------
$scriptEnd = Get-Date
$duration  = $scriptEnd - $scriptStart

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "SUMMARY (team-driven scan)" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "Input users (CSV)            : $($inputEmails.Count)" -ForegroundColor White
Write-Host "Input users resolved         : $($inputUserIdToUpn.Count)" -ForegroundColor White
Write-Host "Unresolved (skipped)         : $($missingUsers.Count)" -ForegroundColor White
Write-Host "Teams-enabled groups scanned : $($teams.Count)" -ForegroundColor White
Write-Host "Teams matching any input     : $($results.Count)" -ForegroundColor White
Write-Host "CSV file                     : $outFile" -ForegroundColor White
Write-Host "Script started               : $($scriptStart.ToString('yyyy-MM-dd HH:mm:ss'))" -ForegroundColor Magenta
Write-Host "Script ended                 : $($scriptEnd.ToString('yyyy-MM-dd HH:mm:ss'))"   -ForegroundColor Magenta
Write-Host "Total duration               : $($duration.ToString('hh\:mm\:ss'))"             -ForegroundColor Magenta

# Open the CSV for review
notepad $outFile

# Example Usage:
#   .\get-teams-from-user-list-team-driven.ps1
#   .\get-teams-from-user-list-team-driven.ps1 -CsvPath "C:\path\to\users.csv"
#   .\get-teams-from-user-list-team-driven.ps1 -CsvPath "$githubpath\powershell-private\working\team-audit-users.csv"
#   .\get-teams-from-user-list-team-driven.ps1 -CsvPath "C:\path\to\users.csv" -OutputCsv "C:\reports\team-driven-altronic.csv"
#   .\get-teams-from-user-list-team-driven.ps1 -CsvPath ".\users.csv"          -OutputCsv ".\altronic-audit.csv"

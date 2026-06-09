# Filename: get-teams-from-user-list-user-driven.ps1
# Revision : 1.1.0
# Description : Reads a CSV of users (column "Email") and exports every Microsoft Teams team
#               any of them are an Owner or Member of. Scans per-user (calls joinedTeams +
#               ownedObjects for each user, then fetches the roster only for matched teams).
#               Much faster than team-driven when user count << tenant team count.
#               Output is deduped to one row per team and includes the full owner/member
#               roster plus which input users matched. Prints start/end timestamps and
#               total duration for benchmarking against team-driven.
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-05-27
# Modified Date : 2026-05-27
# Changelog :
# 1.0.0 initial release (user-driven counterpart to get-teams-from-user-list-team-driven.ps1)
# 1.1.0 added -OutputCsv parameter to override default export path

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
foreach ($module in @("Microsoft.Graph.Authentication", "Microsoft.Graph.Users", "Microsoft.Graph.Groups", "Microsoft.Graph.Teams")) {
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
    Connect-MgGraph -Scopes "Group.Read.All","User.Read.All","Team.ReadBasic.All" -NoWelcome
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

# ---- Per-user scan: collect every team this user is in or owns --------------
Write-Host "`nScanning each user's joinedTeams + ownedObjects..." -ForegroundColor Cyan

# Map: TeamId -> [list of input-user ObjectIds that touched this team]
$teamIdToMatchedUserIds = @{}
$userIndex = 0
$totalUsers = $inputUserIdToUpn.Count

foreach ($entry in $inputUserIdToUpn.GetEnumerator()) {
    $userIndex++
    $userId  = $entry.Key
    $userUpn = $entry.Value
    Write-Progress -Activity "Scanning users" -Status "$userIndex of $totalUsers - $userUpn" `
        -PercentComplete ([int](($userIndex / [Math]::Max($totalUsers,1)) * 100))

    # Teams the user is a member of (Teams API → returns Team objects directly)
    try {
        $joined = Get-MgUserJoinedTeam -UserId $userId -All -ErrorAction Stop
    }
    catch {
        Write-Host "  Could not read joinedTeams for $userUpn : $($_.Exception.Message)" -ForegroundColor Yellow
        $joined = @()
    }

    foreach ($t in $joined) {
        if (-not $teamIdToMatchedUserIds.ContainsKey($t.Id)) {
            $teamIdToMatchedUserIds[$t.Id] = New-Object System.Collections.Generic.HashSet[string]
        }
        $null = $teamIdToMatchedUserIds[$t.Id].Add($userId)
    }

    # Groups the user owns → filter to Teams-enabled groups
    try {
        $owned = Get-MgUserOwnedObject -UserId $userId -All -ErrorAction Stop
    }
    catch {
        Write-Host "  Could not read ownedObjects for $userUpn : $($_.Exception.Message)" -ForegroundColor Yellow
        $owned = @()
    }

    foreach ($o in $owned) {
        $odataType = $o.AdditionalProperties['@odata.type']
        if ($odataType -ne '#microsoft.graph.group') { continue }
        $rpo = $o.AdditionalProperties['resourceProvisioningOptions']
        if (-not $rpo -or ($rpo -notcontains 'Team')) { continue }

        if (-not $teamIdToMatchedUserIds.ContainsKey($o.Id)) {
            $teamIdToMatchedUserIds[$o.Id] = New-Object System.Collections.Generic.HashSet[string]
        }
        $null = $teamIdToMatchedUserIds[$o.Id].Add($userId)
    }
}

Write-Progress -Activity "Scanning users" -Completed

if (-not $teamIdToMatchedUserIds.Count) {
    Write-Host "`nNo teams matched any user in the input CSV." -ForegroundColor Yellow
    $scriptEnd = Get-Date
    Write-Host "Script ended:   $($scriptEnd.ToString('yyyy-MM-dd HH:mm:ss'))" -ForegroundColor Magenta
    Write-Host "Total duration: $(($scriptEnd - $scriptStart).ToString('hh\:mm\:ss'))" -ForegroundColor Magenta
    return
}

Write-Host "Found $($teamIdToMatchedUserIds.Count) unique team(s) matched. Fetching full rosters..." -ForegroundColor Green

# ---- For each matched team: pull full owner + member roster (once) ----------
$results = New-Object System.Collections.Generic.List[object]
$teamIndex = 0
$totalTeams = $teamIdToMatchedUserIds.Count

foreach ($teamId in $teamIdToMatchedUserIds.Keys) {
    $teamIndex++

    try {
        $team    = Get-MgGroup -GroupId $teamId -Property Id,DisplayName,Mail,Visibility -ErrorAction Stop
        $owners  = Get-MgGroupOwner  -GroupId $teamId -All -ErrorAction Stop
        $members = Get-MgGroupMember -GroupId $teamId -All -ErrorAction Stop
    }
    catch {
        Write-Host "  Skipping team $teamId (failed to read details/roster): $($_.Exception.Message)" -ForegroundColor Yellow
        continue
    }

    Write-Progress -Activity "Fetching matched-team rosters" -Status "$teamIndex of $totalTeams - $($team.DisplayName)" `
        -PercentComplete ([int](($teamIndex / [Math]::Max($totalTeams,1)) * 100))

    $ownerUpns  = @($owners  | ForEach-Object { $_.AdditionalProperties.userPrincipalName } | Where-Object { $_ } | Sort-Object -Unique)
    $memberUpns = @($members | ForEach-Object { $_.AdditionalProperties.userPrincipalName } | Where-Object { $_ } | Sort-Object -Unique)
    $matchedUpns = @($teamIdToMatchedUserIds[$teamId] | ForEach-Object { $inputUserIdToUpn[$_] } | Sort-Object -Unique)

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

Write-Progress -Activity "Fetching matched-team rosters" -Completed

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
    $outFile = Join-Path -Path $exportFolder -ChildPath "TeamsByUserList-UserDriven-$timestamp.csv"
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
Write-Host "SUMMARY (user-driven scan)" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "Input users (CSV)            : $($inputEmails.Count)" -ForegroundColor White
Write-Host "Input users resolved         : $($inputUserIdToUpn.Count)" -ForegroundColor White
Write-Host "Unresolved (skipped)         : $($missingUsers.Count)" -ForegroundColor White
Write-Host "Unique teams matched         : $($results.Count)" -ForegroundColor White
Write-Host "CSV file                     : $outFile" -ForegroundColor White
Write-Host "Script started               : $($scriptStart.ToString('yyyy-MM-dd HH:mm:ss'))" -ForegroundColor Magenta
Write-Host "Script ended                 : $($scriptEnd.ToString('yyyy-MM-dd HH:mm:ss'))"   -ForegroundColor Magenta
Write-Host "Total duration               : $($duration.ToString('hh\:mm\:ss'))"             -ForegroundColor Magenta

# Open the CSV for review
notepad $outFile

# Example Usage:
#   .\get-teams-from-user-list-user-driven.ps1
#   .\get-teams-from-user-list-user-driven.ps1 -CsvPath "C:\path\to\users.csv"
#   .\get-teams-from-user-list-user-driven.ps1 -CsvPath "$githubpath\powershell-private\working\team-audit-users.csv"
#   .\get-teams-from-user-list-user-driven.ps1 -CsvPath "C:\path\to\users.csv" -OutputCsv "C:\reports\user-driven-altronic.csv"
#   .\get-teams-from-user-list-user-driven.ps1 -CsvPath ".\users.csv"          -OutputCsv ".\altronic-audit.csv"

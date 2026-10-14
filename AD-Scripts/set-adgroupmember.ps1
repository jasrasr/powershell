# Revision : 1.9
# Description : Prompt for an AD group, an action (Add/Remove), and one or more users, then add or remove them. Bad input re-prompts instead of ending the script, and you can make several changes in one run (PowerShell 7 compatible)
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-07-01
# Modified Date : 2026-10-14

# Search the domain the current user/computer is joined to
$defaultNC = ([ADSI]'LDAP://RootDSE').Properties['defaultNamingContext'][0]
$searchRoot = [ADSI]"LDAP://$defaultNC"

function Find-AdObject {
    param(
        [Parameter(Mandatory)][string]$Filter
    )
    $searcher = [System.DirectoryServices.DirectorySearcher]::new($searchRoot)
    try {
        $searcher.Filter = $Filter
        $searcher.SearchScope = 'Subtree'
        foreach ($p in 'distinguishedName', 'cn', 'sAMAccountName', 'memberOf') {
            [void]$searcher.PropertiesToLoad.Add($p)
        }
        $searcher.FindAll() | ForEach-Object { $_ }
    }
    finally {
        $searcher.Dispose()
    }
}

# Escape characters that are special in an LDAP filter
function ConvertTo-LdapFilterValue {
    param([string]$Value)
    $Value -replace '\\', '\5c' -replace '\*', '\2a' -replace '\(', '\28' -replace '\)', '\29'
}

# Show up to 10 near matches (by the text before the first - . _ or space) to help spot typos
function Show-Suggestion {
    param(
        [Parameter(Mandatory)][ValidateSet('group', 'user')][string]$Type,
        [Parameter(Mandatory)][string]$Text
    )
    $prefix = ($Text -split '[-._ ]')[0]
    if ($prefix.Length -lt 3) { $prefix = $Text }
    $p = ConvertTo-LdapFilterValue $prefix
    $typeFilter = if ($Type -eq 'group') { '(objectClass=group)' } else { '(objectCategory=person)(objectClass=user)' }
    $found = @(Find-AdObject "(&$typeFilter(|(sAMAccountName=*$p*)(cn=*$p*)))" | Select-Object -First 10)
    if ($found.Count -gt 0) {
        Write-Host "  Possible matches for '$prefix':"
        foreach ($f in $found) { Write-Host "    $($f.Properties['samaccountname'][0])" }
    }
}

# Returns a group search result, or $null if the user quits (blank entry)
function Get-GroupInteractive {
    while ($true) {
        $groupInput = (Read-Host 'Group name (sAMAccountName or CN, blank to quit)').Trim()
        if (-not $groupInput) { return $null }

        $g = ConvertTo-LdapFilterValue $groupInput
        $groupMatches = @(Find-AdObject "(&(objectClass=group)(|(sAMAccountName=$g)(cn=$g)))")

        if ($groupMatches.Count -eq 0) {
            Write-Host "Group not found in AD : $groupInput"
            Show-Suggestion -Type group -Text $groupInput
            continue
        }
        if ($groupMatches.Count -eq 1) { return $groupMatches[0] }

        Write-Host 'Multiple groups matched:'
        for ($i = 0; $i -lt $groupMatches.Count; $i++) {
            Write-Host ("  [{0}] {1}" -f ($i + 1), $groupMatches[$i].Properties['distinguishedname'][0])
        }
        $pick = Read-Host 'Enter the number of the group to use (blank to search again)'
        if ($pick -match '^\d+$' -and [int]$pick -ge 1 -and [int]$pick -le $groupMatches.Count) {
            return $groupMatches[[int]$pick - 1]
        }
        Write-Host 'Invalid selection.'
    }
}

function Get-ActionInteractive {
    while ($true) {
        switch -Regex ((Read-Host 'Action (Add / Remove)').Trim()) {
            '^(a|add)$'             { return 'Add' }
            '^(r|remove|d|delete)$' { return 'Remove' }
            default                 { Write-Host 'Action must be Add or Remove.' }
        }
    }
}

# Returns the user search results that were found. Names that are not found are
# offered back for correction; a blank correction skips that name.
function Get-UsersInteractive {
    $pending = @()
    while ($pending.Count -eq 0) {
        $userInput = Read-Host 'User sAMAccountName(s) (comma-separated for more than one)'
        $pending = @($userInput -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ })
        if ($pending.Count -eq 0) { Write-Host 'No users entered.' }
    }

    $resolved = [ordered]@{}
    while ($pending.Count -gt 0) {
        $retry = @()
        foreach ($name in $pending) {
            $u = ConvertTo-LdapFilterValue $name
            $result = Find-AdObject "(&(objectCategory=person)(objectClass=user)(sAMAccountName=$u))" | Select-Object -First 1
            if ($result) {
                $resolved[$result.Properties['distinguishedname'][0]] = $result
                continue
            }
            Write-Host "User not found in AD : $name"
            Show-Suggestion -Type user -Text $name
            $fix = Read-Host "Corrected name for '$name' (comma-separated, blank to skip)"
            $retry += @($fix -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ })
        }
        $pending = $retry
    }
    return @($resolved.Values)
}

# One group/action/users pass. Returns $false when the user quits at the group prompt.
function Invoke-GroupChange {
    $groupResult = Get-GroupInteractive
    if (-not $groupResult) { return $false }

    $groupDN = $groupResult.Properties['distinguishedname'][0]
    $groupCN = $groupResult.Properties['cn'][0]
    Write-Host "Group : $groupDN"

    $action = Get-ActionInteractive
    $users = @(Get-UsersInteractive)
    if ($users.Count -eq 0) {
        Write-Host 'No valid users to process. No changes made.'
        return $true
    }

    $names = $users | ForEach-Object { $_.Properties['samaccountname'][0] }
    $direction = if ($action -eq 'Add') { 'to' } else { 'from' }
    $confirm = Read-Host "$action $($names -join ', ') $direction '$groupCN'? (Y/N)"
    if ($confirm -notmatch '^(y|yes)$') {
        Write-Host 'Cancelled. No changes made.'
        return $true
    }

    $group = [ADSI]$groupResult.Path
    foreach ($user in $users) {
        $username = $user.Properties['samaccountname'][0]
        try {
            $isMember = @($user.Properties['memberof']) -contains $groupDN

            if ($action -eq 'Add') {
                if ($isMember) {
                    Write-Host "Already a member, skipped : $username in $groupCN"
                    continue
                }
                $group.Add($user.Path)
                Write-Host "Added $username to group : $groupCN"
            }
            else {
                if (-not $isMember) {
                    Write-Host "Not a member, skipped : $username in $groupCN"
                    continue
                }
                $group.Remove($user.Path)
                Write-Host "Removed $username from group : $groupCN"
            }
        }
        catch {
            Write-Host "Failed to $($action.ToLower()) $username ($groupCN) : $_"
        }
    }
    return $true
}

while ($true) {
    if (-not (Invoke-GroupChange)) { break }
    $again = Read-Host 'Make another change? (Y/N)'
    if ($again -notmatch '^(y|yes)$') { break }
}

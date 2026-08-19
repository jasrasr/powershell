<#
Ensures every user in the Altronic Local-Admins OU is a member of the ALTSG_LocalAdmins security group.
Requires: ActiveDirectory module, run with an account that has rights to read the OU and modify the group.
#>

param(
    [string]$OUPath = "OU=Local-Admins,OU=Altronic,OU=AADSyncedUsers,OU=CooperServices,DC=cooperservices,DC=com",
    [string]$GroupName = "ALTSG_LocalAdmins",
    [switch]$WhatIf
)

Import-Module ActiveDirectory -ErrorAction Stop

# Get all user accounts in the target OU
try {
    $ouUsers = Get-ADUser -SearchBase $OUPath -Filter * -ErrorAction Stop | Select-Object -ExpandProperty SamAccountName
} catch {
    Write-Host "Failed to query OU '$OUPath': $_" -ForegroundColor Red
    return
}

if (-not $ouUsers) {
    Write-Host "No users found in OU '$OUPath'." -ForegroundColor Yellow
    return
}

Write-Host "Found $($ouUsers.Count) user(s) in OU '$OUPath':" -ForegroundColor Cyan
$ouUsers | ForEach-Object { Write-Host "  $_" }

# Get current members of the target group
try {
    $currentMembers = Get-ADGroupMember -Identity $GroupName -ErrorAction Stop | Select-Object -ExpandProperty SamAccountName
} catch {
    Write-Host "Failed to query group '$GroupName': $_" -ForegroundColor Red
    return
}

$missing = $ouUsers | Where-Object { $_ -notin $currentMembers }

if (-not $missing) {
    Write-Host "All OU users are already members of '$GroupName'. Nothing to do." -ForegroundColor Green
    return
}

Write-Host "$($missing.Count) user(s) missing from '$GroupName':" -ForegroundColor Yellow
$missing | ForEach-Object { Write-Host "  $_" }

foreach ($sam in $missing) {
    try {
        if ($WhatIf) {
            Write-Host "WhatIf: would add $sam to $GroupName" -ForegroundColor DarkYellow
        } else {
            Add-ADGroupMember -Identity $GroupName -Members $sam -ErrorAction Stop
            Write-Host "Added $sam to $GroupName." -ForegroundColor Green
        }
    } catch {
        Write-Host "Failed to add $sam to $GroupName`: $_" -ForegroundColor Red
    }
}

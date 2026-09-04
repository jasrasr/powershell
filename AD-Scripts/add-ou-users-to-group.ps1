# Revision : 1.0
# Description : Add all users in a target OU to a target AD group, with WhatIf simulation and live-mode confirmation
# Author : Jason Lamb (with help from Claude)
# Created Date : 2026-09-03
# Modified Date : 2026-09-03

# prompts for WhatIf (evaluation) before making any changes
# accepts yes, YES, y, Y for whatif run
# requires YES for confirmation of live run

param(
    [string]$OuDn = 'OU=Local-Admins,OU=Altronic,OU=AADSyncedUsers,OU=CooperServices,DC=cooperservices,DC=com',
    [string]$GroupName = 'ALTSG_LocalAdmins'
)

Import-Module ActiveDirectory

# ===== VALIDATE TARGET GROUP =====
try {
    $group = Get-ADGroup -Identity $GroupName -ErrorAction Stop
}
catch {
    Write-Host "Group '$GroupName' could not be found. Exiting."
    return
}

# ===== VALIDATE TARGET OU =====
try {
    $users = Get-ADUser -Filter * -SearchBase $OuDn -ErrorAction Stop
}
catch {
    Write-Host "OU '$OuDn' could not be found. Exiting."
    return
}

if (-not $users) {
    Write-Host "No users found in OU : $OuDn"
    return
}

# ===== WHATIF CONFIRMATION =====
Write-Host ""
Write-Host "Run in WHATIF (simulation) mode?"
Write-Host "Type YES or Y to simulate (safe)"
Write-Host "Type anything else to attempt LIVE mode"
Write-Host ""

$whatIfInput = (Read-Host "WhatIf").Trim().ToUpper()
$WhatIfMode = $whatIfInput -in @("YES", "Y")

# ===== HARD STOP FOR LIVE MODE =====
if (-not $WhatIfMode) {

    Write-Host ""
    Write-Host "WARNING : LIVE MODE"
    Write-Host "This will ADD ALL USERS in the OU to the group"
    Write-Host "Target OU    : $OuDn"
    Write-Host "Target Group : $($group.Name)"
    Write-Host "User count   : $($users.Count)"
    Write-Host ""
    Write-Host "Type YES to continue or anything else to abort"

    $confirm = (Read-Host "Confirmation").Trim().ToUpper()

    if ($confirm -ne "YES") {
        Write-Host "Aborted by user"
        return
    }
}

# ===== LOG FOLDER CHECK =====
$logFolder = "C:\temp\powershell-exports"

if (-not (Test-Path $logFolder)) {
    Write-Host "Creating log folder $logFolder"
    New-Item -Path $logFolder -ItemType Directory -Force | Out-Null
}

$datetime  = Get-Date -Format "yyyyMMdd-HHmmss"
$modeLabel = if ($WhatIfMode) { "SIMULATION" } else { "LIVE" }
$logFile   = "$logFolder\ad-group-add-$modeLabel-$datetime.log"

# ===== RUN HEADER =====
Write-Host ""
Write-Host "Execution mode : $modeLabel"
Write-Host "Target OU    : $OuDn"
Write-Host "Target Group : $($group.Name)"
Write-Host "Log file     : $logFile"
Write-Host "---------------------------------------------"

Add-Content -Path $logFile -Value "Mode : $modeLabel"
Add-Content -Path $logFile -Value "OU : $OuDn"
Add-Content -Path $logFile -Value "Group : $($group.Name)"
Add-Content -Path $logFile -Value "Start Time : $(Get-Date)"
Add-Content -Path $logFile -Value "---------------------------------------------"

# ===== EXECUTION =====
$existingMembers = Get-ADGroupMember -Identity $group.DistinguishedName -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty DistinguishedName

foreach ($user in $users) {

    if ($existingMembers -contains $user.DistinguishedName) {
        $msg = "  Already a member : $($user.SamAccountName)"
        Write-Host $msg
        Add-Content -Path $logFile -Value $msg
        continue
    }

    if ($WhatIfMode) {

        $msg = "SIMULATION add $($user.SamAccountName) to $($group.Name)"
        Write-Host $msg
        Add-Content -Path $logFile -Value $msg

        Add-ADGroupMember `
            -Identity $group.DistinguishedName `
            -Members $user.DistinguishedName `
            -Confirm:$false `
            -WhatIf
    }
    else {

        try {
            Add-ADGroupMember `
                -Identity $group.DistinguishedName `
                -Members $user.DistinguishedName `
                -Confirm:$false `
                -ErrorAction Stop

            $msg = "ADDED $($user.SamAccountName) to $($group.Name)"
            Write-Host $msg
            Add-Content -Path $logFile -Value $msg
        }
        catch {
            $msg = "FAILED to add $($user.SamAccountName) : $($_.Exception.Message)"
            Write-Host $msg -ForegroundColor Red
            Add-Content -Path $logFile -Value $msg
        }
    }
}

Add-Content -Path $logFile -Value "---------------------------------------------"
Add-Content -Path $logFile -Value "End Time : $(Get-Date)"

Write-Host ""
Write-Host "Completed $modeLabel run"
Write-Host "Log saved to $logFile"

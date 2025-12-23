# Revision : 1.3
# Description : Enumerate all groups in an OU and remove members with mandatory OU input, safety confirmation, and log path validation (Rev 1.3)
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-12-23
# Modified Date : 2025-12-23

# prompts for OU and also if whatif (evaluation) should be used

param (
    [string]$OuDn
)

Import-Module ActiveDirectory

# ===== PROMPT FOR OU IF NOT PROVIDED =====
if (-not $OuDn) {
    Write-Host "Enter the Distinguished Name (DN) of the target OU"
    $OuDn = Read-Host "OU DN"
}

# ===== CONFIRM MODE =====
Write-Host ""
Write-Host "Choose execution mode"
Write-Host "Type SIMULATE to run with -WhatIf"
Write-Host "Type REMOVE to actually remove members"
Write-Host ""

$modeInput = Read-Host "Mode"

if ($modeInput -notin @("SIMULATE","REMOVE")) {
    Write-Host "Invalid mode. Exiting."
    return
}

$WhatIfMode = $modeInput -eq "SIMULATE"

# ===== HARD STOP CONFIRMATION FOR LIVE RUN =====
if (-not $WhatIfMode) {
    Write-Host ""
    Write-Host "WARNING : This will REMOVE ALL MEMBERS from ALL GROUPS in the OU"
    Write-Host "OU : $OuDn"
    Write-Host ""
    Write-Host "Type YES to continue or anything else to abort"

    $confirm = Read-Host "Confirmation"

    if ($confirm -ne "YES") {
        Write-Host "Aborted by user"
        return
    }
}

# ===== LOGGING =====
$datetime = Get-Date -Format "yyyyMMdd-HHmmss"
$modeLabel = if ($WhatIfMode) { "SIMULATION" } else { "LIVE" }

$logFolder = "C:\temp\powershell-exports"

if (-not (Test-Path $logFolder)) {
    Write-Host "Creating log folder $logFolder"
    New-Item -Path $logFolder -ItemType Directory -Force | Out-Null
}

$logFile = "$logFolder\ad-group-member-removal-$modeLabel-$datetime.log"

Write-Host ""
Write-Host "Mode $modeLabel"
Write-Host "Target OU $OuDn"
Write-Host "Log file $logFile"
Write-Host "---------------------------------------------"

# ===== EXECUTION =====
$groups = Get-ADGroup -Filter * -SearchBase $OuDn

foreach ($group in $groups) {

    Write-Host "Group $($group.Name)"

    $members = Get-ADGroupMember -Identity $group.DistinguishedName -ErrorAction SilentlyContinue

    if (-not $members) {
        Write-Host "  No members"
        continue
    }

    foreach ($member in $members) {

        if ($WhatIfMode) {
            $msg = "SIMULATION remove $($member.SamAccountName) from $($group.Name)"
            Write-Host $msg
            Add-Content -Path $logFile -Value $msg

            Remove-ADGroupMember `
                -Identity $group.DistinguishedName `
                -Members $member.DistinguishedName `
                -Confirm:$false `
                -WhatIf
        }
        else {
            $msg = "REMOVED $($member.SamAccountName) from $($group.Name)"
            Write-Host $msg
            Add-Content -Path $logFile -Value $msg

            Remove-ADGroupMember `
                -Identity $group.DistinguishedName `
                -Members $member.DistinguishedName `
                -Confirm:$false
        }
    }
}

Write-Host ""
Write-Host "Completed $modeLabel run"
Write-Host "Log saved to $logFile"

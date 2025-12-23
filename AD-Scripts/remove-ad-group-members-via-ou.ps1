# Revision : 1.6
# Description : Enumerate all groups in an OU and remove members with mandatory OU prompt, YES/Y WhatIf confirmation, strict live-mode confirmation, and log path validation (Rev 1.6)
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-12-23
# Modified Date : 2025-12-23

# prompts for OU and also if whatif (evaluation) should be used
# accepts yes, YES, y, Y for whatif run
# requires YES for confirmation of live run

Import-Module ActiveDirectory

# ===== PROMPT FOR OU =====
Write-Host "Enter the Distinguished Name (DN) of the target OU"
$OuDn = Read-Host "OU DN"

if (-not $OuDn) {
    Write-Host "OU DN is required. Exiting."
    return
}

# ===== WHATIF CONFIRMATION =====
Write-Host ""
Write-Host "Run in WHATIF (simulation) mode?"
Write-Host "Type YES or Y to simulate (safe)"
Write-Host "Type anything else to attempt LIVE mode"
Write-Host ""

$whatIfInput = (Read-Host "WhatIf").Trim().ToUpper()
$WhatIfMode = $whatIfInput -in @("YES","Y")

# ===== HARD STOP FOR LIVE MODE =====
if (-not $WhatIfMode) {

    Write-Host ""
    Write-Host "WARNING : LIVE MODE"
    Write-Host "This will REMOVE ALL MEMBERS from ALL GROUPS in the OU"
    Write-Host "Target OU : $OuDn"
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
$logFile   = "$logFolder\ad-group-member-removal-$modeLabel-$datetime.log"

# ===== RUN HEADER =====
Write-Host ""
Write-Host "Execution mode : $modeLabel"
Write-Host "Target OU : $OuDn"
Write-Host "Log file : $logFile"
Write-Host "---------------------------------------------"

Add-Content -Path $logFile -Value "Mode : $modeLabel"
Add-Content -Path $logFile -Value "OU : $OuDn"
Add-Content -Path $logFile -Value "Start Time : $(Get-Date)"
Add-Content -Path $logFile -Value "---------------------------------------------"

# ===== EXECUTION =====
$groups = Get-ADGroup -Filter * -SearchBase $OuDn

foreach ($group in $groups) {

    Write-Host "Group $($group.Name)"
    Add-Content -Path $logFile -Value "Group $($group.Name)"

    $members = Get-ADGroupMember -Identity $group.DistinguishedName -ErrorAction SilentlyContinue

    if (-not $members) {
        Write-Host "  No members"
        Add-Content -Path $logFile -Value "  No members"
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

Add-Content -Path $logFile -Value "---------------------------------------------"
Add-Content -Path $logFile -Value "End Time : $(Get-Date)"

Write-Host ""
Write-Host "Completed $modeLabel run"
Write-Host "Log saved to $logFile"


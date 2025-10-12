# Revision : 1.6
# Description : Remotely rename one or more computers on the domain using a hashtable of OldName=NewName pairs,
#               prompts for password, does not force reboot, includes reachability pre-checks and AD post-check
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-10-01
# Modified Date : 2025-10-01

# passes credential and prompts for password
# this does NOT force a reboot, a reboot is required for full name change
# computer has to be on corporate network or vpn for script to work and contact computer

# --- Hashtable of computers to rename (OldName=NewName) ---
$Computers = @{
    'oldname1' = 'newname1'
    'oldname2' = 'newname2'
    # Add more pairs here...
}

$cred = Get-Credential 'domain\admin.username'

function Try-ImportADModule {
    try {
        Import-Module ActiveDirectory -UseWindowsPowerShell -ErrorAction Stop
        return $true
    } catch {
        try {
            Import-Module ActiveDirectory -ErrorAction Stop
            return $true
        } catch {
            return $false
        }
    }
}

foreach ($pair in $Computers.GetEnumerator()) {
    $Target  = $pair.Key
    $NewName = $pair.Value

    Write-Host "`n===== Processing $Target → $NewName =====" -ForegroundColor Cyan

    # --- Reachability pre-checks ---
    try {
        $null = Resolve-DnsName -Name $Target -ErrorAction Stop
    } catch {
        Write-Host "DNS lookup failed for $Target : $($_.Exception.Message)" -ForegroundColor Red
        continue
    }

    $rpcOK  = Test-NetConnection -ComputerName $Target -Port 135 -InformationLevel Quiet
    $icmpOK = $false
    try { $icmpOK = Test-Connection -ComputerName $Target -Count 1 -Quiet } catch { $icmpOK = $false }

    if (-not $rpcOK) {
        Write-Host "RPC port 135 not reachable on $Target : aborting rename" -ForegroundColor Red
        continue
    }

    if (-not $icmpOK) {
        Write-Host "Ping blocked or failed for $Target : continuing because RPC 135 is reachable"
    } else {
        Write-Host "Connectivity check passed for $Target : DNS/RPC (and ping) look good"
    }

    # --- Rename attempt ---
    $renameSucceeded = $false
    try {
        Rename-Computer -ComputerName $Target -NewName $NewName -DomainCredential $cred -Force -ErrorAction Stop
        $renameSucceeded = $true
        Write-Host "SUCCESS : $Target queued for rename to $NewName (reboot required to apply)" -ForegroundColor Green
    } catch {
        Write-Host "ERROR : Failed to rename $Target to $NewName : $($_.Exception.Message)" -ForegroundColor Red
        continue
    }

    # --- Post-check in Active Directory ---
    if ($renameSucceeded) {
        if (Try-ImportADModule) {
            try {
                $adNew = Get-ADComputer -Identity $NewName -ErrorAction SilentlyContinue
                $adOld = Get-ADComputer -Identity $Target  -ErrorAction SilentlyContinue

                if ($adNew -and -not $adOld) {
                    Write-Host "AD status : Found computer object $NewName and old name $Target not found" -ForegroundColor Green
                } elseif ($adNew -and $adOld) {
                    Write-Host "AD status : Both $NewName and $Target exist (replication delay or rename pending reboot)" -ForegroundColor Yellow
                } elseif (-not $adNew -and $adOld) {
                    Write-Host "AD status : Old object $Target still present and $NewName not found (await reboot/replication)" -ForegroundColor Yellow
                } else {
                    Write-Host "AD status : Neither $NewName nor $Target found (check OU, permissions, or replication)" -ForegroundColor Yellow
                }
            } catch {
                Write-Host "AD query error : $($_.Exception.Message)" -ForegroundColor Yellow
            }
        } else {
            Write-Host "Note : ActiveDirectory module not available. Skipping AD post-check." -ForegroundColor Yellow
        }

        Write-Host "Reminder : $Target must be rebooted for $NewName to apply" -ForegroundColor Cyan
    }
}

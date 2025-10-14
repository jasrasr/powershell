# Revision : 1.7
# Description : Remotely rename one or more computers using OldName=NewName hashtable.
#               Prompts for password, no forced reboot. Pre-checks DNS/RPC, tries standard rename,
#               and on WinRM/Kerberos errors falls back to DCOM/WMI (Invoke-CimMethod).
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-10-01
# Modified Date : 2025-10-13

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
    try { Import-Module ActiveDirectory -UseWindowsPowerShell -ErrorAction Stop; return $true } catch {
        try { Import-Module ActiveDirectory -ErrorAction Stop; return $true } catch { return $false }
    }
}

foreach ($pair in $Computers.GetEnumerator()) {
    $Target  = $pair.Key
    $NewName = $pair.Value

    Write-Host "`n===== Processing $Target → $NewName =====" -ForegroundColor Cyan

    # --- Reachability pre-checks ---
    try { $null = Resolve-DnsName -Name $Target -ErrorAction Stop }
    catch { Write-Host "DNS lookup failed for $Target : $($_.Exception.Message)" -ForegroundColor Red; continue }

    # RPC 135 is key for remote ops; ping is optional
    $rpcOK  = Test-NetConnection -ComputerName $Target -Port 135 -InformationLevel Quiet
    $icmpOK = $false; try { $icmpOK = Test-Connection -ComputerName $Target -Count 1 -Quiet } catch {}

    if (-not $rpcOK) { Write-Host "RPC port 135 not reachable on $Target : aborting rename" -ForegroundColor Red; continue }
    if (-not $icmpOK) { Write-Host "Ping blocked or failed for $Target : continuing because RPC 135 is reachable" }
    else { Write-Host "Connectivity check passed for $Target : DNS/RPC (and ping) look good" }

    # --- Primary attempt (Rename-Computer remote) ---
    $renameSucceeded = $false
    try {
        Rename-Computer -ComputerName $Target -NewName $NewName -DomainCredential $cred -Force -ErrorAction Stop
        $renameSucceeded = $true
        Write-Host "SUCCESS : $Target queued for rename to $NewName (reboot required to apply)" -ForegroundColor Green
    } catch {
        $msg = $_.Exception.Message
        Write-Host "ERROR : Rename-Computer failed on $Target : $msg" -ForegroundColor Yellow

        # Heuristics: if it's a WinRM/Kerberos issue (0x80090311 or 'Kerberos'/'WinRM' mentioned), fall back to DCOM/WMI
        if ($msg -match '0x80090311|Kerberos|WinRM') {
            Write-Host "Fallback : Attempting DCOM/WMI rename via CIM (no WinRM/Kerberos)" -ForegroundColor Cyan
            try {
                $opt = New-CimSessionOption -Protocol Dcom
                $cim = New-CimSession -ComputerName $Target -Credential $cred -SessionOption $opt -ErrorAction Stop
                $args = @{
                    Name     = $NewName
                    UserName = $cred.UserName           # domain\user for AD rename
                    Password = $cred.GetNetworkCredential().Password
                }
                $null = Invoke-CimMethod -CimSession $cim -ClassName Win32_ComputerSystem -MethodName Rename -Arguments $args -ErrorAction Stop
                $renameSucceeded = $true
                Write-Host "SUCCESS : DCOM/WMI queued rename of $Target → $NewName (reboot required to apply)" -ForegroundColor Green
            } catch {
                Write-Host "ERROR : DCOM/WMI fallback failed on $Target : $($_.Exception.Message)" -ForegroundColor Red
            } finally { if ($cim) { $cim | Remove-CimSession -ErrorAction SilentlyContinue } }
        } else {
            Write-Host "Hint : If this isn’t WinRM/Kerberos, check local admin rights, dynamic RPC ports, and firewalls."
        }
    }

    # --- AD post-check (if rename queued) ---
    if ($renameSucceeded) {
        if (Try-ImportADModule) {
            try {
                $adNew = Get-ADComputer -Identity $NewName -ErrorAction SilentlyContinue
                $adOld = Get-ADComputer -Identity $Target  -ErrorAction SilentlyContinue
                if     ($adNew -and -not $adOld) { Write-Host "AD status : Found $NewName and old name $Target not found" -ForegroundColor Green }
                elseif ($adNew -and  $adOld)     { Write-Host "AD status : Both $NewName and $Target exist (replication delay or pending reboot)" -ForegroundColor Yellow }
                elseif (-not $adNew -and $adOld) { Write-Host "AD status : Old object $Target still present and $NewName not found (await reboot/replication)" -ForegroundColor Yellow }
                else                              { Write-Host "AD status : Neither $NewName nor $Target found (check OU/permissions/replication)" -ForegroundColor Yellow }
            } catch { Write-Host "AD query error : $($_.Exception.Message)" -ForegroundColor Yellow }
        } else {
            Write-Host "Note : ActiveDirectory module not available. Skipping AD post-check." -ForegroundColor Yellow
        }
        Write-Host "Reminder : $Target must be rebooted for $NewName to apply" -ForegroundColor Cyan
    }
}

<# ---------------------------
USAGE EXAMPLES (commented out)
. .\Rename-RemoteComputers.ps1   # dot-source if you split into a function file later

# Example 1: simple run
# (Set your $Computers table above and run the script.)

# Example 2: fully dynamic hashtable
# $Computers = @{
#   'CLEW10AAAAA1' = 'CLEAAAAA1'
#   'TOLW10BBBBB2' = 'TOLBBBBB2'
# }
# Then run the script.

# Example 3: with FQDN if SPN/DNS weirdness
# $Computers = @{ 'CLEW10AAAAA1.middough.local' = 'CLEAAAAA1' }
# Note: NewName should be short host portion, not FQDN.

# --------------------------- #>

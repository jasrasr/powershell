# Revision : 1.3
# Description : Prompts for old and new computer names, domain admin username, and password to rename a remote computer (no reboot)
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-10-20
# Modified Date : 2025-10-20

# prompts for domain, then admin user, then password, then old name, then new name
# this does not rename the AD object, it only renames the computer by invoking the script
# this does NOT force a reboot, a reboot is required for full name change
# computer has to be on corporate network or vpn for script to work and contact computer

# Prompt for details
$domain = Read-Host "Enter the domain name (example : domain)"
$username = Read-Host "Enter the admin username (example : adm.username)"
$cred = Get-Credential -UserName "$domain\$username" -Message "Enter password for $domain\$username"
$oldName = Read-Host "Enter the current (old) computer name"
$newName = Read-Host "Enter the new computer name"

try {
    Write-Host "Renaming $oldName to $newName..." -ForegroundColor Cyan
    Rename-Computer -ComputerName $oldName -NewName $newName -DomainCredential $cred -Force -ErrorAction Stop
    Write-Host "Rename command executed successfully on $oldName." -ForegroundColor Green

    # Optional verification (WinRM must be enabled)
    Start-Sleep -Seconds 5
    try {
        $check = Invoke-Command -ComputerName $newName -Credential $cred -ScriptBlock { $env:COMPUTERNAME } -ErrorAction Stop
        if ($check -eq $newName.ToUpper()) {
            Write-Host "Verification successful : computer name is now $check" -ForegroundColor Green
        }
        else {
            Write-Host "Verification warning : could not confirm name change yet (reboot likely required)" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "Verification failed : $($_.Exception.Message)" -ForegroundColor Yellow
        Write-Host "This may be expected if the computer has not yet rebooted."
    }
}
catch {
    Write-Host "Error renaming $oldName : $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "A reboot is required for the rename to take full effect." -ForegroundColor Yellow
Write-Host "Old name : $oldName"
Write-Host "New name : $newName"
Write-Host "Renamed using account : $domain\$username"

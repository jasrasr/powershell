# Revision : 1.0
# Description : Check if a list of computer names exists in Active Directory
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-08-15
# Modified Date : 2025-08-15

# --- Import AD Module ---
try {
    Import-Module ActiveDirectory -ErrorAction Stop
} catch {
    Import-Module ActiveDirectory -UseWindowsPowerShell -ErrorAction Stop
}

# --- Input List ---
$ComputerList = @(
   'ComputerName1',
   'ComputerName2'
    )

# --- Output ---
foreach ($ComputerName in $ComputerList) {
    try {
        Get-ADComputer -Identity $ComputerName -ErrorAction Stop
        Write-Host "$ComputerName : Exists in AD" -ForegroundColor Green
    } catch {
        Write-Host "$ComputerName : NOT found in AD" -ForegroundColor Red
    }
}

# Filename: Reset-ADUserPassword.ps1
# Revision : 1.0.0
# Description : Resets the password for a single Active Directory user
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-05-11
# Modified Date : 2026-05-11
# Changelog :
# 1.0.0 initial release

[CmdletBinding()]
param (
    [Parameter()]
    [string]$SamAccountName,

    [Parameter()]
    [switch]$MustChangePasswordAtLogon
)

# ── Module check ────────────────────────────────────────────────────────────────
foreach ($module in @("ActiveDirectory")) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Host "Installing $module..." -ForegroundColor Cyan
        Install-Module $module -Scope CurrentUser -Force
    }
    if (-not (Get-Module -Name $module)) {
        Write-Host "Importing $module..." -ForegroundColor Cyan
        Import-Module $module
    }
}

# ── Get target user ─────────────────────────────────────────────────────────────
if (-not $SamAccountName) {
    $SamAccountName = Read-Host "Enter the SamAccountName of the user"
}

try {
    $user = Get-ADUser -Identity $SamAccountName -Properties DisplayName, Enabled, PasswordLastSet, LockedOut -ErrorAction Stop
} catch {
    Write-Host "User '$SamAccountName' not found in Active Directory." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "User found:" -ForegroundColor Cyan
Write-Host "  Display Name       : $($user.DisplayName)"
Write-Host "  SamAccountName     : $($user.SamAccountName)"
Write-Host "  Enabled            : $($user.Enabled)"
Write-Host "  Password Last Set  : $($user.PasswordLastSet)"
Write-Host "  Locked Out         : $($user.LockedOut)"
Write-Host ""

# ── Get new password ─────────────────────────────────────────────────────────────
$newPassword = Read-Host "Enter new password for $($user.DisplayName)" -AsSecureString
$confirm     = Read-Host "Confirm new password" -AsSecureString

$plain1 = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($newPassword))
$plain2 = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($confirm))

if ($plain1 -ne $plain2) {
    Write-Host "Passwords do not match. Aborting." -ForegroundColor Red
    exit 1
}
$plain1 = $plain2 = $null

# ── Reset password ───────────────────────────────────────────────────────────────
try {
    Set-ADAccountPassword -Identity $user.SamAccountName -NewPassword $newPassword -Reset -ErrorAction Stop
    Write-Host "Password reset successfully for $($user.DisplayName)." -ForegroundColor Green
} catch {
    Write-Host "Failed to reset password: $_" -ForegroundColor Red
    exit 1
}

# ── Prompt: must change at next logon ────────────────────────────────────────────
if ($MustChangePasswordAtLogon) {
    $forceChange = $true
} else {
    $response = Read-Host "Require user to change password at next logon? (Y/N)"
    $forceChange = $response -match '^[Yy]'
}

if ($forceChange) {
    try {
        Set-ADUser -Identity $user.SamAccountName -ChangePasswordAtLogon $true -ErrorAction Stop
        Write-Host "User will be required to change password at next logon." -ForegroundColor Yellow
    } catch {
        Write-Host "Warning: Could not set ChangePasswordAtLogon: $_" -ForegroundColor Yellow
    }
}

# ── Unlock account if locked ─────────────────────────────────────────────────────
if ($user.LockedOut) {
    try {
        Unlock-ADAccount -Identity $user.SamAccountName -ErrorAction Stop
        Write-Host "Account was locked — it has been unlocked." -ForegroundColor Yellow
    } catch {
        Write-Host "Warning: Could not unlock account: $_" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Done." -ForegroundColor Green

# Example Usage:
#   .\Reset-ADUserPassword.ps1
#   .\Reset-ADUserPassword.ps1 -SamAccountName "jdoe"
#   .\Reset-ADUserPassword.ps1 -SamAccountName "jdoe" -MustChangePasswordAtLogon

<#
Lets a user change the password on their own admin.* account. Uses a real
password-change operation (requires the current password) so AD clears the
"must change password at next logon" flag correctly -- same effect as
changing it via an interactive logon, without needing RDP/console access.
Does not require the ActiveDirectory PowerShell module or any elevated rights.
#>
[CmdletBinding()]
param(
    [string]$SamAccountName,
    [string]$Domain = 'cooperservices.com'
)

Add-Type -AssemblyName System.DirectoryServices.AccountManagement

if (-not $SamAccountName) {
    $SamAccountName = Read-Host -Prompt 'Admin account username (e.g. admin.jdoe)'
}

$currentPassword = Read-Host -Prompt 'Current password' -AsSecureString

function ConvertFrom-SecureStringPlain {
    param([SecureString]$Secure)
    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($Secure)
    try {
        [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
    } finally {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
    }
}

function Test-PasswordMeetsCriteria {
    param([string]$Password)
    $Password.Length -ge 12 -and
        $Password -cmatch '[A-Z]' -and
        $Password -cmatch '[a-z]' -and
        $Password -match '[0-9]' -and
        $Password -match '[^a-zA-Z0-9]'
}

Write-Host 'New password must be at least 12 characters and include at least 1 uppercase letter, 1 lowercase letter, 1 number, and 1 symbol.'

do {
    $newPassword = Read-Host -Prompt 'New password' -AsSecureString
    $confirmPassword = Read-Host -Prompt 'Confirm new password' -AsSecureString

    $newPlain = ConvertFrom-SecureStringPlain $newPassword
    $confirmPlain = ConvertFrom-SecureStringPlain $confirmPassword

    if ($newPlain -ne $confirmPlain) {
        Write-Warning 'New password and confirmation do not match. Try again.'
        continue
    }
    if (-not (Test-PasswordMeetsCriteria $newPlain)) {
        Write-Warning 'New password does not meet the criteria above. Try again.'
        continue
    }
    break
} while ($true)

$currentPlain = ConvertFrom-SecureStringPlain $currentPassword

$context = New-Object System.DirectoryServices.AccountManagement.PrincipalContext(
    [System.DirectoryServices.AccountManagement.ContextType]::Domain, $Domain)

try {
    $user = [System.DirectoryServices.AccountManagement.UserPrincipal]::FindByIdentity($context, $SamAccountName)

    if (-not $user) {
        Write-Error "No account found for '$SamAccountName' in $Domain."
        return
    }

    $user.ChangePassword($currentPlain, $newPlain)
    Write-Host "Password changed successfully for $SamAccountName." -ForegroundColor Green
} catch [System.DirectoryServices.AccountManagement.PasswordException] {
    Write-Error "Password rejected: $($_.Exception.InnerException.Message)"
} catch {
    Write-Error "Password change failed: $($_.Exception.Message)"
} finally {
    $currentPlain = $null
    $newPlain = $null
    $confirmPlain = $null
    $context.Dispose()
}

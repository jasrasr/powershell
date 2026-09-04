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

function Open-Url {
    param([string]$Url)
    try {
        if ($IsLinux) {
            Start-Process 'xdg-open' $Url | Out-Null
        } elseif ($IsMacOS) {
            Start-Process 'open' $Url | Out-Null
        } else {
            Start-Process $Url | Out-Null
        }
    } catch {
        Write-Warning "Could not open the browser automatically: $($_.Exception.Message)"
    }
}

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

function Read-NewPassword {
    param([int]$MaxAttempts = 5)

    for ($attempt = 1; $attempt -le $MaxAttempts; $attempt++) {
        $newPassword = Read-Host -Prompt 'New password (blank to cancel)' -AsSecureString
        $newPlain = ConvertFrom-SecureStringPlain $newPassword
        if ([string]::IsNullOrEmpty($newPlain)) { return $null }

        $confirmPassword = Read-Host -Prompt 'Confirm new password' -AsSecureString
        $confirmPlain = ConvertFrom-SecureStringPlain $confirmPassword

        if ($newPlain -ne $confirmPlain) {
            Write-Warning 'New password and confirmation do not match. Try again.'
            continue
        }
        if (-not (Test-PasswordMeetsCriteria $newPlain)) {
            Write-Warning 'New password does not meet the criteria above. Try again.'
            continue
        }
        return $newPlain
    }

    Write-Warning "Too many failed attempts ($MaxAttempts). Exiting without changing the password."
    Write-Host 'Opening a password generator so you can try again: https://jasr.me/pw' -ForegroundColor Red
    Open-Url 'https://jasr.me/pw'
    return $null
}

$context = New-Object System.DirectoryServices.AccountManagement.PrincipalContext(
    [System.DirectoryServices.AccountManagement.ContextType]::Domain, $Domain)

try {
    $user = $null
    while (-not $user) {
        if (-not $SamAccountName) {
            $SamAccountName = Read-Host -Prompt 'Admin account username (blank to cancel)'
            if (-not $SamAccountName) {
                Write-Host 'Cancelled. Password was not changed.' -ForegroundColor Red
                return
            }
        }

        $user = [System.DirectoryServices.AccountManagement.UserPrincipal]::FindByIdentity($context, $SamAccountName)

        if (-not $user) {
            Write-Warning "No account found for '$SamAccountName' in $Domain. Check for typos, or it may be a newly created account still replicating."
            $SamAccountName = $null
        }
    }

    Write-Host 'New password must be at least 12 characters and include at least 1 uppercase letter, 1 lowercase letter, 1 number, and 1 symbol.'

    $maxCurrentAttempts = 5
    $changed = $false
    $cancelled = $false

    :currentLoop for ($currentAttempt = 1; $currentAttempt -le $maxCurrentAttempts; $currentAttempt++) {
        $currentPassword = Read-Host -Prompt 'Current password' -AsSecureString
        $currentPlain = ConvertFrom-SecureStringPlain $currentPassword

        while ($true) {
            $newPlain = Read-NewPassword
            if (-not $newPlain) {
                Write-Host 'Cancelled. Password was not changed.' -ForegroundColor Red
                $cancelled = $true
                break currentLoop
            }

            try {
                $user.ChangePassword($currentPlain, $newPlain)
                Write-Host "Password changed successfully for $SamAccountName." -ForegroundColor Green
                $changed = $true
                break currentLoop
            } catch [System.DirectoryServices.AccountManagement.PasswordException] {
                $inner = $_.Exception
                while ($inner.InnerException) { $inner = $inner.InnerException }

                # 0x80070056 / 0x8007052E: the current password was wrong -- go back and re-enter it, not the new one
                if ($inner.HResult -in @(-2147024810, -2147023570)) {
                    Write-Host "Current password is incorrect for $SamAccountName. ($currentAttempt/$maxCurrentAttempts)" -ForegroundColor Red
                    break
                }

                Write-Warning "Password rejected by the domain: $($inner.Message)"
                Write-Host 'Pick a different password (it may have been used recently or blocked by policy).'
            }
        }
    }

    if (-not $changed -and -not $cancelled) {
        Write-Host "Too many incorrect current-password attempts ($maxCurrentAttempts). Exiting without changing the password." -ForegroundColor Red
    }
} catch {
    Write-Error "Password change failed: $($_.Exception.Message)"
} finally {
    $currentPlain = $null
    $newPlain = $null
    $context.Dispose()
}

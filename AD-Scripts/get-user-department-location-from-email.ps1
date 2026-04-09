# Revision : 1.4
# Description : Get Department and CompanyName from Azure AD via Microsoft Graph by email address
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-10-31
# Modified Date : 2026-04-07

param(
    [string[]]$Users
)

if (-not $Users -or $Users.Count -eq 0) {
    $Users = @(
        # "user1@domain.com",
        # "user2@domain.com",
        # "user3@domain.com"
    )
}

if ($Users.Count -eq 0) {
    $input = Read-Host "Enter email address(es), comma-separated"
    $Users = $input -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
}

# ── Connect ────────────────────────────────────────────────────────────────────
Connect-MgGraph -Scopes "User.Read.All"

# ── Query users ────────────────────────────────────────────────────────────────
$userInfos = @()

foreach ($user in $Users) {
    Write-Host "Processing : $user"

    try {
        $mgUser = Get-MgUser -UserId $user `
            -Property DisplayName, UserPrincipalName, CompanyName, Department `
            -ErrorAction Stop

        $userInfo = [PSCustomObject]@{
            DisplayName  = $mgUser.DisplayName
            Email        = $mgUser.UserPrincipalName
            CompanyName  = $mgUser.CompanyName
            Department   = $mgUser.Department
        }
    }
    catch {
        $userInfo = [PSCustomObject]@{
            DisplayName  = "Not Found"
            Email        = $user
            CompanyName  = "N/A"
            Department   = "N/A"
        }
    }

    $userInfos += $userInfo
}

# Output neatly
$userInfos | Format-Table -AutoSize


<#
.EXAMPLE
    .\get-user-department-location-from-email.ps1
    # No parameter provided -- prompts for email(s) at runtime:
    # Enter email address(es), comma-separated: john.smith@contoso.com, jane.doe@contoso.com

.EXAMPLE
    .\get-user-department-location-from-email.ps1 -Users "john.smith@contoso.com"
    # Single user passed via parameter

.EXAMPLE
    .\get-user-department-location-from-email.ps1 -Users "john.smith@contoso.com","jane.doe@contoso.com"
    # Multiple users passed via parameter

.EXAMPLE
    # Populate the $Users array directly in the script to skip the prompt:
    $Users = @(
        "john.smith@contoso.com",
        "jane.doe@contoso.com"
    )

.OUTPUTS
    DisplayName        Email                        CompanyName   Department
    -----------        -----                        -----------   ----------
    John Smith         john.smith@contoso.com       Contoso       Sales
    Jane Doe           jane.doe@contoso.com         Contoso       Engineering
    Not Found          missing@contoso.com          N/A           N/A
#>

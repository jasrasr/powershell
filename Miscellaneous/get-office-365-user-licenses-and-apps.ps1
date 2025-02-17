# Specify the users' emails or User Principal Names (UPNs)
$UserPrincipalNames = @(
    "andy.minderman@middough.com", 
    "charles.bridge@middough.com",
    "david.bridenstine@middough.com",
    "justin.walters@middough.com",
    "nathan.ingram@middough.com",
    "jackie.morris@middough.com",
    "paula.stoneman@middough.com",
    "keyana.williams@middough.com",
    "matt.bedee@middough.com"
)  # Replace with the specific users' UPNs

# ...existing code...

# Retrieve and process each user by UPN
foreach ($UserPrincipalName in $UserPrincipalNames) {
    $User = Get-MsolUser -UserPrincipalName $UserPrincipalName

    # Check if the user is licensed
    if ($User -and $User.isLicensed) {
        Write-Output "User: $($User.UserPrincipalName)"
        $Licenses = $User.Licenses
        
        foreach ($License in $Licenses) {
            if ($License.AccountSkuId -eq "middough:SPE_E3") {
                Write-Output " License SKU: $($License.AccountSkuId)"
                
                # Check enabled services under the license
                foreach ($Service in $License.ServiceStatus) {
                    if ($Service.ServicePlan.ServiceName -eq "SHAREPOINTENTERPRISE") {
                        $Status = if ($Service.ProvisioningStatus -eq "Success") { "Enabled" } else { "Disabled" }
                        Write-Output "   Service: $($Service.ServicePlan.ServiceName) - Status: $Status"
                    }
                }
            }
        }
    } else {
        Write-Output "The specified user $UserPrincipalName is not licensed or does not exist."
    }
}

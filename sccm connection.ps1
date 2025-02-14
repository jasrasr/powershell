# Define the SCCM server name
$sccmServer = "clesccm"

# Start a remote session to the SCCM server
$session = New-PSSession -ComputerName $sccmServer

# Import the SCCM module in the remote session (adjust path if necessary)
Invoke-Command -Session $session -ScriptBlock {
    Import-Module ($Env:SMS_ADMIN_UI_PATH.Substring(0,$Env:SMS_ADMIN_UI_PATH.LastIndexOf('\')) + '\ConfigurationManager.psd1')
    
    # Connect to the SCCM site (adjust your site code here)
    cd "MTS:\"
    
    # Get the specific application by name
   # $appName = "Office 365 2501"
   # $app = Get-CMApplication | Where-Object { $_.LocalizedDisplayName -eq $appName }
<#
    # Check if the application exists
    if ($app) {
        Write-Host "Application: $($app.LocalizedDisplayName)"
        
        # Loop through each deployment type and display its priority
        foreach ($deploymentType in $app.DeploymentTypes) {
            Write-Host "  Deployment Type: $($deploymentType.LocalizedDisplayName)"
            Write-Host "    Priority: $($deploymentType.DeploymentTypePriority)"
        }
    } else {
        Write-Host "Application '$appName' not found."
    }
}
#>
# Close the remote session
#Remove-PSSession -Session $session

}
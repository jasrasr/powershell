Install-Module -Name AzureAD
Connect-AzureAD
$userUPN = "user@example.com"  # Replace with the user's UPN
Get-AzureADAuditDirectoryLogs -Filter "initiatedBy/userPrincipalName eq '$userUPN'"

#Azure CLI
#az login
#az monitor activity-log list --caller user@example.com --offset 7d

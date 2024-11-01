Install-Module Microsoft.Graph
Connect-MgGraph -Scopes "AuditLog.Read.All"
$userPrincipalName = "user@example.com"
Get-MgAuditLogSignIn -Filter "userPrincipalName eq '$userPrincipalName'"
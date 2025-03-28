Install-Module MsIdentityTools -Scope CurrentUser

Connect-MgGraph -Scopes Directory.Read.All, AuditLog.Read.All, UserAuthenticationMethod.Read.All

Export-MsIdAzureMfaReport .\report.xlsx
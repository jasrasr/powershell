# Filename: Get-TenantIdFromDomain.ps1
# Revision : 1.0.0
# Description : Resolves a public domain name to its Microsoft Entra (Azure AD) tenant ID by querying the OpenID Connect discovery endpoint. Same lookup that whatismytenantid.com performs.
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-05-18
# Modified Date : 2026-05-18
# Changelog :
# 1.0.0 initial release

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias("DomainName")]
    [string[]]$Domain
)

process {
    foreach ($d in $Domain) {
        try {
            $uri    = "https://login.microsoftonline.com/$d/.well-known/openid-configuration"
            $config = Invoke-RestMethod -Uri $uri -ErrorAction Stop

            # issuer format: https://login.microsoftonline.com/{tenantId}/v2.0
            if ($config.issuer -match '/([0-9a-fA-F-]{36})/') {
                [PSCustomObject]@{
                    Domain   = $d
                    TenantId = $Matches[1]
                    Status   = "Resolved"
                }
            } else {
                Write-Warning "Could not parse tenant ID from issuer for '$d': $($config.issuer)"
                [PSCustomObject]@{
                    Domain   = $d
                    TenantId = $null
                    Status   = "ParseFailed"
                }
            }
        } catch {
            $msg = if ($_.Exception.Response.StatusCode.value__ -eq 400) {
                "Not a Microsoft Entra tenant (or invalid domain)"
            } else {
                $_.Exception.Message
            }
            Write-Warning "Failed to resolve '$d': $msg"
            [PSCustomObject]@{
                Domain   = $d
                TenantId = $null
                Status   = "NotFound"
            }
        }
    }
}

# Example Usage:
#   .\Get-TenantIdFromDomain.ps1 -Domain "cooperservices.com"
#   .\Get-TenantIdFromDomain.ps1 cooperservices.com
#   "contoso.com","microsoft.com" | .\Get-TenantIdFromDomain.ps1
#   .\Get-TenantIdFromDomain.ps1 -Domain @("contoso.com","microsoft.com") | Format-Table
#   Import-Csv .\domains.csv | .\Get-TenantIdFromDomain.ps1

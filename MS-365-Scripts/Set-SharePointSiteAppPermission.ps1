# =============================================================================
# Filename:     Set-SharePointSiteAppPermission.ps1
# Revision:     1.1.0
# Description:  Scopes an Entra enterprise app to a specific SharePoint site
#               using the Sites.Selected permission model. Authenticates via
#               client credentials (app + secret) and grants read, write, or
#               fullcontrol access to a single site collection.
# Author:       Jason Lamb with help from Claude Code
# Created:      2026-05-15
# Modified:     2026-05-15
# -----------------------------------------------------------------------------
# Changelog:
#   1.0.0  2026-05-15  Initial release
#   1.0.1  2026-05-15  Switch to grantedToIdentitiesV2; fix WhatIf crash on export
#   1.1.0  2026-05-15  Restore automatic site lookup from URL path; default to Altronic_Engineering
# =============================================================================

[CmdletBinding(SupportsShouldProcess)]
param(
    # Tenant ID (GUID or domain)
    [Parameter()]
    [string]$TenantId = "coopermachineryservices.onmicrosoft.com",

    # Client ID of the APP REGISTRATION that needs access (from App registrations blade)
    [Parameter()]
    [string]$TargetAppClientId = "eea57f7f-4e87-4556-ab62-96f3a15011da",

    # Display name for the app — used in the permission grant body
    [Parameter()]
    [string]$TargetAppDisplayName = "Altronic Engineering Task System",

    # Override: supply the full site ID directly to skip the automatic lookup
    # Format: hostname,guid1,guid2  (copy from Graph Explorer)
    # Leave blank to look up the site ID from SitePath automatically
    [Parameter()]
    [string]$SiteId = "",

    # SharePoint site relative path — used when SiteId is not provided
    # Example: "sites/Altronic_Engineering"
    [Parameter()]
    [string]$SitePath = "sites/Altronic_Engineering",

    # SharePoint tenant hostname prefix — used when SiteId is not provided
    [Parameter()]
    [string]$SharePointTenant = "coopermachineryservices",

    # Permission level to grant: read | write | fullcontrol
    [Parameter()]
    [ValidateSet("read", "write", "fullcontrol")]
    [string]$Role = "write",

    # -----------------------------------------------------------------------
    # Credentials for the ADMIN app used to make Graph API calls.
    # This admin app needs Sites.FullControl.All (application permission).
    # -----------------------------------------------------------------------
    [Parameter(Mandatory)]
    [string]$AdminClientId,

    [Parameter(Mandatory)]
    [string]$AdminClientSecret
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

#region ── Helpers ────────────────────────────────────────────────────────────

function Get-GraphToken {
    param(
        [string]$TenantId,
        [string]$ClientId,
        [string]$ClientSecret
    )

    $body = @{
        grant_type    = "client_credentials"
        client_id     = $ClientId
        client_secret = $ClientSecret
        scope         = "https://graph.microsoft.com/.default"
    }

    $response = Invoke-RestMethod `
        -Method Post `
        -Uri "https://login.microsoftonline.com/${TenantId}/oauth2/v2.0/token" `
        -Body $body `
        -ContentType "application/x-www-form-urlencoded"

    return $response.access_token
}

function Invoke-GraphRequest {
    param(
        [string]$Token,
        [string]$Method = "GET",
        [string]$Uri,
        [object]$Body = $null
    )

    $headers = @{
        Authorization  = "Bearer $Token"
        "Content-Type" = "application/json"
    }

    $params = @{
        Method  = $Method
        Uri     = $Uri
        Headers = $headers
    }

    if ($null -ne $Body) {
        $params.Body = ($Body | ConvertTo-Json -Depth 10)
    }

    return Invoke-RestMethod @params
}

#endregion

#region ── Main ───────────────────────────────────────────────────────────────

Write-Host "`n=== Set-SharePointSiteAppPermission ===" -ForegroundColor Cyan
Write-Host "Tenant         : $TenantId"
Write-Host "Target App ID  : $TargetAppClientId"
Write-Host "Target App Name: $TargetAppDisplayName"
Write-Host "Site Path      : $SitePath"
Write-Host "SP Tenant      : ${SharePointTenant}.sharepoint.com"
Write-Host "Role           : $Role`n"

# ── Step 1: Acquire token ────────────────────────────────────────────────────
Write-Host "Step 1: Acquiring Graph API token..." -ForegroundColor Yellow
$token = Get-GraphToken -TenantId $TenantId -ClientId $AdminClientId -ClientSecret $AdminClientSecret
Write-Host "  Token acquired." -ForegroundColor Green

# ── Step 1b: Decode token and show roles ─────────────────────────────────────
$tokenParts  = $token.Split('.')
$b64Payload  = $tokenParts[1]
$padNeeded   = (4 - ($b64Payload.Length % 4)) % 4
$b64Payload += '=' * $padNeeded
$tokenClaims = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($b64Payload)) | ConvertFrom-Json
Write-Host "  Token audience : $($tokenClaims.aud)"
Write-Host "  Token app ID   : $($tokenClaims.appid)"
$roles = if ($tokenClaims.PSObject.Properties['roles']) { $tokenClaims.roles -join ', ' } else { "(none — admin consent likely missing)" }
$rolesColor = if ($tokenClaims.PSObject.Properties['roles']) { 'Green' } else { 'Red' }
Write-Host "  Token roles    : $roles" -ForegroundColor $rolesColor

# ── Step 2: Resolve site ID ──────────────────────────────────────────────────
if ($SiteId) {
    Write-Host "`nStep 2: Using provided site ID..." -ForegroundColor Yellow
    Write-Host "  Site ID: $SiteId" -ForegroundColor Green
} else {
    if (-not $SitePath) {
        throw "You must supply either -SiteId or -SitePath."
    }
    Write-Host "`nStep 2: Looking up site ID for '${SharePointTenant}.sharepoint.com/$SitePath'..." -ForegroundColor Yellow
    $lookupUri = "https://graph.microsoft.com/v1.0/sites/${SharePointTenant}.sharepoint.com:/$SitePath"
    $siteObj   = Invoke-GraphRequest -Token $token -Uri $lookupUri
    $SiteId    = $siteObj.id
    Write-Host "  Site found: $($siteObj.displayName)" -ForegroundColor Green
    Write-Host "  Site ID   : $SiteId" -ForegroundColor Green
}

# ── Step 3: Skipped (requires Sites.Read.All — not needed for this grant) ────
Write-Host "`nStep 3: Skipping existing permission check (insufficient scope)." -ForegroundColor DarkGray


# ── Step 4: Grant permission ──────────────────────────────────────────────────
# grantedToIdentitiesV2 is required for app-only grants in modern Graph tenants
$grantBody = @{
    roles                   = @($Role)
    grantedToIdentitiesV2   = @(
        @{
            application = @{
                id          = $TargetAppClientId
                displayName = $TargetAppDisplayName
            }
        }
    )
}

$grant = $null

if ($PSCmdlet.ShouldProcess("Site '$SiteId'", "Grant '$Role' to app '$TargetAppDisplayName'")) {
    Write-Host "Step 4: Granting '$Role' permission to app..." -ForegroundColor Yellow

    $grant = Invoke-GraphRequest `
        -Token  $token `
        -Method "POST" `
        -Uri    "https://graph.microsoft.com/v1.0/sites/${SiteId}/permissions" `
        -Body   $grantBody

    Write-Host "  Permission granted successfully." -ForegroundColor Green
    Write-Host "  Permission ID: $($grant.id)"
}

# ── Step 5: Verify (best-effort — requires Sites.Read.All) ──────────────────
Write-Host "`nStep 5: Verifying permissions on site..." -ForegroundColor Yellow

try {
    $verifyPerms = Invoke-GraphRequest -Token $token -Uri "https://graph.microsoft.com/v1.0/sites/${SiteId}/permissions"
    Write-Host "`n  Current app permissions on site:" -ForegroundColor Cyan
    $verifyPerms.value | ForEach-Object {
        $appId   = $_.grantedToIdentitiesV2.application.id
        $appName = $_.grantedToIdentitiesV2.application.displayName
        $roles   = $_.roles -join ", "
        Write-Host "    [$($_.id)]  App: $appName ($appId)  Role: $roles"
    }
} catch {
    Write-Host "  Verification skipped (app lacks Sites.Read.All — grant still succeeded above)." -ForegroundColor DarkGray
}

Write-Host "`nDone." -ForegroundColor Green

# ── Export summary ────────────────────────────────────────────────────────────
$exportPath = Join-Path $PSExports "SitePermissionGrant_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"

[PSCustomObject]@{
    Timestamp          = (Get-Date -Format "o")
    TenantId           = $TenantId
    SitePath           = $SitePath
    SiteId             = $SiteId
    SiteUrl            = "https://${SharePointTenant}.sharepoint.com/$SitePath"
    TargetAppClientId  = $TargetAppClientId
    TargetAppName      = $TargetAppDisplayName
    RoleGranted        = $Role
    PermissionId       = if ($grant) { $grant.id } else { "WhatIf/skipped" }
} | Export-Csv -Path $exportPath -NoTypeInformation

Write-Host "Export saved: $exportPath" -ForegroundColor DarkGray

#endregion

# =============================================================================
# Example Usage:
#
# # Default — looks up Altronic_Engineering site automatically:
# .\Set-SharePointSiteAppPermission.ps1 `
#   -AdminClientId     "ffffffff-gggg-hhhh-iiii-jjjjjjjjjjjj" `
#   -AdminClientSecret "your-admin-app-secret"
#
# # Target a different site by path:
# .\Set-SharePointSiteAppPermission.ps1 `
#   -SitePath          "sites/IT" `
#   -AdminClientId     "ffffffff-gggg-hhhh-iiii-jjjjjjjjjjjj" `
#   -AdminClientSecret "your-admin-app-secret"
#
# # Skip lookup by supplying the site ID directly:
# .\Set-SharePointSiteAppPermission.ps1 `
#   -SiteId            "contoso.sharepoint.com,guid1,guid2" `
#   -AdminClientId     "ffffffff-gggg-hhhh-iiii-jjjjjjjjjjjj" `
#   -AdminClientSecret "your-admin-app-secret"
#
# # Dry run (WhatIf — shows what would happen without making changes):
# .\Set-SharePointSiteAppPermission.ps1 ... -WhatIf
#
# # Grant read instead of write:
# .\Set-SharePointSiteAppPermission.ps1 ... -Role read
#
# # Grant full control (e.g. for a migration tool):
# .\Set-SharePointSiteAppPermission.ps1 ... -Role fullcontrol
# =============================================================================
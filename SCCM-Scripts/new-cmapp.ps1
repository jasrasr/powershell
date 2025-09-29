<#
.SYNOPSIS
Create a ConfigMgr Application with MSI or Script deployment type + detection, then optionally distribute content.

.PARAMETER SiteCode
Three-letter site code, e.g. ABC

.PARAMETER SiteServer
Your primary site server FQDN, e.g. cm01.contoso.com

.PARAMETER AppName
Application name as shown in Software Center

.PARAMETER Publisher
Publisher metadata

.PARAMETER Version
Software version metadata

.PARAMETER IconPath
Optional path to icon file (ico/png/jpg/exe/dll)

.PARAMETER DeployType
'MSI' or 'Script'

.PARAMETER ContentPath
Network path to source content (folder or MSI full path)

.PARAMETER InstallCmd
For Script DT: the install command line (e.g., "setup.exe /S"). Ignored for MSI.

.PARAMETER UninstallCmd
Optional uninstall command (both MSI and Script DT support it)

.PARAMETER MsiProductCode
For MSI DT detection/version pinning (GUID). Optional but recommended.

.PARAMETER ExpectedMsiVersion
Optional version string for MSI detection (e.g., 23.1.0). If omitted, ProductCode alone can be used.

.PARAMETER DetectFilePath
For Script DT: full path to a file to detect (e.g., "C:\Program Files\App\app.exe")

.PARAMETER DPName
Optional single Distribution Point name to distribute to

.PARAMETER DPGroupName
Optional Distribution Point Group name to distribute to

.EXAMPLE
.\New-CMApp.ps1 -SiteCode ABC -SiteServer cm01.contoso.com -AppName "7-Zip 23.01" `
  -Publisher "7-Zip.org" -Version "23.01" -DeployType MSI `
  -ContentPath "\\cm01\Sources\Apps\7-Zip\7z2301-x64.msi" `
  -MsiProductCode "{23170F69-40C1-2702-2301-000001000000}" `
  -ExpectedMsiVersion "23.01" -IconPath "\\cm01\Sources\Icons\7zip.png" `
  -DPGroupName "All DPs"

.EXAMPLE
.\New-CMApp.ps1 -SiteCode ABC -SiteServer cm01.contoso.com -AppName "Acme Tool" `
  -Publisher "Acme" -Version "1.2.3" -DeployType Script `
  -ContentPath "\\cm01\Sources\Apps\AcmeTool" `
  -InstallCmd "setup.exe /quiet /norestart" -UninstallCmd "setup.exe /uninstall /quiet" `
  -DetectFilePath "C:\Program Files\Acme\tool.exe" -DPName "DP-CLE-01"
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string] $SiteCode,
    [Parameter(Mandatory)][string] $SiteServer,
    [Parameter(Mandatory)][string] $AppName,
    [Parameter(Mandatory)][string] $Publisher,
    [Parameter(Mandatory)][string] $Version,
    [string] $IconPath,

    [Parameter(Mandatory)][ValidateSet('MSI','Script')] [string] $DeployType,

    [Parameter(Mandatory)][string] $ContentPath,
    [string] $InstallCmd,
    [string] $UninstallCmd,

    [string] $MsiProductCode,
    [string] $ExpectedMsiVersion,

    [string] $DetectFilePath,

    [string] $DPName,
    [string] $DPGroupName
)

# ---- Module + site drive ----
try {
    if (-not (Get-Module -ListAvailable ConfigurationManager)) {
        $psd1 = Join-Path $env:SMS_ADMIN_UI_PATH "..\ConfigurationManager.psd1"
        if (Test-Path $psd1) { Import-Module $psd1 -ErrorAction Stop } else { Import-Module ConfigurationManager -ErrorAction Stop }
    } else {
        Import-Module ConfigurationManager -ErrorAction Stop
    }
} catch {
    throw "Could not import ConfigurationManager module $_"
}

if (-not (Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue)) {
    New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $SiteServer | Out-Null
}
Set-Location ($SiteCode + ":")

# ---- Create or get the application ----
$app = Get-CMApplication -Name $AppName -ErrorAction SilentlyContinue
if ($app) {
    Write-Host "App $AppName already exists : skipping creation"
} else {
    $newParams = @{
        Name            = $AppName
        Publisher       = $Publisher
        SoftwareVersion = $Version
    }
    if ($IconPath) { $newParams.IconLocationFile = $IconPath }
    $app = New-CMApplication @newParams
    Write-Host "Created application $AppName : OK"
}

# ---- Add deployment type ----
switch ($DeployType) {
    'MSI' {
        if (-not (Test-Path $ContentPath)) { throw "MSI path $ContentPath : not found" }

        $dtName = "$AppName - MSI"
        $msiParams = @{
            ApplicationName     = $AppName
            DeploymentTypeName  = $dtName
            ContentLocation     = $ContentPath
        }
        if ($UninstallCmd) { $msiParams.UninstallCommand = $UninstallCmd }

        # Optional MSI detection by ProductCode / version
        $clauses = @()
        if ($MsiProductCode) {
            if ($ExpectedMsiVersion) {
                $clauses += New-CMDetectionClauseWindowsInstaller -ProductCode $MsiProductCode -Value `
                            -ExpressionOperator IsEquals -ExpectedValue $ExpectedMsiVersion
            } else {
                $clauses += New-CMDetectionClauseWindowsInstaller -ProductCode $MsiProductCode
            }
            $msiParams.Add('AddDetectionClause',$clauses)
        }

        $null = Add-CMMsiDeploymentType @msiParams
        Write-Host "Added MSI deployment type $dtName : OK"
    }

    'Script' {
        if (-not (Test-Path $ContentPath)) { throw "Content folder $ContentPath : not found" }
        if (-not $InstallCmd) { throw "InstallCmd is required for Script deployment type" }

        $dtName = "$AppName - Script"
        $scriptParams = @{
            ApplicationName     = $AppName
            DeploymentTypeName  = $dtName
            InstallCommand      = $InstallCmd
            ContentLocation     = $ContentPath
        }
        if ($UninstallCmd) { $scriptParams.UninstallCommand = $UninstallCmd }

        $null = Add-CMScriptDeploymentType @scriptParams
        Write-Host "Added Script deployment type $dtName : OK"

        # File-based detection (common, simple). Group uses AND by default.
        if ($DetectFilePath) {
            $dir  = Split-Path $DetectFilePath -Parent
            $file = Split-Path $DetectFilePath -Leaf
            $det  = New-CMDetectionClauseFile -FileName $file -Path $dir -Existence
            Set-CMScriptDeploymentType -ApplicationName $AppName -DeploymentTypeName $dtName -AddDetectionClause $det | Out-Null
            Write-Host "Added file detection $DetectFilePath : OK"
        } else {
            Write-Host "No DetectFilePath provided : remember to add a detection method"
        }
    }
    default { throw "Unsupported DeployType $DeployType" }
}

# ---- Optional content distribution ----
if ($DPName -or $DPGroupName) {
    $distParams = @{ ApplicationName = @($AppName) }
    if ($DPName)      { $distParams.DistributionPointName     = @($DPName) }
    if ($DPGroupName) { $distParams.DistributionPointGroupName = @($DPGroupName) }
    Start-CMContentDistribution @distParams | Out-Null
    Write-Host "Kicked off content distribution : OK"
}

Write-Host "Done : $AppName ready to deploy"

<#
example usage
MSI
.\New-CMApp.ps1 `
  -SiteCode "ABC" `
  -SiteServer "cm01.contoso.com" `
  -AppName "7-Zip 23.01" `
  -Publisher "7-Zip.org" `
  -Version "23.01" `
  -DeployType "MSI" `
  -ContentPath "\\cm01\Sources\Apps\7Zip\7z2301-x64.msi" `
  -MsiProductCode "{23170F69-40C1-2702-2301-000001000000}" `
  -ExpectedMsiVersion "23.01" `
  -IconPath "\\cm01\Sources\Icons\7zip.png" `
  -DPGroupName "All DPs"
  
  EXE/SCRIPT
  .\New-CMApp.ps1 `
  -SiteCode "ABC" `
  -SiteServer "cm01.contoso.com" `
  -AppName "AcmeTool 1.2.3" `
  -Publisher "Acme Corp" `
  -Version "1.2.3" `
  -DeployType "Script" `
  -ContentPath "\\cm01\Sources\Apps\AcmeTool" `
  -InstallCmd "setup.exe /quiet /norestart" `
  -UninstallCmd "setup.exe /uninstall /quiet" `
  -DetectFilePath "C:\Program Files\Acme\tool.exe" `
  -DPName "DP-Site1"
#>
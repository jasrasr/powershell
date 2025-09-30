param(
    [Parameter(Mandatory=$true)]
    [string] $CsvPath,

    [string] $ConfigFile = '$githubpath\PowerShell-Private\SCCM-Scripts\new-app-via-csv-params.psd1'
)

# Import the PSD1 file (returns a hashtable)
$config = Import-PowerShellDataFile -Path $ConfigFile

# Now extract your values if present, or fallback defaults
$SiteCode = if ($null -ne $config.SiteCode) { $config.SiteCode } else { 'MTS' }
$SiteServer = if ($null -ne $config.SiteServer) { $config.SiteServer } else { 'clesccm.middough.local' }
$DefaultDPNames = if ($null -ne $config.DefaultDPNames) { $config.DefaultDPNames } else {
    @('ashut01.middough.local','bufut01.middough.local','chiut01.middough.local','nwiut01.middough.local','pitut01.middough.local','tolut01.middough.local','clesccm.middough.local')
}

# Import CSV rows
$appRows = Import-Csv -Path $CsvPath

foreach ($row in $appRows) {
    # compute DPNames for this row
    $dpnames = if ($row.DPNames) {
        $row.DPNames -split ',' | ForEach-Object { $_.Trim() }
    } else {
        $DefaultDPNames
    }

    # Build params for one app
    $params = @{
        SiteCode    = $SiteCode
        SiteServer  = $SiteServer
        AppName     = $row.AppName
        Publisher   = $row.Publisher
        Version     = $row.Version
        IconPath    = $row.IconPath
        DeployType  = $row.DeployType
        ContentPath = $row.ContentPath
        DPNames     = $dpnames
    }

    if ($row.InstallCmd)        { $params.InstallCmd         = $row.InstallCmd }
    if ($row.UninstallCmd)      { $params.UninstallCmd       = $row.UninstallCmd }
    if ($row.MsiProductCode)    { $params.MsiProductCode     = $row.MsiProductCode }
    if ($row.ExpectedMsiVersion){ $params.ExpectedMsiVersion = $row.ExpectedMsiVersion }
    if ($row.DetectFilePath)    { $params.DetectFilePath     = $row.DetectFilePath }
    if ($row.DetectDirectoryPath){ $params.DetectDirectoryPath = $row.DetectDirectoryPath }
    if ($row.DPGroupNames) {
        $params.DPGroupNames = ($row.DPGroupNames -split ',') | ForEach-Object { $_.Trim() }
    }

    Write-Host "`n>>> Creating app $($row.AppName) ..."
    try {
        .\New-CMApp.ps1 @params
    }
    catch {
        Write-Warning "Failed to create app $($row.AppName): $_"
    }
    Write-Host ">>> Done $($row.AppName)`n"
}

# Required modules for this script.
$RequiredModules = @(
    # 'Microsoft.Graph',
    # 'ExchangeOnlineManagement'
)

foreach ($ModuleName in $RequiredModules) {
    if (-not (Get-Module -ListAvailable -Name $ModuleName)) {
        Write-Host "Installing module: $ModuleName" -ForegroundColor Cyan
        Install-Module -Name $ModuleName -Scope CurrentUser -Force
    }

    if (-not (Get-Module -Name $ModuleName)) {
        Write-Host "Importing module: $ModuleName" -ForegroundColor Cyan
        Import-Module -Name $ModuleName -ErrorAction Stop
    }
}

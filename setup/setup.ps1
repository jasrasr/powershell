#Requires -Version 5.1

[CmdletBinding()]
param(
    [string]$ConfigUrl = 'https://raw.githubusercontent.com/jasrasr/powershell/main/setup/setup.json',
    [switch]$WhatIf
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

function Write-Step {
    param([string]$Message)
    Write-Host "`n==> $Message" -ForegroundColor Cyan
}

function Set-RegistryValue {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)]$Value,
        [ValidateSet('String', 'ExpandString', 'Binary', 'DWord', 'MultiString', 'QWord')]
        [string]$Type = 'DWord'
    )

    if ($WhatIf) {
        Write-Host "[WhatIf] Set $Path\$Name to $Value"
        return
    }

    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -Path $Path -Force | Out-Null
    }
    New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType $Type -Force | Out-Null
}

if (-not $IsWindows -and $PSVersionTable.PSEdition -eq 'Core') {
    throw 'This setup currently supports Windows only.'
}

Write-Step 'Loading setup configuration'
$config = Invoke-RestMethod -Uri $ConfigUrl -UseBasicParsing

$winget = Get-Command winget.exe -ErrorAction SilentlyContinue
if (-not $winget) {
    throw 'WinGet is not installed. Install or update App Installer from Microsoft Store, then run setup again.'
}

Write-Step 'Installing applications'
foreach ($app in $config.apps) {
    if (-not $app.enabled) {
        continue
    }

    $installed = & $winget.Source list --id $app.id --exact --accept-source-agreements 2>$null |
        Select-String -SimpleMatch $app.id
    if ($installed) {
        Write-Host "Already installed: $($app.name)"
        continue
    }

    if ($WhatIf) {
        Write-Host "[WhatIf] Install $($app.name) ($($app.id))"
        continue
    }

    Write-Host "Installing: $($app.name)"
    & $winget.Source install --id $app.id --exact --silent --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "WinGet could not install $($app.name) (exit code $LASTEXITCODE)."
    }
}

Write-Step 'Applying user settings'
foreach ($setting in $config.registrySettings) {
    if ($setting.enabled) {
        Set-RegistryValue -Path $setting.path -Name $setting.name -Value $setting.value -Type $setting.type
    }
}

if ($config.restartExplorer) {
    if ($WhatIf) {
        Write-Host '[WhatIf] Restart Windows Explorer'
    }
    else {
        Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    }
}

Write-Step 'Setup complete'
Write-Host 'Some application or Windows changes may require signing out or restarting.'

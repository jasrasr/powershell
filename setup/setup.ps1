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

function Test-Administrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Update-ProcessPath {
    $machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = "$machinePath;$userPath"
}

function Install-PowerShellProfile {
    $documents = [Environment]::GetFolderPath('MyDocuments')
    $commonDirectory = Join-Path $documents 'PowerShell'
    $commonProfile = Join-Path $commonDirectory 'Profile.Common.ps1'
    $profilePaths = @(
        (Join-Path $documents 'PowerShell\profile.ps1'),
        (Join-Path $documents 'WindowsPowerShell\profile.ps1')
    )
    $startMarker = '# >>> jasr.me setup >>>'
    $endMarker = '# <<< jasr.me setup <<<'
    $managedBlock = @"
$startMarker
`$commonProfile = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'PowerShell\Profile.Common.ps1'
if (Test-Path -LiteralPath `$commonProfile) { . `$commonProfile }
$endMarker
"@
    $commonContent = @'
# Shared PowerShell profile managed by jasr.me/setup.
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
if (Get-Module -ListAvailable PSReadLine) {
    Import-Module PSReadLine
    Set-PSReadLineOption -EditMode Windows -HistoryNoDuplicates -BellStyle None
    if ($Host.Name -eq 'ConsoleHost') {
        Set-PSReadLineOption -PredictionSource History -ErrorAction SilentlyContinue
    }
}
'@

    if ($WhatIf) {
        Write-Host "[WhatIf] Configure shared profile $commonProfile for PowerShell 5.1 and 7"
        return
    }

    New-Item -ItemType Directory -Path $commonDirectory -Force | Out-Null
    Set-Content -LiteralPath $commonProfile -Value $commonContent -Encoding utf8
    foreach ($profilePath in $profilePaths) {
        New-Item -ItemType Directory -Path (Split-Path $profilePath) -Force | Out-Null
        $content = if (Test-Path -LiteralPath $profilePath) { Get-Content -LiteralPath $profilePath -Raw } else { '' }
        $pattern = '(?s)' + [regex]::Escape($startMarker) + '.*?' + [regex]::Escape($endMarker)
        $updated = if ($content -match $pattern) {
            [regex]::Replace($content, $pattern, $managedBlock.Trim())
        }
        else {
            ($content.TrimEnd() + "`r`n`r`n" + $managedBlock.Trim() + "`r`n").TrimStart()
        }
        Set-Content -LiteralPath $profilePath -Value $updated -Encoding utf8
    }
}

if (-not $IsWindows -and $PSVersionTable.PSEdition -eq 'Core') {
    throw 'This setup currently supports Windows only.'
}

Write-Step 'Loading setup configuration'
$config = Invoke-RestMethod -Uri $ConfigUrl -UseBasicParsing

$winget = Get-Command winget.exe -ErrorAction SilentlyContinue
if (-not $winget) {
    Write-Step 'Bootstrapping WinGet'
    if ($WhatIf) {
        Write-Host '[WhatIf] Install Microsoft.WinGet.Client and repair WinGet'
    }
    else {
        Install-PackageProvider -Name NuGet -Force | Out-Null
        Install-Module Microsoft.WinGet.Client -Repository PSGallery -Scope CurrentUser -Force -AllowClobber
        Import-Module Microsoft.WinGet.Client
        Repair-WinGetPackageManager -AllUsers:$false
        Update-ProcessPath
    }
    $winget = Get-Command winget.exe -ErrorAction SilentlyContinue
    if (-not $winget -and -not $WhatIf) {
        throw 'WinGet bootstrap did not complete. Install App Installer from Microsoft Store, then run setup again.'
    }
}

Write-Step 'Installing applications'
foreach ($app in $config.apps) {
    if (-not $app.enabled) {
        continue
    }

    $installed = if ($winget) {
        & $winget.Source list --id $app.id --exact --accept-source-agreements 2>$null |
            Select-String -SimpleMatch $app.id
    }
    else { $null }
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

Update-ProcessPath

Write-Step 'Installing global npm tools'
$npm = Get-Command npm.cmd -ErrorAction SilentlyContinue
if (-not $npm -and ($config.npmPackages | Where-Object enabled)) {
    Write-Warning 'npm is not available in this session. Open a new terminal and run setup again.'
}
elseif ($npm) {
    foreach ($package in $config.npmPackages) {
        if (-not $package.enabled) { continue }
        if ($WhatIf) {
            Write-Host "[WhatIf] Install/update $($package.name) ($($package.id))"
        }
        else {
            Write-Host "Installing/updating: $($package.name)"
            & $npm.Source install --global $package.id
            if ($LASTEXITCODE -ne 0) { Write-Warning "npm could not install $($package.name)." }
        }
    }
}

Write-Step 'Installing PowerShell modules'
foreach ($module in $config.powershellModules) {
    if (-not $module.enabled) { continue }
    if ($WhatIf) {
        Write-Host "[WhatIf] Install/update PowerShell module $($module.name)"
    }
    else {
        Write-Host "Installing/updating module: $($module.name)"
        Install-Module -Name $module.name -Repository PSGallery -Scope CurrentUser -Force -AllowClobber -AcceptLicense
    }
}

Write-Step 'Installing Windows capabilities'
$isAdministrator = Test-Administrator
foreach ($capability in $config.windowsCapabilities) {
    if (-not $capability.enabled) { continue }
    if (-not $isAdministrator) {
        Write-Warning "$($capability.name) requires an elevated PowerShell session; skipping."
    }
    elseif ($WhatIf) {
        Write-Host "[WhatIf] Install $($capability.name) ($($capability.id))"
    }
    else {
        $state = Get-WindowsCapability -Online -Name $capability.id
        if ($state.State -eq 'Installed') { Write-Host "Already installed: $($capability.name)" }
        else { Add-WindowsCapability -Online -Name $capability.id | Out-Null }
    }
}

if ($config.profile.enabled) {
    Write-Step 'Configuring PowerShell profiles'
    Install-PowerShellProfile
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

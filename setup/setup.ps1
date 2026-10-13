#Requires -Version 5.1

[CmdletBinding()]
param(
    [string]$ConfigUrl = 'https://raw.githubusercontent.com/jasrasr/powershell/main/setup/setup.json',
    [switch]$WhatIf
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

# When run as a file beside setup.json (and no -ConfigUrl given), read the config and
# settings files from that folder instead of GitHub. `irm | iex` has no script path,
# so it still downloads everything from $ConfigUrl.
$LocalRoot = $null
if (-not $PSBoundParameters.ContainsKey('ConfigUrl') -and $PSScriptRoot -and
    (Test-Path -LiteralPath (Join-Path $PSScriptRoot 'setup.json'))) {
    $LocalRoot = $PSScriptRoot
}

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

function Test-InstalledApplication {
    param([Parameter(Mandatory)][string]$DisplayNamePattern)

    $uninstallPaths = @(
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
    )
    foreach ($path in $uninstallPaths) {
        $match = Get-ItemProperty -Path $path -ErrorAction SilentlyContinue |
            Where-Object DisplayName -Like $DisplayNamePattern |
            Select-Object -First 1
        if ($match) { return $true }
    }
    return $false
}

function Install-PowerShellProfile {
    $documents = [Environment]::GetFolderPath('MyDocuments')
    $profilePaths = @(
        (Join-Path $documents 'PowerShell\profile.ps1'),
        (Join-Path $documents 'WindowsPowerShell\profile.ps1')
    )
    $startMarker = '# >>> jasr.me setup >>>'
    $endMarker = '# <<< jasr.me setup <<<'
    # The real profile lives in the synced OneDrive file; this block only loads it.
    $managedBlock = @"
$startMarker
if (`$env:OneDriveCommercial) {
    `$commonpowershellprofilepath = Join-Path `$env:OneDriveCommercial '!commonpowershellprofilepath.ps1'
    if (Test-Path `$commonpowershellprofilepath) {
        . `$commonpowershellprofilepath
    }
}
$endMarker
"@

    if ($WhatIf) {
        Write-Host '[WhatIf] Add OneDrive common-profile loader to the PowerShell 5.1 and 7 profiles'
        return
    }

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

function Resolve-PicturesFolder {
    # First existing Pictures folder: OneDrive for Business, then OneDrive, then the user profile.
    $candidates = @(
        $(if ($env:OneDriveCommercial) { Join-Path $env:OneDriveCommercial 'Pictures' }),
        $(if ($env:OneDrive) { Join-Path $env:OneDrive 'Pictures' }),
        (Join-Path $env:USERPROFILE 'Pictures')
    )
    foreach ($candidate in $candidates) {
        if ($candidate -and (Test-Path -LiteralPath $candidate)) { return $candidate }
    }
    # None exist yet: fall back to the profile Pictures folder (created with the Screenshots folder).
    return (Join-Path $env:USERPROFILE 'Pictures')
}

function Install-AppSettings {
    param([Parameter(Mandatory)]$Setting)

    $destination = if ($Setting.destination) { [Environment]::ExpandEnvironmentVariables($Setting.destination) } else { 'registry' }
    if ($WhatIf) {
        Write-Host "[WhatIf] Apply $($Setting.name) settings from $($Setting.source) to $destination"
        return
    }

    $temp = Join-Path ([IO.Path]::GetTempPath()) ([IO.Path]::GetRandomFileName())
    try {
        if ($LocalRoot) {
            # Local mode: the script was run from its own folder, so use the files beside it.
            $sourcePath = Join-Path $LocalRoot $Setting.source
            Copy-Item -LiteralPath $sourcePath -Destination $temp -Force -ErrorAction Stop
        }
        else {
            $sourceUrl = [Uri]::new([Uri]$ConfigUrl, $Setting.source).AbsoluteUri
            Invoke-WebRequest -UseBasicParsing -Uri $sourceUrl -OutFile $temp
        }
    }
    catch {
        Write-Warning "Skipping $($Setting.name) settings; could not read $($Setting.source)."
        return
    }

    try {
        if ($Setting.registryImport) {
            # .reg file imported into HKCU (e.g. 3D Clipboard).
            $regPath = "$temp.reg"
            Move-Item -LiteralPath $temp -Destination $regPath -Force
            $temp = $regPath
            & reg.exe import $regPath 2>&1 | Out-Null
            if ($LASTEXITCODE -ne 0) { throw "reg.exe import returned exit code $LASTEXITCODE." }
            Write-Host "Applied $($Setting.name) settings: registry"
            return
        }

        if ($Setting.extract) {
            # Zip of settings files extracted into the destination folder (e.g. PowerToys).
            $zipPath = "$temp.zip"
            Move-Item -LiteralPath $temp -Destination $zipPath -Force
            $temp = $zipPath
            New-Item -ItemType Directory -Path $destination -Force | Out-Null
            Expand-Archive -LiteralPath $zipPath -DestinationPath $destination -Force
            if ($Setting.expandPathTokens) {
                # Extracted files are JSON: insert this machine's profile path with backslashes escaped.
                $jsonProfile = $env:USERPROFILE.Replace('\', '\\')
                Get-ChildItem -LiteralPath $destination -Recurse -File -Filter *.json |
                    Where-Object { Select-String -LiteralPath $_.FullName -Pattern '%USERPROFILE%' -SimpleMatch -Quiet } |
                    ForEach-Object {
                        $json = [IO.File]::ReadAllText($_.FullName).Replace('%USERPROFILE%', $jsonProfile)
                        [IO.File]::WriteAllText($_.FullName, $json, [Text.UTF8Encoding]::new($false))
                    }
            }
            Write-Host "Applied $($Setting.name) settings: $destination"
            return
        }

        New-Item -ItemType Directory -Path (Split-Path $destination) -Force | Out-Null
        if ((Test-Path -LiteralPath $destination) -and $Setting.backup) {
            Copy-Item -LiteralPath $destination -Destination "$destination.bak" -Force
        }
        if ($Setting.expandPathTokens) {
            # Replace path tokens with this machine's locations. %MYPICTURES% follows
            # folder redirection (e.g. OneDrive known folder move).
            $text = Get-Content -LiteralPath $temp -Raw
            $picturesFolder = Resolve-PicturesFolder
            $tokens = [ordered]@{
                '%SCREENSHOTS%'  = Join-Path $picturesFolder 'Screenshots'
                '%MYPICTURES%'   = $picturesFolder
                '%USERPROFILE%'  = $env:USERPROFILE
                '%LOCALAPPDATA%' = $env:LOCALAPPDATA
                '%APPDATA%'      = $env:APPDATA
            }
            foreach ($token in $tokens.Keys) { $text = $text.Replace($token, $tokens[$token]) }
            if ($text.Contains($tokens['%SCREENSHOTS%']) -and -not (Test-Path -LiteralPath $tokens['%SCREENSHOTS%'])) {
                New-Item -ItemType Directory -Path $tokens['%SCREENSHOTS%'] -Force | Out-Null
                Write-Host "Created screenshots folder: $($tokens['%SCREENSHOTS%'])"
            }
            [IO.File]::WriteAllText($destination, $text, [Text.UTF8Encoding]::new($false))
        }
        else {
            Copy-Item -LiteralPath $temp -Destination $destination -Force
        }
        Write-Host "Applied $($Setting.name) settings: $destination"
    }
    finally {
        Remove-Item -LiteralPath $temp -Force -ErrorAction SilentlyContinue
    }
}

if (-not $IsWindows -and $PSVersionTable.PSEdition -eq 'Core') {
    throw 'This setup currently supports Windows only.'
}

Write-Step 'Loading setup configuration'
if ($LocalRoot) {
    Write-Host "Using local configuration: $LocalRoot"
    $config = Get-Content -LiteralPath (Join-Path $LocalRoot 'setup.json') -Raw | ConvertFrom-Json
}
else {
    $config = Invoke-RestMethod -Uri $ConfigUrl -UseBasicParsing
}

if ($config.requireOneDrive) {
    Write-Step 'Checking OneDrive'
    $oneDriveRoot = $env:OneDriveCommercial
    if (-not $oneDriveRoot -or -not (Test-Path -LiteralPath $oneDriveRoot)) {
        $message = 'OneDrive for Business is not signed in. Sign in to OneDrive, let it finish syncing, then run setup again.'
        if ($WhatIf) { Write-Warning $message } else { throw $message }
    }
    elseif (-not (Test-Path -LiteralPath (Join-Path $oneDriveRoot '!commonpowershellprofilepath.ps1'))) {
        Write-Warning 'OneDrive is signed in but !commonpowershellprofilepath.ps1 has not synced yet; the PowerShell profile will load it once it appears.'
    }
    else {
        Write-Host "OneDrive ready: $oneDriveRoot"
    }
}

$winget = Get-Command winget.exe -ErrorAction SilentlyContinue
if (-not $winget) {
    $wingetPath = Join-Path $env:LOCALAPPDATA 'Microsoft\WindowsApps\winget.exe'
    if (Test-Path -LiteralPath $wingetPath) { $winget = Get-Command $wingetPath }
}
if (-not $winget) {
    Write-Step 'Bootstrapping WinGet'
    if ($WhatIf) {
        Write-Host '[WhatIf] Install Microsoft.WinGet.Client and repair WinGet'
    }
    else {
        try { Install-PackageProvider -Name NuGet -Force -ErrorAction Stop | Out-Null }
        catch { Write-Warning "NuGet provider install failed ($($_.Exception.Message)); continuing." }
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
    if ($installed -and -not $app.upgrade) {
        Write-Host "Already installed: $($app.name)"
        continue
    }

    $action = if ($installed) { 'upgrade' } else { 'install' }
    if ($WhatIf) {
        Write-Host "[WhatIf] $action $($app.name) ($($app.id)) to the latest available version"
        continue
    }

    Write-Host "$($action): $($app.name)"
    & $winget.Source $action --id $app.id --exact --source winget --silent --accept-package-agreements --accept-source-agreements
    if ($action -eq 'upgrade' -and $LASTEXITCODE -eq -1978335189) {
        # APPINSTALLER_CLI_ERROR_UPDATE_NOT_APPLICABLE: already up to date.
        Write-Host "Already up to date: $($app.name)"
    }
    elseif ($action -eq 'upgrade' -and $LASTEXITCODE -eq -1978335090) {
        # Installed package type (e.g. MSI vs MSIX) differs from the one WinGet offers.
        Write-Warning "$($app.name) cannot be upgraded in place because the install technology differs. From a different shell, run: winget uninstall --id $($app.id); winget install --id $($app.id) --source winget"
    }
    elseif ($LASTEXITCODE -ne 0) {
        Write-Warning "WinGet could not $action $($app.name) (exit code $LASTEXITCODE)."
    }
}

Write-Step 'Installing verified direct-download applications'
foreach ($installer in $config.directInstallers) {
    if (-not $installer.enabled) { continue }
    if (Test-InstalledApplication -DisplayNamePattern $installer.displayNamePattern) {
        Write-Host "Already installed: $($installer.name)"
        continue
    }
    if ($WhatIf) {
        Write-Host "[WhatIf] Download, verify, and install $($installer.name) $($installer.version)"
        continue
    }

    $downloadPath = Join-Path ([IO.Path]::GetTempPath()) ([IO.Path]::GetRandomFileName() + '.exe')
    try {
        Write-Host "Downloading: $($installer.name)"
        Invoke-WebRequest -UseBasicParsing -Uri $installer.url -OutFile $downloadPath
        $actualHash = (Get-FileHash -LiteralPath $downloadPath -Algorithm SHA256).Hash
        if ($actualHash -ne $installer.sha256) {
            throw "Hash verification failed for $($installer.name). Expected $($installer.sha256); received $actualHash."
        }
        $signature = Get-AuthenticodeSignature -LiteralPath $downloadPath
        if ($signature.Status -ne 'Valid') {
            throw "Authenticode verification failed for $($installer.name): $($signature.Status)."
        }
        Write-Host "Installing: $($installer.name)"
        $process = Start-Process -FilePath $downloadPath -ArgumentList $installer.arguments -PassThru
        # Avoid Start-Process -Wait: it also waits for child processes (e.g. an app launched by the installer) and can hang.
        if (-not $process.WaitForExit(300000)) {
            Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
            throw "$($installer.name) installer did not finish within 5 minutes and was stopped."
        }
        if ($process.ExitCode -ne 0) {
            throw "$($installer.name) installer returned exit code $($process.ExitCode)."
        }
    }
    catch {
        Write-Warning "$($installer.name) was not installed: $($_.Exception.Message) Continuing with the remaining steps."
    }
    finally {
        Remove-Item -LiteralPath $downloadPath -Force -ErrorAction SilentlyContinue
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
    elseif ((Get-Module -ListAvailable -Name $module.name) -and -not $module.upgrade) {
        Write-Host "Already installed: $($module.name)"
    }
    else {
        Write-Host "Installing/updating module: $($module.name)"
        Install-Module -Name $module.name -Repository PSGallery -Scope CurrentUser -Force -AllowClobber -AcceptLicense -WarningAction SilentlyContinue
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

Write-Step 'Installing Visual Studio Code extensions'
$code = Get-Command code.cmd -ErrorAction SilentlyContinue
if (-not $code) {
    $codePath = Join-Path $env:LOCALAPPDATA 'Programs\Microsoft VS Code\bin\code.cmd'
    if (Test-Path -LiteralPath $codePath) { $code = Get-Command $codePath }
}
foreach ($extension in $config.vscodeExtensions) {
    if (-not $extension.enabled) { continue }
    if ($WhatIf) {
        Write-Host "[WhatIf] Install VS Code extension $($extension.id)"
    }
    elseif (-not $code) {
        Write-Warning 'VS Code command line is not available; skipping extensions.'
        break
    }
    else {
        & $code.Source --install-extension $extension.id --force
        if ($LASTEXITCODE -ne 0) { Write-Warning "Could not install VS Code extension $($extension.id)." }
    }
}

Write-Step 'Applying application settings'
foreach ($setting in $config.appSettings) {
    if (-not $setting.enabled) { continue }
    $processName = $setting.stopProcess
    if ($processName -and -not $WhatIf) {
        Get-Process -Name $processName -ErrorAction SilentlyContinue | Stop-Process -Force
    }
    try { Install-AppSettings -Setting $setting }
    catch { Write-Warning "Could not apply $($setting.name) settings: $($_.Exception.Message) Continuing." }
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

if ($config.finalPass.enabled) {
    Write-Step 'Final pass: updating PowerShell and modules'

    # Re-check apps flagged for upgrade (PowerShell stable and preview) now that everything else is installed.
    foreach ($app in $config.apps) {
        if (-not $app.enabled -or -not $app.upgrade) { continue }
        if ($WhatIf) {
            Write-Host "[WhatIf] Final upgrade check: $($app.name)"
            continue
        }
        & $winget.Source upgrade --id $app.id --exact --source winget --silent --accept-package-agreements --accept-source-agreements | Out-Null
        switch ($LASTEXITCODE) {
            0 { Write-Host "Upgraded: $($app.name)" }
            -1978335189 { Write-Host "Up to date: $($app.name)" }
            -1978335090 { Write-Warning "$($app.name) needs an uninstall and reinstall (install technology differs); see the earlier warning." }
            default { Write-Warning "Could not confirm the latest $($app.name) (exit code $LASTEXITCODE)." }
        }
    }

    # Modules are installed and updated in fresh processes so nothing is loaded (and locked) by this session.
    $moduleScript = Join-Path ([IO.Path]::GetTempPath()) ([IO.Path]::GetRandomFileName() + '.ps1')
    $moduleNames = (@($config.powershellModules | Where-Object enabled | ForEach-Object name)) -join ','
    $moduleHosts = @()
    $pwshCommand = Get-Command pwsh.exe -ErrorAction SilentlyContinue
    if (-not $pwshCommand -and (Test-Path -LiteralPath "$env:ProgramFiles\PowerShell\7\pwsh.exe")) {
        $pwshCommand = Get-Command "$env:ProgramFiles\PowerShell\7\pwsh.exe"
    }
    if ($pwshCommand) { $moduleHosts += @{ Name = 'PowerShell 7'; Path = $pwshCommand.Source } }
    $moduleHosts += @{ Name = 'Windows PowerShell 5.1'; Path = (Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe') }

    foreach ($moduleHost in $moduleHosts) {
        if ($WhatIf) {
            Write-Host "[WhatIf] Install missing and update installed modules in $($moduleHost.Name)"
            continue
        }
        Set-Content -LiteralPath $moduleScript -Encoding utf8 -Value @'
param([string]$Names)
$ProgressPreference = 'SilentlyContinue'
foreach ($name in ($Names -split ',' | Where-Object { $_ })) {
    if (-not (Get-Module -ListAvailable -Name $name)) {
        try { Install-Module -Name $name -Repository PSGallery -Scope CurrentUser -Force -AllowClobber -AcceptLicense -WarningAction SilentlyContinue -ErrorAction Stop; Write-Host "Installed: $name" }
        catch { Write-Warning "Could not install $name : $($_.Exception.Message)" }
    }
}
foreach ($module in (Get-InstalledModule -ErrorAction SilentlyContinue)) {
    try { Update-Module -Name $module.Name -Force -AcceptLicense -WarningAction SilentlyContinue -ErrorAction Stop; Write-Host "Checked: $($module.Name)" }
    catch { Write-Warning "Could not update $($module.Name): $($_.Exception.Message)" }
}
'@
        Write-Host "Modules in $($moduleHost.Name)"
        & $moduleHost.Path -NoProfile -ExecutionPolicy Bypass -File $moduleScript -Names $moduleNames
    }
    Remove-Item -LiteralPath $moduleScript -Force -ErrorAction SilentlyContinue

    if (-not $WhatIf) {
        # Second check: confirm everything the config asked for is actually present.
        Write-Step 'Verification'
        $missing = [Collections.Generic.List[string]]::new()
        foreach ($app in $config.apps) {
            if (-not $app.enabled) { continue }
            $found = & $winget.Source list --id $app.id --exact --accept-source-agreements 2>$null | Select-String -SimpleMatch $app.id
            if (-not $found) { $missing.Add("App: $($app.name)") }
        }
        foreach ($installer in $config.directInstallers) {
            if ($installer.enabled -and -not (Test-InstalledApplication -DisplayNamePattern $installer.displayNamePattern)) { $missing.Add("App: $($installer.name)") }
        }
        if ($npm) {
            $globalPackages = & $npm.Source ls --global --depth=0 2>$null | Out-String
            foreach ($package in $config.npmPackages) {
                if ($package.enabled -and $globalPackages -notmatch [regex]::Escape($package.id)) { $missing.Add("npm: $($package.name)") }
            }
        }
        foreach ($module in $config.powershellModules) {
            if ($module.enabled -and -not (Get-Module -ListAvailable -Name $module.name)) { $missing.Add("Module: $($module.name)") }
        }
        foreach ($setting in $config.appSettings) {
            if ($setting.enabled -and $setting.destination -and -not (Test-Path -LiteralPath ([Environment]::ExpandEnvironmentVariables($setting.destination)))) {
                $missing.Add("Settings: $($setting.name)")
            }
        }
        if ($missing.Count -eq 0) {
            Write-Host 'Everything in the configuration is installed and applied.' -ForegroundColor Green
        }
        else {
            Write-Warning 'These items are missing; run setup again or check the messages above:'
            $missing | ForEach-Object { Write-Warning "  $_" }
        }
    }
}

Write-Step 'Setup complete'
Write-Host 'Some application or Windows changes may require signing out or restarting.'
foreach ($note in $config.postInstallNotes) {
    Write-Host "REMINDER: $note" -ForegroundColor Yellow
}

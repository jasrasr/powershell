# Revision : 1.4
# Description : Check Microsoft 365 Apps "Current Channel" build on MS Learn.
#               On change: create ODT folder named <version>_<build>, copy setup/config,
#               run ODT download, then mirror to $clesccm\Microsoft\Office 365\<version>_<build>.
# Author : Jason Lamb (with help from ChatGPT)
# Created : 2025-04-15
# Modified : 2025-10-02

[CmdletBinding()]
param(
    [string]$Url = 'https://learn.microsoft.com/en-us/officeupdates/update-history-microsoft365-apps-by-date',
    [string]$ChannelToCheck = 'Current Channel',
    [string]$OutFolder = 'C:\temp\powershell-exports\',
    [switch]$Quiet
)

# Ensure folders exist
if (-not (Test-Path $OutFolder)) { New-Item -Path $OutFolder -ItemType Directory | Out-Null }
$OdtRoot = Join-Path $onedrivepath 'odt'
if (-not (Test-Path $OdtRoot)) { New-Item -Path $OdtRoot -ItemType Directory | Out-Null }

# State file lives with ODT bits
$StateFile = Join-Path $OdtRoot 'm365-currentchannel-build.txt'

# Per-run log with timestamp
$LogFile = Join-Path $OutFolder ("m365-currentchannel-check-{0:yyyyMMdd-HHmmss}.log" -f (Get-Date))

function Write-Log {
    param([string]$Message,[string]$Level = 'INFO')
    $stamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $line = "$stamp [$Level] $Message"
    $line | Tee-Object -FilePath $LogFile -Append | ForEach-Object {
        if (-not $Quiet) { Write-Host $_ }
    }
}

try {
    Write-Log "Downloading page $Url ..."
    $resp = Invoke-WebRequest -Uri $Url -MaximumRedirection 5 -ErrorAction Stop
    $html = ($resp.Content -replace '\s+', ' ')  # normalize whitespace

    # Find row: Channel | Version | Build
    $pattern1 = '<tr[^>]*>\s*<td[^>]*>\s*' + [regex]::Escape($ChannelToCheck) + '\s*</td>\s*<td[^>]*>\s*(?<version>[^<]+?)\s*</td>\s*<td[^>]*>\s*(?<build>\d+(?:\.\d+)+)\s*</td>'
    $m = [regex]::Match($html, $pattern1, 'IgnoreCase')
    if (-not $m.Success) {
        # Sometimes the first cell can be <th>
        $pattern2 = '<tr[^>]*>\s*<(?:td|th)[^>]*>\s*' + [regex]::Escape($ChannelToCheck) + '\s*</(?:td|th)>\s*<td[^>]*>\s*(?<version>[^<]+?)\s*</td>\s*<td[^>]*>\s*(?<build>\d+(?:\.\d+)+)\s*</td>'
        $m = [regex]::Match($html, $pattern2, 'IgnoreCase')
    }

    if (-not $m.Success) {
        throw "Could not locate the '$ChannelToCheck' row with Version and Build"
    }

    $version = $m.Groups['version'].Value.Trim()
    $build   = $m.Groups['build'].Value.Trim()
    $versionBuild = "{0}_{1}" -f $version, $build  # use underscore style everywhere

    Write-Log "Parsed row Channel = $ChannelToCheck , Version = $version , Build = $build ; FolderName = $versionBuild"

    # Load previous build
    $previousBuild = if (Test-Path $StateFile) { (Get-Content $StateFile -ErrorAction SilentlyContinue | Select-Object -First 1).Trim() } else { '' }

    if ([string]::IsNullOrWhiteSpace($previousBuild)) {
        Write-Log "No previous build recorded. Saving $build to $StateFile"
        $build | Set-Content -Path $StateFile -Encoding ASCII
        exit 2
    }

    if ($previousBuild -ne $build) {
        Write-Log "Build changed from $previousBuild to $build 🎉" 'WARN'
        $build | Set-Content -Path $StateFile -Encoding ASCII

        # === ACTIONS ON CHANGE ===
        $targetFolder = Join-Path $OdtRoot $versionBuild
        if (-not (Test-Path $targetFolder)) {
            Write-Log "Creating folder $targetFolder"
            New-Item -Path $targetFolder -ItemType Directory | Out-Null
        }

        # Copy from base ODT folder (not a versioned source)
        $srcSetup = Join-Path $OdtRoot 'setup.exe'
        $srcXml   = Join-Path $OdtRoot 'configuration.xml'

        if (-not (Test-Path $srcSetup)) { throw "Missing $srcSetup . Place Office Deployment Tool 'setup.exe' in $OdtRoot" }
        if (-not (Test-Path $srcXml))   { throw "Missing $srcXml . Place configuration.xml in $OdtRoot" }

        Write-Log "Copying setup.exe and configuration.xml from $OdtRoot to $targetFolder"
        Copy-Item $srcSetup $targetFolder -Force
        Copy-Item $srcXml   $targetFolder -Force

        # Run ODT download
        $setupExe  = Join-Path $targetFolder 'setup.exe'
        $configXml = 'configuration.xml'
        Write-Log "Running ODT download $setupExe /download $configXml"
        Push-Location $targetFolder
        & $setupExe /download $configXml
        $exit = $LASTEXITCODE
        Pop-Location

        if ($exit -ne 0) {
            Write-Log "ODT download returned exit code $exit" 'WARN'
        } else {
            Write-Log "ODT download completed with exit code 0"
        }

        # === MIRROR TO $clesccm\Microsoft\Office 365\<version>_<build> ===
        $officeRoot   = Join-Path $clesccm 'Microsoft\Office 365'
        $officeTarget = Join-Path $officeRoot $versionBuild

        if (-not (Test-Path $officeRoot)) {
            Write-Log "Creating Office root $officeRoot"
            New-Item -Path $officeRoot -ItemType Directory -Force | Out-Null
        }

        Write-Log "Copying to $officeTarget"
        if (-not (Test-Path $officeTarget)) {
            New-Item -Path $officeTarget -ItemType Directory | Out-Null
        }

        $robocopy = "$env:SystemRoot\System32\robocopy.exe"
        if (Test-Path $robocopy) {
            $rcArgs = @($targetFolder, $officeTarget, '/MIR', '/R:2', '/W:2', '/NFL', '/NDL', '/NP', '/NJH', '/NJS')
            Write-Log "Running robocopy $($rcArgs -join ' ')"
            & $robocopy @rcArgs | Out-Null
            $rcExit = $LASTEXITCODE
            if ($rcExit -ge 8) {
                Write-Log "Robocopy failed with exit code $rcExit" 'ERROR'
                throw "Robocopy failure $rcExit to $officeTarget"
            } else {
                Write-Log "Robocopy completed with exit code $rcExit"
            }
        } else {
            Write-Log "Robocopy not found, using Copy-Item fallback"
            Copy-Item -Path (Join-Path $targetFolder '*') -Destination $officeTarget -Recurse -Force
        }

        exit 1
    }
    else {
        Write-Log "No change. Still at $previousBuild."
        exit 0
    }
}
catch {
    Write-Log "Error $($_.Exception.Message)" 'ERROR'
    if (-not $Quiet) { Write-Error $_ }
    exit 9
}

notepad $logfile
# Revision : 1.5.1
# Description : Check Microsoft 365 Apps "Current Channel" build on MS Learn.
#               On change: create ODT folder named <version>_<build>, copy setup/config,
#               run ODT download, then mirror to $clesccm\Microsoft\Office 365\<version>_<build>.
#               -Force: Download on first run (fresh folder). Cleanup removes builds older than -RetentionDays.
# Author : Jason Lamb (with help from ChatGPT and Claude)
# Created : 2025-04-15
# Modified : 2026-10-12

[CmdletBinding()]
param(
    [string]$Url = 'https://learn.microsoft.com/en-us/officeupdates/update-history-microsoft365-apps-by-date',
    [string]$ChannelToCheck = 'Current Channel',
    [string]$OutFolder = $psexports,
    [switch]$Quiet,
    [switch]$Force,
    [ValidateRange(1, 36500)]
    [int]$RetentionDays = 90
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

function Invoke-Cleanup {
    param([int]$DaysToKeep, [string]$CurrentFolder)
    $cutoffDate = (Get-Date).AddDays(-$DaysToKeep)
    $removed = @()

    Write-Log "Cleanup: Removing builds older than $DaysToKeep days (before $($cutoffDate.ToString('yyyy-MM-dd')))"

    # Cleanup local ODT folder
    if (Test-Path $OdtRoot) {
        $localFolders = Get-ChildItem -LiteralPath $OdtRoot -Directory | Where-Object { $_.Name -match '^\d+\.\d+_\d+(?:\.\d+)*$' -and $_.Name -ne $CurrentFolder }
        foreach ($folder in $localFolders) {
            if ($folder.LastWriteTime -lt $cutoffDate) {
                Write-Log "Removing local folder: $($folder.FullName)"
                Remove-Item -LiteralPath $folder.FullName -Recurse -Force -ErrorAction Stop
                $removed += $folder.Name
            }
        }
    }

    # Cleanup CCM mirror
    $officeRoot = Join-Path $clesccm 'Microsoft\Office 365'
    if (Test-Path $officeRoot) {
        $ccmFolders = Get-ChildItem -LiteralPath $officeRoot -Directory | Where-Object { $_.Name -match '^\d+\.\d+_\d+(?:\.\d+)*$' -and $_.Name -ne $CurrentFolder }
        foreach ($folder in $ccmFolders) {
            if ($folder.LastWriteTime -lt $cutoffDate) {
                Write-Log "Removing CCM folder: $($folder.FullName)"
                Remove-Item -LiteralPath $folder.FullName -Recurse -Force -ErrorAction Stop
                $removed += $folder.Name
            }
        }
    }

    if ($removed.Count -gt 0) {
        Write-Log "Cleanup complete: Removed $($removed.Count) build(s) - $($removed -join ', ')" 'INFO'
    } else {
        Write-Log "Cleanup: No builds older than $DaysToKeep days found"
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
    $previousBuild = if (Test-Path -LiteralPath $StateFile) { ([string](Get-Content -LiteralPath $StateFile -ErrorAction Stop | Select-Object -First 1)).Trim() } else { '' }

    if ([string]::IsNullOrWhiteSpace($previousBuild)) {
        if (-not $Force) {
            Write-Log "No previous build recorded. Saving baseline $build; use -Force to download this build."
            $build | Set-Content -Path $StateFile -Encoding ASCII
            exit 2
        }
        Write-Log "No previous build recorded. -Force flag set, proceeding with download of $build"
    }

    if ($Force -or $previousBuild -ne $build) {
        Write-Log "Downloading build $build (previous: $previousBuild; Force: $Force)"

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
        Copy-Item $srcSetup $targetFolder -Force -ErrorAction Stop
        Copy-Item $srcXml   $targetFolder -Force -ErrorAction Stop

        # Run ODT download
        $setupExe  = Join-Path $targetFolder 'setup.exe'
        $configXml = 'configuration.xml'
        Write-Log "Running ODT download $setupExe /download $configXml"
        Push-Location $targetFolder -ErrorAction Stop
        try {
            & $setupExe /download $configXml
            $exit = $LASTEXITCODE
        }
        finally {
            Pop-Location
        }

        if ($exit -ne 0) {
            throw "ODT download failed with exit code $exit"
        } else {
            Write-Log "ODT download completed with exit code 0"
        }

        # Copy downloaded content to the CCM destination before recording success.
        $officeRoot = Join-Path $clesccm 'Microsoft\Office 365'
        $officeTarget = Join-Path $officeRoot $versionBuild
        New-Item -Path $officeTarget -ItemType Directory -Force -ErrorAction Stop | Out-Null
        Write-Log "Copying to $officeTarget"
        $robocopy = Join-Path $env:SystemRoot 'System32\robocopy.exe'
        if (Test-Path -LiteralPath $robocopy) {
            $rcArgs = @($targetFolder, $officeTarget, '/E', '/R:2', '/W:2', '/NFL', '/NDL', '/NP', '/NJH', '/NJS')
            & $robocopy @rcArgs | Out-Null
            $rcExit = $LASTEXITCODE
            if ($rcExit -ge 8) { throw "Robocopy failed with exit code $rcExit to $officeTarget" }
            Write-Log "Robocopy completed with exit code $rcExit"
        }
        else {
            Copy-Item -Path (Join-Path $targetFolder '*') -Destination $officeTarget -Recurse -Force -ErrorAction Stop
        }

        $build | Set-Content -LiteralPath $StateFile -Encoding ASCII -ErrorAction Stop
        Invoke-Cleanup -DaysToKeep $RetentionDays -CurrentFolder $versionBuild
        exit 1

    }
    else {
        Write-Log "No change. Still at $previousBuild."
        Invoke-Cleanup -DaysToKeep $RetentionDays -CurrentFolder $versionBuild
        exit 0
    }
}
catch {
    Write-Log "Error $($_.Exception.Message)" 'ERROR'
    if (-not $Quiet) { Write-Error $_ }
    exit 9
}

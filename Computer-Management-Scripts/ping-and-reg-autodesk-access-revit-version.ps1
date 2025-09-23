# Revision : 1.7
# Description : Query Autodesk Access and all Revit 2026 components (incl. FormIt Converter), return full table: Computer, RegistryPath, Publisher, DisplayVersion, DisplayName, InstallDate; run local when host matches; log to C:\temp\powershell-exports\  [Rev 1.7]
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-09-18
# Modified Date : 2025-09-18

# -------------------------
# Config / Inputs
# -------------------------
$computerstoping = @(
    'CLEW112GFF814'
)

# Ensure output folder exists
$null = New-Item -Path 'C:\temp\powershell-exports' -ItemType Directory -Force -ErrorAction SilentlyContinue

# Timestamped output file
$filePath = "C:\temp\powershell-exports\AutodeskInstalledApplications-$((Get-Date).ToString('yyyy-MM-dd-HH-mm-ss')).txt"

# Registry hives to check
$regHives = @(
  'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',
  'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall',
  'HKLM:\SOFTWARE\Autodesk\UPI2'
)

# Match rule: include Autodesk Access AND anything that mentions "Revit 2026" (captures FormIt Converter for Revit 2026, etc.)
$matchScriptBlock = {
    param($name)
    if (-not $name) { return $false }
    return ($name -eq 'Autodesk Access') -or ($name -match 'Revit 2026')
}

# -------------------------
# Helpers
# -------------------------
function Get-FirstPresentValue {
    param(
        [object]$Entry,
        [string[]]$PropertyNames
    )
    foreach ($p in $PropertyNames) {
        if ($Entry.PSObject.Properties.Name -contains $p) {
            $v = $Entry.$p
            if ($null -ne $v -and ($v -isnot [string] -or $v.Trim() -ne '')) {
                return $v
            }
        }
    }
    return $null
}

function Convert-EntryToResultObject {
    param($entry)

    $name = Get-FirstPresentValue -Entry $entry -PropertyNames @('DisplayName','ProductName','Name','Title')

    $publisher = Get-FirstPresentValue -Entry $entry -PropertyNames @('Publisher','Vendor','Manufacturer','Company')

    $version = Get-FirstPresentValue -Entry $entry -PropertyNames @('DisplayVersion','ProductVersion','Version','VersionString')

    $installDateStr = $null
    $rawDate = Get-FirstPresentValue -Entry $entry -PropertyNames @('InstallDate','InstallDateUTC','Installed','InstallTime')
    if ($rawDate) {
        if ($rawDate -is [datetime]) {
            $installDateStr = $rawDate.ToString('yyyy-MM-dd')
        }
        elseif ($rawDate -is [string] -and $rawDate -match '^\d{8}$') {
            try { $installDateStr = [datetime]::ParseExact($rawDate, 'yyyyMMdd', $null).ToString('yyyy-MM-dd') } catch { $installDateStr = $null }
        }
        else {
            try { $installDateStr = ([datetime]$rawDate).ToString('yyyy-MM-dd') } catch { $installDateStr = $null }
        }
    }

    [pscustomobject]@{
        Computer       = $env:COMPUTERNAME
        RegistryPath   = ($entry.PSPath -replace '^Microsoft\.PowerShell\.Core\\Registry::','')
        Publisher      = $publisher
        DisplayVersion = $version
        DisplayName    = $name
        InstallDate    = $installDateStr
    }
}

function Get-Installed-AutodeskTargets {
    param(
        [string[]] $Hives,
        [scriptblock] $NameMatcher
    )
    foreach ($hive in $Hives) {
        if (Test-Path $hive) {
            Get-ChildItem -Path $hive -ErrorAction SilentlyContinue |
            Get-ItemProperty -ErrorAction SilentlyContinue |
            ForEach-Object {
                $tmpName = Get-FirstPresentValue -Entry $_ -PropertyNames @('DisplayName','ProductName','Name','Title')
                if (& $NameMatcher $tmpName) {
                    Convert-EntryToResultObject -entry $_
                }
            }
        }
    }
}

# -------------------------
# Main : Iterate computers
# -------------------------
$results = foreach ($computer in $computerstoping) {

    if ($computer -ieq $env:COMPUTERNAME) {
        try {
            Get-Installed-AutodeskTargets -Hives $regHives -NameMatcher $matchScriptBlock
        } catch {
            Write-Host "$computer : Error during local query $_"
        }
        continue
    }

    if (Test-Connection -ComputerName $computer -Count 1 -Quiet) {
        try {
            Invoke-Command -ComputerName $computer -ScriptBlock {
                param($regHives, $matchBlock)

                function Get-FirstPresentValue {
                    param([object]$Entry,[string[]]$PropertyNames)
                    foreach ($p in $PropertyNames) {
                        if ($Entry.PSObject.Properties.Name -contains $p) {
                            $v = $Entry.$p
                            if ($null -ne $v -and ($v -isnot [string] -or $v.Trim() -ne '')) { return $v }
                        }
                    }
                    return $null
                }

                function Convert-EntryToResultObject {
                    param($entry)
                    $name      = Get-FirstPresentValue -Entry $entry -PropertyNames @('DisplayName','ProductName','Name','Title')
                    $publisher = Get-FirstPresentValue -Entry $entry -PropertyNames @('Publisher','Vendor','Manufacturer','Company')
                    $version   = Get-FirstPresentValue -Entry $entry -PropertyNames @('DisplayVersion','ProductVersion','Version','VersionString')

                    $installDateStr = $null
                    $rawDate = Get-FirstPresentValue -Entry $entry -PropertyNames @('InstallDate','InstallDateUTC','Installed','InstallTime')
                    if ($rawDate) {
                        if ($rawDate -is [datetime])      { $installDateStr = $rawDate.ToString('yyyy-MM-dd') }
                        elseif ($rawDate -is [string] -and $rawDate -match '^\d{8}$') {
                            try { $installDateStr = [datetime]::ParseExact($rawDate, 'yyyyMMdd', $null).ToString('yyyy-MM-dd') } catch { $installDateStr = $null }
                        } else {
                            try { $installDateStr = ([datetime]$rawDate).ToString('yyyy-MM-dd') } catch { $installDateStr = $null }
                        }
                    }

                    [pscustomobject]@{
                        Computer       = $env:COMPUTERNAME
                        RegistryPath   = ($entry.PSPath -replace '^Microsoft\.PowerShell\.Core\\Registry::','')
                        Publisher      = $publisher
                        DisplayVersion = $version
                        DisplayName    = $name
                        InstallDate    = $installDateStr
                    }
                }

                function Get-Installed-AutodeskTargets {
                    param([string[]] $Hives,[scriptblock] $NameMatcher)
                    foreach ($hive in $Hives) {
                        if (Test-Path $hive) {
                            Get-ChildItem -Path $hive -ErrorAction SilentlyContinue |
                            Get-ItemProperty -ErrorAction SilentlyContinue |
                            ForEach-Object {
                                $tmpName = Get-FirstPresentValue -Entry $_ -PropertyNames @('DisplayName','ProductName','Name','Title')
                                if (& $NameMatcher $tmpName) {
                                    Convert-EntryToResultObject -entry $_
                                }
                            }
                        }
                    }
                }

                Get-Installed-AutodeskTargets -Hives $regHives -NameMatcher $matchBlock
            } -ArgumentList $regHives, $matchScriptBlock
        } catch {
            Write-Host "$computer : Error querying registry $_"
        }
    } else {
        Write-Host "$computer : Not Found"
    }
}

Write-Host "Autodesk Access and Revit 2026 check complete."

# Force a consistent table with all columns (even if some are null)
$ordered = $results | Select-Object Computer, RegistryPath, Publisher, DisplayVersion, DisplayName, InstallDate

# Console table
$ordered | Format-Table -AutoSize

# Save the same table into the file
$ordered | Format-Table -AutoSize | Out-String | Set-Content -Path $filePath

# Verify file (and open when created)
if (Test-Path $filePath) {
    Write-Host "The file was created successfully : $filePath"
    Invoke-Item -Path $filePath
} else {
    Write-Host "Failed to create the file : $filePath"
}

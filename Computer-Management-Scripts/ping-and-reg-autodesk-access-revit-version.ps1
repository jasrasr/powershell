# Revision : 1.6
# Description : Query Autodesk Access and all Revit 2026 components (incl. FormIt Converter), show Publisher/Version/Name/InstallDate + RegistryPath; runs local when target == host; logs to C:\temp\powershell-exports\  [Rev 1.6]
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

# Match rule: include Autodesk Access AND anything that mentions "Revit 2026" (restores items like "FormIt Converter for Revit 2026")
$matchScriptBlock = {
    param($name)
    if (-not $name) { return $false }
    return ($name -eq 'Autodesk Access') -or ($name -match 'Revit 2026')
}

# -------------------------
# Helper : Normalize a single registry entry to a PSObject with desired fields
# -------------------------
function Convert-EntryToResultObject {
    param($entry)

    # Name: prefer DisplayName, then ProductName
    $name = $entry.DisplayName
    if (-not $name -and $entry.PSObject.Properties.Name -contains 'ProductName') {
        $name = $entry.ProductName
    }

    # Publisher: prefer Publisher, then Vendor, then Manufacturer
    $publisher = $entry.Publisher
    if (-not $publisher -and $entry.PSObject.Properties.Name -contains 'Vendor') {
        $publisher = $entry.Vendor
    }
    if (-not $publisher -and $entry.PSObject.Properties.Name -contains 'Manufacturer') {
        $publisher = $entry.Manufacturer
    }

    # Version: prefer DisplayVersion, then ProductVersion, then Version
    $version = $entry.DisplayVersion
    if (-not $version -and $entry.PSObject.Properties.Name -contains 'ProductVersion') {
        $version = $entry.ProductVersion
    }
    if (-not $version -and $entry.PSObject.Properties.Name -contains 'Version') {
        $version = $entry.Version
    }

    # InstallDate: handle 'yyyyMMdd', ISO, DateTime, or anything parseable
    $installDateStr = $null
    $rawDate = $entry.InstallDate
    if ($rawDate) {
        if ($rawDate -is [datetime]) {
            $installDateStr = $rawDate.ToString('yyyy-MM-dd')
        }
        elseif ($rawDate -match '^\d{8}$') {
            try { $installDateStr = [datetime]::ParseExact($rawDate, 'yyyyMMdd', $null).ToString('yyyy-MM-dd') } catch { $installDateStr = $null }
        }
        else {
            try { $installDateStr = [datetime]$rawDate | ForEach-Object { $_.ToString('yyyy-MM-dd') } } catch { $installDateStr = $null }
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

# -------------------------
# Helper : Core query logic (local machine)
# -------------------------
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
                # Get name using same logic as converter
                $tmpName = $_.DisplayName
                if (-not $tmpName -and $_.PSObject.Properties.Name -contains 'ProductName') {
                    $tmpName = $_.ProductName
                }

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

    # If target is the current machine, run locally to avoid remoting
    if ($computer -ieq $env:COMPUTERNAME) {
        try {
            Get-Installed-AutodeskTargets -Hives $regHives -NameMatcher $matchScriptBlock
        } catch {
            Write-Host "$computer : Error during local query $_"
        }
        continue
    }

    # Else remote
    if (Test-Connection -ComputerName $computer -Count 1 -Quiet) {
        try {
            Invoke-Command -ComputerName $computer -ScriptBlock {
                param($regHives, $matchBlock)

                function Convert-EntryToResultObject {
                    param($entry)
                    $name = $entry.DisplayName
                    if (-not $name -and $entry.PSObject.Properties.Name -contains 'ProductName') {
                        $name = $entry.ProductName
                    }

                    $publisher = $entry.Publisher
                    if (-not $publisher -and $entry.PSObject.Properties.Name -contains 'Vendor') {
                        $publisher = $entry.Vendor
                    }
                    if (-not $publisher -and $entry.PSObject.Properties.Name -contains 'Manufacturer') {
                        $publisher = $entry.Manufacturer
                    }

                    $version = $entry.DisplayVersion
                    if (-not $version -and $entry.PSObject.Properties.Name -contains 'ProductVersion') {
                        $version = $entry.ProductVersion
                    }
                    if (-not $version -and $entry.PSObject.Properties.Name -contains 'Version') {
                        $version = $entry.Version
                    }

                    $installDateStr = $null
                    $rawDate = $entry.InstallDate
                    if ($rawDate) {
                        if ($rawDate -is [datetime]) {
                            $installDateStr = $rawDate.ToString('yyyy-MM-dd')
                        }
                        elseif ($rawDate -match '^\d{8}$') {
                            try { $installDateStr = [datetime]::ParseExact($rawDate, 'yyyyMMdd', $null).ToString('yyyy-MM-dd') } catch { $installDateStr = $null }
                        }
                        else {
                            try { $installDateStr = [datetime]$rawDate | ForEach-Object { $_.ToString('yyyy-MM-dd') } } catch { $installDateStr = $null }
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
                    param([string[]] $Hives, [scriptblock] $NameMatcher)
                    foreach ($hive in $Hives) {
                        if (Test-Path $hive) {
                            Get-ChildItem -Path $hive -ErrorAction SilentlyContinue |
                            Get-ItemProperty -ErrorAction SilentlyContinue |
                            ForEach-Object {
                                $tmpName = $_.DisplayName
                                if (-not $tmpName -and $_.PSObject.Properties.Name -contains 'ProductName') {
                                    $tmpName = $_.ProductName
                                }

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
            Write-Host "$computer : Error querying registry $_" -ForegroundColor Red
        }
    } else {
        Write-Host "$computer : Not Found" -ForegroundColor Yellow
    }
}

Write-Host "Autodesk Access and Revit 2026 check complete."

# Console output as a table with all fields
$results | Sort-Object Computer, DisplayName | Format-Table -AutoSize Computer, RegistryPath, Publisher, DisplayVersion, DisplayName, InstallDate

# Save the same table into the file
$results | Sort-Object Computer, DisplayName | Format-Table -AutoSize Computer, RegistryPath, Publisher, DisplayVersion, DisplayName, InstallDate | Out-String | Set-Content -Path $filePath

# Verify file (and open when created)
if (Test-Path $filePath) {
    Write-Host "The file was created successfully : $filePath"
    Invoke-Item -Path $filePath
} else {
    Write-Host "Failed to create the file : $filePath"
}

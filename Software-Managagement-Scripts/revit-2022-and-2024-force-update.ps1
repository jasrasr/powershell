# ================================
# CONFIGURATION SECTION
# ================================

# List of target computers
$computers = @(
    "CLEW101RWH382", "CLEW101W5D1J3", "CLEW101Z630J3", "CLEW11208Q6G3",
    "CLEW112GFF814", "TOLW1130GLRV3", "CLEW103LMHFH2", "PITW103TNG0J3",
    "CLEW1040TQLG3", "CLEW104JV26M3", "CHIW114MVD814", "CHIW104T0HQW1",
    "PITW114YYC0J3", "CHIW11550F814", "CLEW105W140J3", "CLEW105YQQLG3",
    "PITW116LTG0J3", "PITW116QVD814", "CLEW1070P4BK3", "CLEW1074FB4J3",
    "NWIW118199GK3", "BUFW1081DB4J3", "NWIW108G0Q2J3", "MADW108JBFGK3",
    "CLEW108K3KFH2", "CHIW1091730J3", "CLEW109KYHRV3", "CLEW119L2F4J3",
    "BUFW109P4Y1J3", "CHIW119ZZD814", "CHIW11B20F814", "PITW11B3ZP5J3",
    "CLEW11B9LQ5J3", "CLEW10BG9JRV3", "CLEW10BKF69K3", "CHIW11BZSQ5J3",
    "PITW10C40F814", "CLEW10C7RQLG3", "BUFW10CPVD814", "CHIW10D0136M3",
    "CLEW11D25D0J3", "CHIW10D4VLNN2", "PITW10D7LLFH2", "MADW11DF4F814",
    "CHIW10DK1BTV3", "PITW11DXPW2J3", "ASHW11F5HH2J3", "CLEW11FR8F814",
    "CHIW10G10PRV3", "PITW10GFQHNN2", "CLEW10GL4F814", "NWIW10GM7Q5J3",
    "TOLW10H6W30J3", "NWIW11HGTG0J3", "CHIW10HP1BTV3", "TOLW10HP8F814",
    "CLEW11HQBD0J3", "CLEW10HW8F814", "CHIW10J3PN1J3", "CLEW10J3VF814",
    "CHIW11J7H20J3", "CHIW10J8W66L3", "PITW10JMSC0J3", "CHIW11JP4D1J3",
    "PITW11JRJG814"
)

# Define build-to-version mapping
$revitBuildMap = @{
    '22.0.2.392'   = '2022.0.0'
    '22.1.10.541'  = '2022.1.1'
    '22.1.21.13'   = '2022.1.2'
    '22.1.30.34'   = '2022.1.3'
    '22.1.50.17'   = '2022.1.5'
    '22.1.60.18'   = '2022.1.6'
    '22.1.70.9'    = '2022.1.7'
    '22.1.80.32'   = '2022.1.8'
    '24.0.5.432'   = '2024'
    '24.1.10.25'   = '2024.1.1'
    '24.1.11.26'   = '2024.1.2'
    '24.2.0.63'    = '2024.2'
    '24.2.10.64'   = '2024.2.1'
    '24.2.20.41'   = '2024.2.2'
    '24.3.0.13'    = '2024.3'
    '24.3.10.22'   = '2024.3.1'
}

# Define latest expected builds
$latest2022 = [version]'22.1.80.32'
$latest2024 = [version]'24.3.10.22'

# Local source folders for updates
$source2022 = "C:\Temp\autodesk\Revit 2022.1.8"
$source2024 = "C:\Temp\autodesk\Revit 2024.3.1"

# CCM cache target (on each remote computer)
$tempfolder = Get-Date -Format 'yyyyMMdd'


# Log file path
$logPath = "C:\temp\Autodesk\check-copy.log"
if (-not (Test-Path "C:\Autodesk")) { New-Item -Path "C:\Autodesk" -ItemType Directory -Force | Out-Null }
New-Item -Path $logPath -ItemType File -Force | Out-Null

# Init global update lists
$global:revitNeedsUpdate2022 = @()
$global:revitNeedsUpdate2024 = @()

# ================================
# STEP 1 – PING COMPUTERS
# ================================
$pingableComputers = @()

$Results = $computers | ForEach-Object -Parallel {
    $Reachable = Test-Connection -ComputerName $_ -Count 1 -Quiet
    if ($Reachable) {
         Write-Host "$_ is pingable"
        $pingableComputers += $_
    } else {
        Write-Host "$_ is not reachable"
    }
    [PSCustomObject]@{
        ComputerName = $_
        Reachable = $Reachable
    }
}

Write-Host "Original Count: $($computers.Count)"
Write-Host "`nTotal pingable computers: $($pingableComputers.Count)`n"

$Results | Format-Table -AutoSize

# ================================
# STEP 2 – CHECK REVIT VERSIONS
# ================================
$computerRevitMap = @{}
$revitVersionResults = @()

foreach ($version in @("2022", "2024")) {
    foreach ($computer in $pingableComputers) {
        $exePath = "\\$computer\C$\Program Files\Autodesk\Revit $version\revit.exe"

        if (Test-Path $exePath) {
            try {
                $file = Get-Item $exePath
                $fileVersion = [version]$file.VersionInfo.FileVersion
                $friendlyVersion = $revitBuildMap[$fileVersion.ToString()]
                if (-not $friendlyVersion) { $friendlyVersion = "Unknown" }

               # Write-Host "$computer Revit $version file version: $fileVersion (Friendly: $friendlyVersion)"

                if ($version -eq "2022" -and $fileVersion -lt $latest2022) {
                    #Write-Host "→ $computer needs 2022 update"
                    $global:revitNeedsUpdate2022 += $computer
                } elseif ($version -eq "2024" -and $fileVersion -lt $latest2024) {
                   # Write-Host "→ $computer needs 2024 update"
                    $global:revitNeedsUpdate2024 += $computer
                }

                if (-not $computerRevitMap.ContainsKey($computer)) {
                    $computerRevitMap[$computer] = @()
                }
                $computerRevitMap[$computer] += $version

                $revitVersionResults += [pscustomobject]@{
                    ComputerName    = $computer
                    RevitYear       = $version
                    FileVersion     = $fileVersion
                    FriendlyVersion = $friendlyVersion
                }

                #Write-Host "$computer has Revit $version (build $fileVersion → $friendlyVersion)"
            }
            catch {
                Write-Host "Error reading version on $computer : $_"
            }
        } else {
            Write-Host "$exePath does NOT exist"
        }
    }
}

# ================================
# STEP 3 – DISPLAY RESULTS
# ================================
Write-Host "`n--- Revit 2022 Needs Update ---"
$revitNeedsUpdate2022 | ForEach-Object { Write-Host $_ }

Write-Host "`n--- Revit 2024 Needs Update ---"
$revitNeedsUpdate2024 | ForEach-Object { Write-Host $_ }

# ================================
# STEP 3.2 – HIGHLIGHT DUAL INSTALLS
# ================================
$alreadyStarred = @{}
$revitVersionResults | Sort-Object ComputerName | ForEach-Object {
    $comp = $_.ComputerName
    $versionsFound = $computerRevitMap[$comp]
    $bothDetected = ($versionsFound.Count -ge 2)

    if ($bothDetected -and -not $alreadyStarred.ContainsKey($comp)) {
        Write-Host "⭐ $comp has both Revit 2022 & 2024" -ForegroundColor Yellow
        $alreadyStarred[$comp] = $true
    }

    Write-Host "$comp - Revit $($_.RevitYear) ($($_.FriendlyVersion))"
}

# ================================
# STEP 4 – COPY UPDATE FILES TO REMOTE
# ================================
function Copy-UpdateToComputers {
    param (
        [string[]]$computers,
        [string]$localSourcePath,
        [string]$revitYear
    )

    $i = 0
    foreach ($computer in $computers) {
        $i++
        $percent = [math]::Round(($i / $computers.Count) * 100, 0)
        Write-Progress -Activity "Copying Revit $revitYear" -Status "$computer ($i of $($computers.Count))" -PercentComplete $percent

        $remoteDest = "\\$computer\C$\Windows\CCMCache\$tempfolder"
        $logEntry = "[$(Get-Date -Format yyyy-MM-dd-HH-mm-ss)] $computer - Revit $revitYear copy: "

        try {
            if (-not (Test-Path $remoteDest)) {
                New-Item -Path $remoteDest -ItemType Directory -Force | Out-Null
            }

            Copy-Item -Path "$localSourcePath\*" -Destination $remoteDest -Recurse -Force
            Write-Host "✅ Copied to $computer"
            "$logEntry SUCCESS" | Out-File -FilePath $logPath -Append
        } catch {
            Write-Host "❌ Failed to copy to $computer : $_"
            "$logEntry FAIL - $_" | Out-File -FilePath $logPath -Append
        }
    }
}

if ($revitNeedsUpdate2022.Count -gt 0) {
    Copy-UpdateToComputers -computers $revitNeedsUpdate2022 -localSourcePath $source2022 -revitYear "2022"
}

if ($revitNeedsUpdate2024.Count -gt 0) {
    Copy-UpdateToComputers -computers $revitNeedsUpdate2024 -localSourcePath $source2024 -revitYear "2024"
}

# ================================
# STEP 5 – CHECK IF REVIT IS RUNNING
# ================================
foreach ($computer in $pingableComputers) {
    try {
        $processCheck = Get-Process -ComputerName $computer -Name "Revit" -ErrorAction SilentlyContinue
        if ($processCheck) {
            Write-Host "⚠️ Revit is currently running on $computer"
        }
    } catch {
        Write-Host "Unable to check Revit process on $computer : $_"
    }
}

# ================================
# STEP 6 – INSTALLATION FUNCTION
# ================================
function Install-RevitUpdate {
    param (
        [string]$computer,
        [string]$revitYear
    )

    $installPath = "\\$computer\$remoteCachePath"
    $logEntry = "[$(Get-Date -Format yyyy-MM-dd-HH-mm-ss)] $computer - Revit $revitYear install: "

    try {
        if (-not (Test-Path "$installPath\Setup.exe")) {
            Write-Host "❌ Install files missing on $computer"
            "$logEntry FAIL - Missing setup files" | Out-File -FilePath $logPath -Append
            return
        }

        $jobScript = {
            param($path, $year)
            $process = Get-Process "Revit" -ErrorAction SilentlyContinue
            if ($process) {
                Stop-Process -Name "Revit" -Force
                Start-Sleep -Seconds 5
            }
            Start-Process "$path\Setup.exe" -ArgumentList "-q" -Wait
        }

        $job = Invoke-Command -ComputerName $computer -ScriptBlock $jobScript -ArgumentList $installPath, $revitYear -AsJob
        
        Write-Host "⌛ Started background install on $computer (Job ID: $($job.Id))"
        "$logEntry STARTED" | Out-File -FilePath $logPath -Append
    }
    catch {
        Write-Host "❌ Installation failed on $computer : $_"
        "$logEntry FAIL - $_" | Out-File -FilePath $logPath -Append
    }
}

# ================================
# MODIFIED COPY FUNCTION WITH EXISTENCE CHECK
# ================================
function Copy-UpdateToComputers {
    param (
        [string[]]$computers,
        [string]$localSourcePath,
        [string]$revitYear
    )

    foreach ($computer in $computers) {
        $remoteDest = "\\$computer\$remoteCachePath"
        $logEntry = "[$(Get-Date -Format yyyy-MM-dd-HH-mm-ss)] $computer - Revit $revitYear copy: "

        try {
            if (Test-Path $remoteDest) {
                $existingFiles = Get-ChildItem $remoteDest | Measure-Object | Select-Object -ExpandProperty Count
                if ($existingFiles -gt 10) {  # Basic file count check
                    Write-Host "⏩ Files already exist on $computer"
                    "$logEntry SKIPPED" | Out-File -FilePath $logPath -Append
                    continue
                }
            }

            New-Item -Path $remoteDest -ItemType Directory -Force | Out-Null
            Copy-Item -Path "$localSourcePath\*" -Destination $remoteDest -Recurse -Force
            Write-Host "✅ Copied to $computer"
            "$logEntry SUCCESS" | Out-File -FilePath $logPath -Append
        }
        catch {
            Write-Host "❌ Failed to copy to $computer : $_"
            "$logEntry FAIL - $_" | Out-File -FilePath $logPath -Append
        }
    }
}

# ================================
# MODIFIED INSTALLATION TRIGGER
# ================================
if ($revitNeedsUpdate2022.Count -gt 0) {
    Copy-UpdateToComputers -computers $revitNeedsUpdate2022 -localSourcePath $source2022 -revitYear "2022"
    $revitNeedsUpdate2022 | ForEach-Object {
        Install-RevitUpdate -computer $_ -revitYear "2022"
    }
}

if ($revitNeedsUpdate2024.Count -gt 0) {
    Copy-UpdateToComputers -computers $revitNeedsUpdate2024 -localSourcePath $source2024 -revitYear "2024"
    $revitNeedsUpdate2024 | ForEach-Object {
        Install-RevitUpdate -computer $_ -revitYear "2024"
    }
}



<#

################ TEMP \| ########################

$pingableComputers = @(
'CLEW112GFF814',
'CHIW104T0HQW1',
'CLEW105YQQLG3',
'CLEW109KYHRV3',
'PITW11B3ZP5J3',
'CLEW10BKF69K3',
'CLEW11FR8F814'
)
foreach ($comp in $pingableComputers) {
#Test-Connection -computer $comp -count 1
#Get-ChildItem "\\$comp\c$\windows\ccmcache"
#Invoke-Command -ComputerName $comp -ScriptBlock { hostname }
Invoke-Command -ComputerName $comp -ScriptBlock {
    Test-Path "\\clesccm\Application Source\Cad Applications\Revit 2022 1.8"
}
} 

################ TEMP /\ ########################


#>

<#
# Prompt once
$creds = Get-Credential

# Save securely to disk
$creds | Export-Clixml -Path "$env:USERPROFILE\ps-admin-creds.xml"

# Load saved credential
$creds = Import-Clixml -Path "$env:USERPROFILE\ps-admin-creds.xml"
dir 

# Extract values
$username = $creds.UserName
$password = $creds.GetNetworkCredential().Password

# Connect to the share (session-based, no drive letter)
cmd.exe /c "net use \\clesccm\Application` Source $password /user:$username /persistent:no"

# Test access
Test-Path "\\clesccm\Application Source\Cad Applications\Revit 2022 1.8"

# Optional: Copy
Copy-Item -Path "\\clesccm\Application Source\Cad Applications\Revit 2022 1.8\*" `
          -Destination "C:\Windows\CCMCache\Revit2022" -Recurse -Force

# Clean up the session
#cmd.exe /c "net use \\clesccm\Application` Source /delete"
#>
<#
start-job -name 'revit-2022.1.8 actual' -scriptblock {
    copy-item '\\clesccm\e$\Application Source\Cad Applications\Revit 2022 1.8' 'c:\temp\autodesk' -recurse -force
}

c:\temp\autodesk\revit 2022 1.8
#>
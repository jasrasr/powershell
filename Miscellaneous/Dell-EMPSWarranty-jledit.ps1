function Get-DellWarrantyInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [string]$ServiceTag,
        [Parameter(Mandatory=$false)]
        [string]$CSVImportPath,
        [Parameter(Mandatory=$false)]
        [string]$CMConnectionStringHost,
        [Parameter(Mandatory=$false)]
        [string]$CMConnectionStringDBName,
        [Parameter(Mandatory=$false)]
        [string]$WorkingDir = "$PSScriptRoot\DellWarranty",  # <-- Change this if needed
        [Parameter(Mandatory=$false)]
        [switch]$Cleanup
    )

    # Create working dir if it doesn't exist
    if (-not (Test-Path $WorkingDir)) { New-Item -ItemType Directory -Path $WorkingDir | Out-Null }

    $ExportPath  = "$WorkingDir\WarrantyExport.csv"
    $RedirectPath = "$WorkingDir\WarrantyExport.txt"
    $CSVPath     = "$WorkingDir\ServiceTag.csv"
    $ScratchDir  = "$WorkingDir\Installer"
    $DellWarrantyCLIPath = "C:\Program Files (x86)\Dell\CommandIntegrationSuite\DellWarranty-CLI.exe"

    function Get-InstalledApps {
        $regpath = @(
            'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
            'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
        )
        Get-ItemProperty $regpath | .{process{if($_.DisplayName -and $_.UninstallString) { $_ } }} |
            Select-Object DisplayName, Publisher, InstallDate, DisplayVersion, UninstallString |
            Sort-Object DisplayName
    }

    function Install-CommandIntegrationSuite {
        if (-not (Test-Path $ScratchDir)) { New-Item -ItemType Directory -Path $ScratchDir | Out-Null }

        $DCIS = Get-InstalledApps | Where-Object { $_.DisplayName -match "Integration Suite for System Center" }
        [Version]$OldVersion = '6.6.0.9'

        if ($null -ne $DCIS -and [Version]$DCIS.DisplayVersion -le $OldVersion) {
            Write-Verbose "Removing old version first"
            $UninstallString = $DCIS.UninstallString.Replace("MsiExec.exe /I", '/uninstall ')
            Start-Process -FilePath msiexec.exe -ArgumentList "$UninstallString /qb!" -Wait
        }

        if (-not (Test-Path $DellWarrantyCLIPath)) {
            $DCWarrURL  = 'https://dl.dell.com/FOLDER12964322M/1/Dell-Command-Integration-Suite-for-System-Center_5FT6F_WIN64_6.6.1_A00.EXE'
            $EXEName    = $DCWarrURL.Split("/")[-1]
            $DCWarrPath = "$ScratchDir\$EXEName"

            Write-Verbose "Downloading Dell Command Integration Suite..."
            Start-BitsTransfer -Source $DCWarrURL -Destination $DCWarrPath -CustomHeaders "User-Agent:BITS 42"

            Write-Verbose "Installing..."
            Start-Process -FilePath $DCWarrPath -ArgumentList "/S /E=$ScratchDir" -Wait -NoNewWindow
            $DCWarrMSI = Get-ChildItem -Path $ScratchDir -Filter 'DCIS*.exe' |
                         Select-Object -ExpandProperty FullName | Select-Object -Last 1
            Start-Process -FilePath $DCWarrMSI -ArgumentList "/S /V/qn" -Wait -NoNewWindow
        }
    }

    # Determine service tag source
    if (-not $ServiceTag -and -not $CSVImportPath -and -not $CMConnectionStringHost) {
        $Manf = Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -ExpandProperty Manufacturer
        if ($Manf -match "Dell") {
            $ServiceTag = (Get-CimInstance -ClassName Win32_BIOS).SerialNumber
        } else {
            Write-Host "Not a Dell system. Pass a -ServiceTag value." -ForegroundColor Red
            return
        }
    }

    # CM source
    if ($CMConnectionStringHost -and $CMConnectionStringDBName) {
        Install-CommandIntegrationSuite
        $CLI = Start-Process -FilePath $DellWarrantyCLIPath `
            -ArgumentList "/Ics=`"Data Source=$CMConnectionStringHost;Database=$CMConnectionStringDBName;Integrated Security=true;`" /E=$ExportPath" `
            -Wait -WindowStyle Hidden -PassThru
        return Get-Content -Path $ExportPath | ConvertFrom-Csv
    }

    # CSV source
    if ($CSVImportPath) {
        Install-CommandIntegrationSuite
        $CLI = Start-Process -FilePath $DellWarrantyCLIPath `
            -ArgumentList "/I=$CSVImportPath /E=$ExportPath" `
            -Wait -WindowStyle Hidden -PassThru
        return Get-Content -Path $ExportPath | ConvertFrom-Csv
    }

    # Single service tag
    $ServiceTag | Out-File -FilePath $CSVPath -Encoding utf8 -Force
    Install-CommandIntegrationSuite

    $CLI = Start-Process -FilePath $DellWarrantyCLIPath `
        -ArgumentList "/I=$CSVPath /E=$ExportPath" `
        -Wait -WindowStyle Hidden -PassThru -RedirectStandardOutput $RedirectPath

    $Data = Get-Content -Path $ExportPath -ErrorAction SilentlyContinue | ConvertFrom-Csv
    if ($null -eq $Data) {
        Write-Host "!! No Warranty Information Found !!" -ForegroundColor Yellow
        Get-Content -Path $RedirectPath -ErrorAction SilentlyContinue
    }

    if ($Cleanup) {
        $DCWarrMSI = Get-ChildItem -Path $ScratchDir -Filter 'DCIS*.exe' -ErrorAction SilentlyContinue |
                     Select-Object -ExpandProperty FullName | Select-Object -Last 1
        if ($DCWarrMSI) { Start-Process -FilePath $DCWarrMSI -ArgumentList "/s /V/qn /x" -Wait -NoNewWindow }
    }

    return $Data
}
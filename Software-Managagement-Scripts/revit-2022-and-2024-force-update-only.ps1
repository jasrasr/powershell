# Array of target computers
$computers = @(
    'CHIW104T0HQW1',
    'CHIW10DK1BTV3',
    'CLEW105YQQLG3',
    'CLEW109KYHRV3',
    'CLEW10BKF69K3',
    'CLEW112GFF814',
    'CLEW11FR8F814',
    'PITW11B3ZP5J3'
)
foreach ($computer in $computers) {
    if (Test-Connection -ComputerName $computer -Count 1 -Quiet) {
        Write-Host "✅ $computer is reachable."
        Get-ChildItem "\\$computer\c$\windows\ccmcache\20250329"
    } else {
        Write-Host "❌ $computer is not reachable."
    }
}

# Log file path
$logPath = "C:\Temp\Autodesk\revit-install.txt"
if (-not (Test-Path "C:\Temp\Autodesk")) { 
    New-Item -Path "C:\Temp\Autodesk" -ItemType Directory -Force | Out-Null 
}
New-Item -Path $logPath -ItemType File -Force | Out-Null

# Function to silently install executables
function Install-Silent {
    param (
        [string]$folderPath
    )

    # Get all .exe files in the folder
    $exeFiles = Get-ChildItem -Path $folderPath -Filter "*.exe" -File

    foreach ($exe in $exeFiles) {
        $logEntry = "[$(Get-Date -Format yyyy-MM-dd-HH-mm-ss)] Installing: $($exe.FullName)"
        Write-Host "Installing: $($exe.FullName)"
        "$logEntry" | Out-File -FilePath $logPath -Append

        try {
            # Start the silent installation process
            Start-Process -FilePath $exe.FullName -ArgumentList "-q" -Wait -NoNewWindow
            Write-Host "✅ Successfully installed: $($exe.FullName)"
            "$logEntry SUCCESS" | Out-File -FilePath $logPath -Append
        } catch {
            Write-Host "❌ Failed to install: $($exe.FullName). Error: $_"
            "$logEntry FAIL - $_" | Out-File -FilePath $logPath -Append
        }
    }
}

# Iterate through each computer
foreach ($computer in $computers) {
    $targetFolder = "$computer\c$\windows\ccmcache\20250329"
    
    if (Test-Path $targetFolder) {
        Write-Host "Processing computer: $computer"
        Install-Silent -folderPath $targetFolder
    } else {
        Write-Host "Folder not found on $computer"
        "[$(Get-Date -Format yyyy-MM-dd-HH-mm-ss)] Folder missing: $targetFolder" | Out-File -FilePath $logPath -Append
    }
}

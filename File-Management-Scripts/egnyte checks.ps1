# Variables

$sourceFile = "\\clesccm\Application Source\Accessories\Egnyte\*"x`
$destinationFile = "C:\temp\Egnyte\" 
$destinationFolder = "C:\temp\Egnyte\"
$programName = "Revit"





# Ensure the destination folder exists
if (-Not (Test-Path -Path $destinationFolder)) {
    Write-Host "Destination folder does not exist. Creating it now..."
    New-Item -Path $destinationFolder -ItemType Directory -Force | Out-Null
}

# Main Script
if (-Not (Check-RegistryKeys -Keys $registryKeys)) {
    Write-Host "Proceeding with update process..."

    # Check if the first file exists in the destination
    if (-Not (Test-Path -Path $destinationFile)) {
        Write-Host "File1 not found in destination. Copying update file..."
        Copy-Item -Path $sourceFile -Destination $destinationFile -Force
    } else {
        Write-Host "File1 already exists in destination. Skipping copy."
    }

    # Check if the second file exists in the destination
    if (-Not (Test-Path -Path $destinationFile2)) {
        Write-Host "File2 not found in destination. Copying update file..."
        Copy-Item -Path $sourceFile2 -Destination $destinationFile2 -Force
    } else {
        Write-Host "File2 already exists in destination. Skipping copy."
    }

    # Check if any Revit process is running
    $process = Get-Process | Where-Object { $_.Name -like "*$programName*" } -ErrorAction SilentlyContinue
    if ($process) {
        Write-Host "Revit process is running. It would be stopped here."
        # $process | Stop-Process -Force
        # Start-Sleep -Seconds 3
    } else {
        Write-Host "No Revit process is running."
    }

    # Run the update file (commented out for now)
    Write-Host "Update would be started here."
    # Start-Process -FilePath $destinationFile -Wait

    Write-Host "Update process evaluation complete."
    # Remove-Item -Path $destinationFile -Force
} else {
    Write-Host "One or more registry keys found. No update required."
}

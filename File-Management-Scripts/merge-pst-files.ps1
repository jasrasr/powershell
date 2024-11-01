# Define source folder containing PST files and the destination PST file path
$sourceFolder = "C:\Path\To\Your\PST\Files"  # Replace with the actual path
$destinationPST = "C:\Path\To\Your\Destination\merged.pst"  # Replace with the desired path for merged PST

# Open Outlook
$outlook = New-Object -ComObject Outlook.Application
$namespace = $outlook.GetNamespace("MAPI")

# Check if the destination PST already exists, and if not, create it
if (-not (Test-Path $destinationPST)) {
    Write-Output "Creating new PST file for merged data: $destinationPST"
    $namespace.AddStore($destinationPST)
}

# Load the destination PST into Outlook
$destinationStore = $namespace.Folders | Where-Object { $_.FilePath -eq $destinationPST }
if (-not $destinationStore) {
    Write-Output "Loading destination PST into Outlook"
    $destinationStore = $namespace.AddStore($destinationPST)
}

# Enumerate each PST file in the source folder
foreach ($pstFile in Get-ChildItem -Path $sourceFolder -Filter "*.pst") {
    Write-Output "Processing PST file: $($pstFile.FullName)"
    
    # Open the PST file in Outlook
    $namespace.AddStore($pstFile.FullName)
    $sourceStore = $namespace.Folders | Where-Object { $_.FilePath -eq $pstFile.FullName }
    
    # Copy all folders from the source PST to the destination PST
    foreach ($folder in $sourceStore.Folders) {
        Write-Output "Copying folder: $($folder.Name)"
        $destinationFolder = $destinationStore.Folders | Where-Object { $_.Name -eq $folder.Name }
        
        if (-not $destinationFolder) {
            $destinationFolder = $destinationStore.Folders.Add($folder.Name, $folder.DefaultItemType)
        }
        
        # Copy all items from each folder
        foreach ($item in $folder.Items) {
            $item.Copy().MoveTo($destinationFolder)
        }
    }

    # Close the source PST after copying is complete
    $namespace.RemoveStore($sourceStore)
}

# Clean up and close Outlook
$outlook.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($outlook)
Remove-Variable outlook
Write-Output "PST files merged successfully into $destinationPST"

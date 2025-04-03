# Define the base registry path
$BaseRegPath = "HKLM:\SOFTWARE\Autodesk\UPI2"

# Check if the base registry path exists
if (Test-Path $BaseRegPath) {
    # Get all subkeys
    $SubKeys = Get-ChildItem -Path $BaseRegPath

    # Create an array to store results
    $Results = @()

    # Loop through each subkey
    foreach ($SubKey in $SubKeys) {
        $SubKeyPath = $SubKey.PSPath

        # Get the registry values from the subkey
        $RegValues = Get-ItemProperty -Path $SubKeyPath -ErrorAction SilentlyContinue

        if ($RegValues) {
            # Store values in a custom object
            $Results += [PSCustomObject]@{
                ProductName  = $RegValues.ProductName
                BuildNumber  = $RegValues.BuildNumber
                Release      = $RegValues.Release
                SubKey       = $SubKey.PSChildName
            }
        }
    }

    # Display output in table format
    $Results | Format-Table -AutoSize

    # Export results to CSV
    $Results | Export-Csv -Path "C:\temp\Autodesk_UPI2_Subkeys_Export.csv" -NoTypeInformation

    Write-Host "Exported to C:\temp\Autodesk_UPI2_Subkeys_Export.csv"
} else {
    Write-Host "Registry path not found: $BaseRegPath"
}

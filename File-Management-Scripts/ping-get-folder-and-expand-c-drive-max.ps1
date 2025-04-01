# Define the list of computers
$computers = @('nerdio0924-2d07', 'nerdio0924-3511', 'nerdio0924-6af1',  'nerdio0924-be0c', 'nerdio0924-debe'  )  # Replace with actual computer names

<#
foreach ($computer in $computers) {
    # Ping the computer
    $ping = Test-Connection -ComputerName $computer -Count 1 -Quiet
    #Test-Connection -ComputerName $computer -Count 1 -Quiet

    if ($ping) {
        # If the ping is successful, run Get-ChildItem on C:\temp
        try {
            Invoke-Command -ComputerName $computer -ScriptBlock {
                # Get the list of files in C:\temp
                Get-ChildItem -Path C:\temp
             <#
                # get the disk space
$diskSpace = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'" | Select-Object Size, FreeSpace
# Convert disk space to GB
$diskSpaceGB = [PSCustomObject]@{
    SizeGB      = [math]::Round($diskSpace.Size / 1GB, 2)
    FreeSpaceGB = [math]::Round($diskSpace.FreeSpace / 1GB, 2)
}

# Display the disk space in GB
$diskSpaceGB | Format-Table -AutoSize -Wrap
#>
            } -ErrorAction Stop
        }
        catch {
            # Handle errors during remote execution
            Write-Host "Error occurred on $computer : $_"
        }
    }
    else {
        # If the ping fails, output a message
        Write-Host "$computer is not reachable."
    }
    #>
}



# Run the command on each computer
Invoke-Command -ComputerName $computers -ScriptBlock {
    # Import the Storage module (if needed)
    #Import-Module Storage
    
    try {
        # Get the partition object for drive C
        $partition = Get-Partition -DriveLetter C

        # Get the disk object that contains drive C
        $disk = Get-Disk -Number $partition.DiskNumber

        # Get the partition number explicitly
        $partitionNumber = $partition.PartitionNumber

        # Get the largest amount of free space on the disk using PartitionNumber
        $sizeRemaining = Get-PartitionSupportedSize -DiskNumber $partition.DiskNumber -PartitionNumber $partitionNumber

        # Expand the C drive to the maximum supported size
        Resize-Partition -DiskNumber $partition.DiskNumber -PartitionNumber $partitionNumber -Size $sizeRemaining.SizeMax
        
        # Return success information
        "Successfully resized partition on $($env:COMPUTERNAME)"
    }
    catch {
        # Handle errors
        "Error occurred on $($env:COMPUTERNAME): $_"
    }
}


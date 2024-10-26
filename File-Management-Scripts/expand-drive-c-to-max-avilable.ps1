# Import the Storage module (optional, depending on your system)
#Import-Module Storage

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

<#
$partition
$disk 
$partitionNumber 
$sizeRemaining 
#>
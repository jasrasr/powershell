# Define source and destination directories
$SourcePath = "C:\Users\jlamb\Desktop\Canon Dump\100GOPRO"
$DestinationPath = "D:\Canon Dump\100GOPRO"

# Move all files from source to destination
Move-Item -Path $SourcePath\* -Destination $DestinationPath -Force

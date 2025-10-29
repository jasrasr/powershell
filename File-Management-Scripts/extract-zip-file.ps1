# extract zip file
$file = "C:\path\to\your\file.zip"
$destination = "C:\path\to\your\destination\folder"

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($file, $destination)

# This will robocopy one single file

$datetime = Get-Date -Format 'yyyyMMdd-HHmmss'
$logfolder = 'C:\temp\powershell-exports'
$logfile = Join-Path $logfolder "robocopy-$datetime.log"

$source = 'C:\path\to\source'          # set this
$destination = 'C:\path\to\destination' # set this
$file = 'file.txt'                     # single file name only

# Create log folder if missing
if (-not (Test-Path $logfolder)) {
    New-Item -ItemType Directory -Path $logfolder | Out-Null
}

# Run Robocopy on one single file
robocopy $source $destination $file /MT:64 /W:1 /R:1 /J /LOG+:"$logfile"

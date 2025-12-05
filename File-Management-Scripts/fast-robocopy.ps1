# this will robocopy one single file
$date-time = get-date
$logfolder = 'C:\temp\powershell-exports'
$logfile = join-path $logfolder 'robocopy-$datetime.log'
$file = 'file.txt' # enter single file name like 'file.txt'
if (-not(test-path $logfolder){
md $logfolder
}

robocopy $source $destination $file /MT:64 /W:1 /R:1 /J /LOG+:$logfile

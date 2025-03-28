#get time date
$datetime = Get-Date -Format "yyMMdd-HHmmss"
#set path
#$logpath = "\\middough.local\corp\data\proj\!TEMPLATE\logs\robocopylog-$datetime.txt"
$logpath = "c:\temp\!template\logs\robocopylog-$datetime.txt"
new-item -path $logpath -type file -force
function newclientq {
    param (
        [string]$clientName
    )

    do {
        $response = Read-Host "Do you want to create a new client project? (y/n)"
    } while ($response -ne 'y' -and $response -ne 'n')

    if ($response -eq 'y') {
        $clientName = Read-Host "Enter the new client name"
        # Add your code here to create the new client project using $clientName
        Write-Output "New client project '$clientName' created."
    } else {
        Write-Output "No new client project created."
    }
}
newclientq
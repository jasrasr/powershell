# delete duplicate desktop files on the desktop from OneDrive with the same "${domain} inc-*.lnk"
function delete-dupdesktop {
$folder = "C:\users\$env:username\onedrive - ${domain}\desktop"
$files = Get-ChildItem -Path $folder -Filter "${domain} inc-*.lnk"
del $files
}
delete-dupdesktop
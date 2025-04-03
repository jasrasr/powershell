# delete duplicate desktop files on the desktop from OneDrive with the same "middough inc-*.lnk"
function delete-dupdesktop {
$folder = "C:\users\$env:username\onedrive - middough\desktop"
$files = Get-ChildItem -Path $folder -Filter "middough inc-*.lnk"
del $files
}
delete-dupdesktop
$autodeskPrograms = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object {($_.DisplayName -like "*Autodesk*") -or ($_.Publisher -like "*Autodesk*")} | Sort-Object DisplayName
$autodeskPrograms | FT -autosize

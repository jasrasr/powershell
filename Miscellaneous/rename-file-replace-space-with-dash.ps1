Get-ChildItem "C:\Users\jason.lamb\OneDrive - middough\Documents\GitHub\PowerShellScripts\Miscellaneous" | ForEach-Object {
    $newName = $_.Name -replace ' ', '-'
    Rename-Item $_.FullName -NewName $newName
}

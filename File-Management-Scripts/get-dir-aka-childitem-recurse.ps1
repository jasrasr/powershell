#Get-ChildItem -Path "N:\!newprojecttemplate-BIM" -Recurse
#Get-ChildItem -Path "N:\!newprojecttemplate-BIM" -Recurse | Select-Object -ExpandProperty FullName
Get-ChildItem -Path "N:\!newprojecttemplate-BIM" -Recurse -Directory | Select-Object -ExpandProperty FullName
robocopy "N:\!newprojecttemplate-BIM" "n:\test\test112124" -copyall /mt:128 /r:1 /w:1 /j

$source = "N:\!newprojecttemplate-BIM"
$destination = "N:\test\test112124"

# Robocopy command with performance optimizations
Start-Process robocopy -ArgumentList @"
"$source" "$destination" /MIR /MT:32 /R:1 /W:1 /NFL /NDL /NP /J"
"@ -NoNewWindow -Wait


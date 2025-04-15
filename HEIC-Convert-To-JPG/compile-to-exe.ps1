# Compile script to EXE with custom icon
Invoke-ps2exe -inputFile ".\HEICconvert2JPG-GUI.ps1" `
              -outputFile ".\HEICconvert2JPG-GUI.exe" `
              -noConsole -iconFile ".\icon.ico"

<#
Uses WinForms
Points to .\ImageMagick\magick.exe
GUI with drag/drop, browse, logging, summary
#>
HEIC to JPG Converter (GUI Revision 5)
--------------------------------------
Author: Jason Lamb
Created: April 2025
Version: GUI Rev 5

HOW TO RUN:
- Run HEICconvert2JPG-GUI.ps1 (requires PowerShell 5.1+)
- OR double-click HEICconvert2JPG-GUI.exe after compiling it

FEATURES:
- Drag & Drop or browse files
- Output defaults to input folder
- Converts .HEIC/.HEIF to .JPG using bundled ImageMagick
- Moves originals to 'Original HEIC' folder
- Generates conversion-log.csv with file sizes & dimensions

BUILDING THE EXE:
- Open PowerShell
- Run: .\compile-to-exe.ps1

REQUIREMENTS:
- Windows 10/11
- No install required

# HEIC-Convert-To-JPG Folder 

## Purpose
Resources for converting HEIC images into the more widely supported JPG format.

## Files
| Name | Type | Rev | Description |
| --- | --- | --- | --- |
| `compile-to-exe.ps1` | ps1 | 3cfac93 | Compile script to EXE with custom icon |
| `convert-png-to-ico.ps1` | ps1 | 3cfac93 | Revision #3 |
| `ConvertTo-Jpeg.ps1` | ps1 | 3cfac93 | ONLY WORKS WITH POWERSHELL 5.1 |
| `HEICconvert2JPG-GUI.ps1` | ps1 | 3cfac93 | GUI to convert HEIC/HEIF files to JPG using ImageMagick (portable compatible, handles UNC, PowerShell 7 required) |
| `HEICconvert2JPG-GUI0-rev5-1.ps1` | ps1 | 3cfac93 | Converts HEIC/HEIF files to JPG using ImageMagick via PowerShell GUI. |
| `icon.ico` | ico | 3cfac93 | Icon file |
| `icon.png` | png | 3cfac93 | Image file |
| `ImageMagick-7.1.1-47-portable-Q16-x64.zip` | zip | 3cfac93 | Archive file |
| `README.md` | md | 6fd63ee | Documentation |
| `readme.txt` | txt | 3cfac93 | Documentation |
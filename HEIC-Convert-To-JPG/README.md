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

## Directory listing
| Name | Type | Description |
| --- | --- | --- |
| `ConvertTo-Jpeg.ps1` | File | PowerShell script |
| `HEICconvert2JPG-GUI.ps1` | File | PowerShell script |
| `HEICconvert2JPG-GUI0-rev5-1.ps1` | File | PowerShell script |
| `ImageMagick` | Directory | Subdirectory |
| `ImageMagick-7.1.1-47-portable-Q16-x64.zip` | File | File |
| `README.md` | File | Markdown documentation |
| `Sample-HEIC-Files` | Directory | Subdirectory |
| `Sample-HEIC-Files---Copy` | Directory | Subdirectory |
| `Sample-HEIC-Files1` | Directory | Subdirectory |
| `compile-to-exe.ps1` | File | PowerShell script |
| `convert-png-to-ico.ps1` | File | PowerShell script |
| `icon.ico` | File | File |
| `icon.png` | File | PNG image |
| `readme.txt` | File | Text file |

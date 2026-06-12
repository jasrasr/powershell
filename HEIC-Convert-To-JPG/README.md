HEIC to JPG Converter (GUI Revision 5.7)
----------------------------------------
Author: Jason Lamb
Created: April 2025
Version: GUI Rev 5.7

HOW TO RUN:
- Run HEICconvert2JPG-GUI.ps1 (requires PowerShell 7+)
- OR double-click HEICconvert2JPG-GUI.exe after compiling it
- OR run remotely with no install:  irm https://jasr.me/heic | iex
- Run HEICconvert2JPG-Monitor.ps1 to watch a folder and auto-convert new HEIC files

REMOTE-RUN NOTES (irm | iex):
- On first run, magick.exe (~24 MB) is downloaded to
  %LOCALAPPDATA%\HEIC-Convert-To-JPG\ImageMagick\magick.exe and cached
- Subsequent runs reuse the cached binary (no download)
- Requires internet access to https://raw.githubusercontent.com on first run

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
- PowerShell 7+
- No install required

# HEIC-Convert-To-JPG Folder

## Purpose
Resources for converting HEIC images into the more widely supported JPG format.

## Directory listing
| Name | Type | Description |
| --- | --- | --- |
| `HEICconvert2JPG-GUI.ps1` | File | Main GUI converter (current v5.6) |
| `HEICconvert2JPG-Monitor.ps1` | File | Folder watcher that auto-converts new HEIC files |
| `compile-to-exe.ps1` | File | Compiles the GUI script to an EXE via PS2EXE |
| `CHANGELOG.md` | File | Version history |
| `README.md` | File | Markdown documentation |
| `icon.ico` | File | Application icon for the compiled EXE |
| `icon.png` | File | Source PNG for the icon |
| `ImageMagick` | Directory | Bundled portable ImageMagick used for conversion |
| `Testing` | Directory | Old revisions, samples, and one-time utility scripts |

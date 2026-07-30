# Photo HTML Index

Generate two searchable and sortable HTML indexes for a local photo collection using PowerShell.

## Overview

`New-ImageIndex.ps1` scans a selected folder for supported image files and creates two offline HTML reports directly in that folder:

- `photo-table.html` — Detailed table view
- `photo-list.html` — Compact filename list

No database, web server, thumbnail generation, or external PowerShell module is required.

## Current Revision

**1.1.0**

See [ROADMAP.md](./ROADMAP.md) for planned releases and future features.

## Features

- Graphical folder picker when `-Path` is omitted
- Optional `-Path` parameter for unattended use
- Recursive scanning by default
- Optional `-NoRecurse` switch
- Instant browser-side search
- Sorting by name, folder, modified date, and file size
- Clickable table rows and filename links
- One reusable browser tab named `PhotoPreview`
- Ctrl+Click, Shift+Click, or middle-click for additional tabs
- Accurate collection summary:
  - Total image count
  - Folders containing images
  - Total image size
  - Newest image
  - Oldest image
  - Full resolved root path
  - Report generation timestamp
- Automatic opening of both generated reports
- Offline HTML/CSS/JavaScript output
- Light and dark browser color-scheme support

## Supported Image Formats

- JPG / JPEG
- PNG
- GIF
- BMP
- TIF / TIFF
- WEBP
- HEIC
- AVIF

Browser support for displaying some formats, especially HEIC and AVIF, depends on the installed browser and Windows codecs.

## Usage

### Select a folder graphically

```powershell
.\New-ImageIndex.ps1
```

### Specify a folder

```powershell
.\New-ImageIndex.ps1 -Path "C:\Users\Jason\OneDrive\Pictures"
```

### Scan only the selected folder

```powershell
.\New-ImageIndex.ps1 -Path "C:\Users\Jason\OneDrive\Pictures" -NoRecurse
```

## Generated Files

The script writes both files directly into the selected root folder:

```text
photo-table.html
photo-list.html
```

Running the script again replaces the prior generated reports.

## `photo-table.html`

The detailed table includes:

- File name
- Full containing folder
- Modified date and time
- File size

Click a column header to sort. Click it again to reverse the direction.

The entire row acts as the image link.

## `photo-list.html`

The compact report displays filenames in a responsive multi-column grid.

Its sort menu includes:

- Name: A to Z / Z to A
- Folder: A to Z / Z to A
- Date: newest / oldest
- Size: largest / smallest

## Preview-Tab Behavior

A normal click opens the image in a browser tab named `PhotoPreview`. Later normal clicks reuse that same tab instead of creating more tabs.

Standard browser modifiers remain available:

- Ctrl+Click — separate tab
- Shift+Click — separate window or tab, depending on browser settings
- Middle-click — separate tab

## Performance Design

The reports do not generate or embed thumbnails. They contain file metadata and links to the original files, which keeps report generation and page loading practical for large collections.

Browser performance ultimately depends on the number of indexed files and available system memory.

## Security and Privacy

- The script does not upload images.
- The generated reports are local files.
- Image links point to the original local paths.
- Do not publish generated HTML reports publicly when the embedded local paths or filenames are sensitive.

## Repository Files

```text
photo-index/
├── New-ImageIndex.ps1
├── README.md
└── ROADMAP.md
```

## Roadmap

Planned releases and future enhancements are tracked in [ROADMAP.md](./ROADMAP.md).

## Author

Jason Lamb, with help from ChatGPT.

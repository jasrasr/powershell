# Photo HTML Index Roadmap

This roadmap tracks planned improvements for `New-ImageIndex.ps1`. Release scope may change as the script is tested against larger photo libraries and additional image formats.

## Current Release — 1.1.0

Status: **Current**

### Included

- Graphical folder picker
- Optional `-Path` parameter
- Recursive scanning by default
- Optional `-NoRecurse` mode
- `photo-table.html` detailed report
- `photo-list.html` compact report
- Search by file name and folder
- Sorting by:
  - File name
  - Folder
  - Modified date
  - File size
- Reusable `PhotoPreview` browser tab
- Ctrl+Click, Shift+Click, and middle-click support
- Collection summary:
  - Total image count
  - Folder count
  - Total image size
  - Newest image
  - Oldest image
  - Full root path
  - Generation timestamp
- HTML files saved in the selected root folder
- Automatic opening of both reports

---

## Planned Release — 1.2.0

Focus: **File metadata and filtering**

### Planned

- Display image dimensions
- Display file extension/type
- Filter by image format
- Filter by folder
- Filter by modified-date range
- Filter by file-size range
- Add column visibility controls
- Add ascending/descending sort indicators
- Preserve selected sort and filter settings in browser storage
- Add duplicate file-name detection
- Add missing or inaccessible file reporting
- Add optional CSV export
- Add optional JSON export

---

## Planned Release — 1.3.0

Focus: **EXIF and location metadata**

### Planned

- Read available EXIF metadata
- Camera manufacturer and model
- Lens model
- Date taken
- Exposure time
- Aperture
- ISO
- Focal length
- Image orientation
- GPS latitude and longitude
- Map links for geotagged images
- Separate modified date from original date taken
- EXIF availability indicator
- Graceful handling of files without EXIF data

### Technical consideration

EXIF support may require either:

- Native Windows metadata access
- A bundled command-line dependency such as ExifTool
- An optional PowerShell module

Any external dependency will remain optional and will be documented clearly.

---

## Planned Release — 1.4.0

Focus: **Usability and reporting**

### Planned

- Dark/light theme toggle
- Remember theme preference
- Folder summary report
- File-type summary
- Date-based timeline
- Largest-files report
- Recently modified report
- Broken-link validation
- Optional hover preview loaded only when requested
- Keyboard navigation
- Accessible focus styling
- Configurable output filenames
- Optional suppression of automatic browser launch
- Execution-duration summary
- PowerShell version shown in report footer
- Script revision shown in HTML titles and footers

---

## Planned Release — 1.5.0

Focus: **Duplicate and similarity analysis**

### Planned

- Exact duplicate detection using file hashes
- Duplicate groups by content
- Duplicate groups by file name
- Duplicate groups by file size
- Optional hash cache to improve later scans
- Potential duplicate report
- Safe review workflow without automatic deletion
- Similar-image detection research
- Configurable similarity threshold

### Safety rule

The script will not automatically delete, move, or rename duplicate files. Any cleanup action must be explicit.

---

## Planned Release — 2.0.0

Focus: **Advanced static photo catalog**

### Planned

- Optional thumbnail generation
- Lazy-loaded preview panel
- Favorites and ratings
- User-defined tags
- Timeline view
- Map view
- Slideshow mode
- Static website publishing mode
- GitHub Pages-compatible output
- Incremental indexing
- Cached metadata
- Faster refresh of previously indexed libraries
- Configurable site title and branding
- Separate assets folder for CSS and JavaScript
- Portable relative-link mode when practical

---

## Future Research

These ideas are not assigned to a release yet.

- AI-generated image descriptions
- Local object detection
- Local OCR
- License plate metadata extraction
- Face grouping with privacy controls
- Natural-language search
- Similar-scene grouping
- Automatic event grouping
- Integration with a PHP/JSON website
- Optional WordPress publishing workflow
- Optional GitHub synchronization workflow

---

## Out of Scope Unless Explicitly Added

- Automatic deletion of photos
- Automatic movement or renaming of source files
- Cloud upload of private images
- Mandatory AI services
- Mandatory paid APIs
- Editing original image files

---

## Versioning

This project uses semantic-style revision numbers:

- **Patch** (`1.1.1`) — Bug fix, typo correction, or small compatibility change
- **Minor** (`1.2.0`) — New backward-compatible feature
- **Major** (`2.0.0`) — Significant redesign or major feature expansion

The script header, changelog, README, and generated report footer should use the same revision number.

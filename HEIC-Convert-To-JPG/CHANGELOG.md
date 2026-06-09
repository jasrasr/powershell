# Changelog

All notable changes to this project are documented in this file.

---

## [5.4] – Windows-Native HEIC Conversion (WIC)
### Changed
- Replaced ImageMagick HEIC decoding with Windows-native WIC (Windows Imaging Component)
- Removed dependency on ImageMagick for HEIC/HEIF decoding
- Conversion now relies on installed HEIF Image Extensions in Windows
- Significantly improved reliability on Windows 10/11 systems

### Preserved
- Existing GUI layout and workflow
- Drag-and-drop and multi-file browse support
- Logging, size tracking, dimensions, and summary output
- Archive handling for original HEIC files

### Notes
- This change resolves persistent ImageMagick `HEIC r-- / no decode delegate` limitations on Windows
- `.AAE` sidecar files are intentionally ignored (non-image metadata files)

---

## [5.3.2] – GUI Control Restoration
### Fixed
- Restored missing GUI elements after refactor:
  - Input file Browse button
  - Output folder Browse button
  - Drag-and-drop target area
- Ensured file collection and conversion controls were fully wired

---

## [5.3.1] – Startup Stability Fix
### Fixed
- Prevented silent GUI failure caused by premature archive folder resolution
- Deferred archive folder creation until files are present
- Added defensive startup logic to ensure GUI always renders

---

## [5.3] – Dependency & Logging Refactor
### Changed
- Standardized log output location to `C:\temp\powershell-exports`
- Improved progress bar initialization and handling
- Added file de-duplication during multi-drop and multi-select
- Tightened dependency checks for external tools

---

## [5.2] – Portable ImageMagick Path Override
### Changed
- Added ImageMagick module path override support
- Improved portability on systems without global ImageMagick installs

---

## [5.1] – ImageMagick GUI Conversion
### Changed
- Major revision: HEIC/HEIF to JPG GUI using ImageMagick
- Added portable ImageMagick compatibility
- Improved handling of UNC paths
- PowerShell 7 required

---

## [4.3] – Output Path Handling
### Fixed
- Corrected handling of `&` characters in output paths and filenames

---

## [4.2] – Multi-File Browse Support
### Added
- Browse button to select multiple `.heic` and `.heif` files directly
- Mixed file selection supported without drag-and-drop

---

## [4.1] – Instruction & Metadata UI Cleanup
### Changed
- Replaced instruction TextBox with read-only Label controls
- Removed focus, selection, and highlight behavior
- Styled labels for grouped instruction and metadata display
- Metadata (Author, Created Date, Version) now visible and formatted
- Input/output folder logic preserved

---

## [4.0] – GUI Usability Enhancements
### Added
- Input folder Browse option
- Output folder defaults to input folder
- Instructions and metadata panel

### Preserved
- Drag-and-drop support
- Logging, size tracking, dimension capture, and summary output

---

## [3.0] – Drag & Drop Stability
### Fixed
- Global file tracking errors causing false “drop a file first” messages

### Added
- Support for multiple drag-and-drop actions
- Verified file persistence between drop and convert events

---

## [2.0] – File Collection Refactor
### Changed
- Converted `$collectedFiles` to a global variable
- Implemented safe accumulation during drag-and-drop
- Ensured file list is cleared after conversion

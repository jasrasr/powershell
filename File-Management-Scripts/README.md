# File-Management-Scripts

## Purpose
Scripts focused on copying, moving, cleaning, and auditing files AND/OR FOLDERS across local or network storage.
The Directory Listing below may not be updated with all the scripts in this directory. I don't have a way to udpate this dynamically or automatically, but I am sure I will create a workflow or script to do this soon.

## Files
| Name | Type | Rev | Description |
| --- | --- | --- | --- |
| `Automox-Reorder-CsvToXlsx.ps1` | ps1 | 3cfac93 | Reorder Automox CSV columns, export to XLSX, and convert to Excel table. Rev 1.0 |
| `change-active-directory-computer-description.ps1` | ps1 | 3cfac93 | Define variables |
| `change-modify-date.ps1` | ps1 | 3cfac93 | Modify file LastWriteTime (modification date) using PowerShell. Rev 1.0 |
| `check-files-and-permissions.ps1` | ps1 | 3cfac93 | check files and permissions |
| `check-log-file-daily.ps1` | ps1 | 3cfac93 | Path to the log |
| `check-xlsx-xlsm-legacy-shared-stage1-scan-only.ps1` | ps1 | 3cfac93 | Scan current folder & subfolders for .xlsx & .xlsm, |
| `check-xlsx-xlsm-legacy-shared-stage2-update.ps1` | ps1 | 3cfac93 | Read a CSV log and remove legacy shared workbook mode |
| `clean-duplicate-files.ps1` | ps1 | 3cfac93 | delete duplicate desktop files on the desktop from OneDrive with the same "${domain} inc-*.lnk" |
| `combine-all-txt-files-in-a-folder.ps1` | ps1 | 3cfac93 | Merge all TXT files in a folder into one CSV by appending lines vertically (one after another). Rev 2.0 |
| `compare-folders.ps1` | ps1 | 3cfac93 | Compare two directories and export results to CSV # Rev 1.0 |
| `compare-source-destination-files.ps1` | ps1 | 3cfac93 | Check if the source Excel differs from the most-recent destination copy. If different, copy to destination with today's date suffix (e.g., 'Project List Download 090425.xlsx'). Rev 1.0 |
| `compare-two-xlsx-files.ps1` | ps1 | 3cfac93 | Auto-picks the latest two Excel files in a folder (newest = $NewFile, second-newest = $OldFile) and compares by Project# (A) vs Stat (B). |
| `Convert-Csv-To-Xlsx.ps1` | ps1 | 3cfac93 | ConvertCsvToXlsx.ps1 |
| `convert-dng.ps1` | ps1 | 3cfac93 | Fix dcraw_emu invocation (no “--”), set working dir for output, convert DNG → 16-bit TIFF → JPG via ImageMagick. Adds single-file smoke test + bulk conversion. Rev 1.3 |
| `delete-bulk-files-from-array.ps1` | ps1 | 3cfac93 | PowerShell script |
| `delete-sub-empty-folders-and-log.ps1` | ps1 | 3cfac93 | Remove empty folders inside target directory (test with -WhatIf first), log results to same folder |
| `expand-drive-c-to-max-avilable.ps1` | ps1 | 3cfac93 | Import the Storage module (optional, depending on your system) |
| `extract-zip-file.ps1` | ps1 | 3cfac93 | extract zip file |
| `fast-robocopy-one-file.ps1` | ps1 | 3cfac93 | Ask for missing input interactively |
| `file-hash-compare-speeds.ps1` | ps1 | 3cfac93 | Benchmark hash speeds (MD5 vs SHA1 vs SHA256) with progress, per-iteration stats, and CSV export. Rev 1.0 |
| `file-hash-compare.ps1` | ps1 | 3cfac93 | Benchmark hash speeds (MD5 vs SHA1 vs SHA256) with progress, per-iteration stats, and CSV export. Rev 1.0 |
| `file1-file2-b.csv` | csv | 3cfac93 | File |
| `file1-file2.csv` | csv | 3cfac93 | File |
| `file1.txt` | txt | 3cfac93 | file1-item1 |
| `file2.txt` | txt | 3cfac93 | file2-item1 |
| `filter-csv.ps1` | ps1 | 3cfac93 | Stream-filter a very large CSV and remove rows containing the cell "List Folder Contents". Saves output in the SAME folder with "-filtered" suffix, reports how many lines were removed, and shows a responsive progress bar with ETA. Rev 1.3 |
| `fix-onedrive-file-conflicts.ps1` | ps1 | 3cfac93 | Rename OneDrive host-conflict files by removing the computer name token and appending "-onedriveconflict<3-char nonce>". Logs original -> new with timestamp to a single rolling CSV log. Adds exclusion of specific folders. Rev 1.3 |
| `folder-depth4-stream-batches-summary.ps1` | ps1 | 3cfac93 | Stream folders exactly at depth 4 with live progress, timestamped incremental batch output every 1000 items, |
| `get-content-from-text-file.ps1` | ps1 | 3cfac93 | Define the path to the text files |
| `get-dir-aka-childitem-recurse-dup.ps1` | ps1 | 3cfac93 | Robocopy command with performance optimizations |
| `get-dir-aka-childitem-recurse.ps1` | ps1 | 3cfac93 | Robocopy command with performance optimizations |
| `get-dir-export-dup.ps1` | ps1 | 3cfac93 | Install-Module -Name PowerShellGet -Force -AllowClobber |
| `get-dir-export.ps1` | ps1 | 3cfac93 | get dir export |
| `get-file-hash-sha256.ps1` | ps1 | 3cfac93 | Quick SHA256 file hash calculator (no console spam). Rev 1.1 |
| `get-folder-icacls-dup.ps1` | ps1 | 3cfac93 | Get folder permissions using icacls |
| `get-folder-icacls.ps1` | ps1 | 3cfac93 | Get folder permissions using icacls |
| `get-folders-that-match-this-naming-structure.ps1` | ps1 | 3cfac93 | Define the root folder to search |
| `Get-MdStatistics.ps1` | ps1 | 3cfac93 | Get MdStatistics |
| `get-number-of-sub-files-and-folders.ps1` | ps1 | 3cfac93 | Process each folder, does it exist, how many sub files/folders |
| `get-only-depth-4-with-heartbeat-incremental-output-batch.ps1` | ps1 | 3cfac93 | Stream folders exactly at depth 4 with live progress bar, timestamped incremental file output every 1000 items, |
| `get-overall-folder-size-with-child-items-in-mb.ps1` | ps1 | 3cfac93 | Define an array of project folders |
| `get-unique-value-from-csv.ps1` | ps1 | 3cfac93 | Extract a unique list of "Display Name" values from a very large CSV with a progress bar. Supports exact line-based progress when -TotalLines is provided. Saves results to a new CSV in the same folder with header "Display Name". Rev 1.3 |
| `if-file-exist-then-output-file.ps1` | ps1 | 3cfac93 | EVALUTIONATION |
| `m365-version-update-download.ps1` | ps1 | 3cfac93 | Check Microsoft 365 Apps "Current Channel" build on MS Learn. |
| `map-user-profile-folders-to-onedrive.ps1` | ps1 | 3cfac93 | Define user-specific paths using $env:USERNAME |
| `map-user-profile-folders-to-onedrive1.ps1` | ps1 | 3cfac93 | Define OneDrive path specific to ${domainup} |
| `merge-all-txt-files-into-one.ps1` | ps1 | 3cfac93 | Combine all merged TXT files into a single file and report total line count |
| `merge-pdf-files.ps1` | ps1 | 3cfac93 | Extract the contents of the downloaded ZIP file to a folder on your computer. |
| `merge-pst-files-percent.ps1` | ps1 | 3cfac93 | Define source folder containing PST files and the destination PST file path |
| `merge-pst-files.ps1` | ps1 | 3cfac93 | Define source folder containing PST files and the destination PST file path |
| `merge-two-txt-files-into-one-csv.ps1` | ps1 | 3cfac93 | Merge two TXT files side-by-side into a CSV file without quotes. |
| `merge-txt-files-max-count-lines-per-file.ps1` | ps1 | 3cfac93 | Merge all TXT files in a folder into new merged files with a maximum of 1000 rows each. |
| `monitor-folders.ps1` | ps1 | 3cfac93 | Monitor provided folders for total file count, folder count, and size every 60 seconds; stop when 5 sequential snapshots are identical. Includes -Depth, per-iteration runtime, and a visible countdown to the next run. Rev 1.4 |
| `move-file-attempt-60-seconds-if-failure.ps1` | ps1 | 3cfac93 | Keep retrying every 1 minute until Twinmotion 2022.2.3 Revit Installer.zip is successfully moved, with logging |
| `move-files.ps1` | ps1 | 3cfac93 | Define source and destination directories |
| `move-withprogress.ps1` | ps1 | 3cfac93 | PowerShell script |
| `nerdio-management.ps1` | ps1 | 3cfac93 | SharePoint management script |
| `new-client-project-from-template.ps1` | ps1 | 3cfac93 | PowerShell script with function: newclientq |
| `panzura-disk-space.ps1` | ps1 | 3cfac93 | PowerShell script |
| `parse-filter-csv-txt-file.ps1` | ps1 | 3cfac93 | Read all lines, filter, and overwrite |
| `parse-txt-file-other.ps1` | ps1 | 3cfac93 | remove row a row that matches "x" to $txtoutput |
| `parse-txt-remove-lines.ps1` | ps1 | 3cfac93 | Cleans text files with a given prefix by removing standard subfolder patterns and child paths. |
| `parse-txt-remove-matching-lines-from-another-txt-file-skip-completed.ps1` | ps1 | 3cfac93 | Cleans text files with a given prefix by removing standard subfolder patterns and child paths. |
| `parse-txt-remove-matching-lines-from-another-txt-file.ps1` | ps1 | 3cfac93 | Remove lines from *-cleaned.txt files that appear in a reference file (egnyte-permission-report.txt) |
| `parse-txt.ps1` | ps1 | 3cfac93 | Parse icacls text into CSV, bump MIDDOUGH\* with leading comma |
| `PDFsharp.zip` | zip | 3cfac93 | Archive file |
| `ping-computer-and-move-file.ps1` | ps1 | 3cfac93 | PowerShell script |
| `ping-get-folder-and-expand-c-drive-max.ps1` | ps1 | 3cfac93 | Define the list of computers |
| `random-folder-creation.ps1` | ps1 | 3cfac93 | Count the number of child items in each directory |
| `README.md` | md | 3cfac93 | Documentation |
| `remove-duplicate-lines-in-txt-file.ps1` | ps1 | 3cfac93 | Remove duplicate lines (preserving first occurrence) from a specified text file and overwrite the original file atomically. |
| `remove-empty-folders.ps1` | ps1 | 3cfac93 | Fast removal of empty subfolders using .NET enumeration (deepest-first) with progress bar and runtime timestamps. Default WhatIf; use -Delete to actually remove. Logs to parent.  Rev 1.8 |
| `remove-empty-lines-from-txt-file.ps1` | ps1 | 3cfac93 | Remove empty lines from a specified text file and overwrite the original file. Added parameter input. Rev 1.1 |
| `remove-users-from-csv.ps1` | ps1 | 3cfac93 | Robust header handling + exclude filtering. Extract/keep unique "Display Name" values excluding a provided CSV list, optionally filter source rows. Fixes "Display Name not found" by normalizing header quotes/whitespace/BOM. Shows progress. Rev 1.8 |
| `rename-clean-file-names.ps1` | ps1 | 3cfac93 | Clean file names only (no folder renames). |
| `rename-filenames-with-leading-or-trailing-space.ps1` | ps1 | 3cfac93 | Rename files within one or more target folders by trimming names, collapsing multiple spaces, and appending -1/-2 for duplicates; per-folder and global logs; optional recursion; dry run supported; exclusion folder array added. Rev 1.1 |
| `rename-filenames-with-space-with-dash.ps1` | ps1 | 3cfac93 | Define the root folder to search |
| `rename-files-in-bulk.ps1` | ps1 | 3cfac93 | Define the directory where the files are located |
| `rename-files-with-spaces-to-dashes.ps1` | ps1 | 3cfac93 | output example: |
| `replace-file-name-space-with-dash.ps1` | ps1 | 3cfac93 | Define the path to the file you want to rename |
| `replace-files-with-source-dir-array.ps1` | ps1 | 3cfac93 | Define an array of source directories |
| `review-txt-file-and-remove-lines-with-file-extensions.ps1` | ps1 | 3cfac93 | Start the job |
| `sort-csv-by-row-a-z.ps1` | ps1 | 3cfac93 | source csv by row a-z |
| `split-large-csv-by-line-count-streaming.ps1` | ps1 | 3cfac93 | Stream-split a large CSV by line count with robust LOCAL STAGING for network paths (Egnyte/Panzura), retries, and heartbeats. Rev 1.4 |
| `split-large-csv-by-line-count.ps1` | ps1 | 3cfac93 | Split a large CSV into smaller chunk files while preserving the header. Rev 1.0 |
| `split-large-txt-by-line-count-streaming.ps1` | ps1 | 3cfac93 | Stream-split a large TXT by line count with robust LOCAL STAGING for network paths (Egnyte/Panzura), retries, and heartbeats. Rev 1.5 |
| `sync-bb-stamps-from-sharepoint-onedrive.ps1` | ps1 | 3cfac93 | PowerShell script |
| `test.ps1` | ps1 | 3cfac93 | PowerShell script |
| `transfer-a-large-file.ps1` | ps1 | 3cfac93 | Define variables |
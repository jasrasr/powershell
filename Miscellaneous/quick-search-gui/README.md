# Quick Search

A fast Windows filename-search GUI. The initial draft builds its index in the
background, keeps the index in memory, and monitors indexed roots for file and
folder changes. Searches query the index rather than walking the filesystem.

## Run

Double-click `Start-QuickSearch.cmd`, or run:

```powershell
powershell.exe -NoProfile -STA -File .\QuickSearch.ps1
```

By default, Quick Search indexes all ready fixed drives. To limit it to one or
more folders:

```powershell
powershell.exe -NoProfile -STA -File .\QuickSearch.ps1 -Roots C:\Users\me,D:\Projects
```

Type multiple words to require all of them in the full path. Up to 300 matches
are displayed so UI rendering stays responsive.

Keyboard shortcuts:

- `Enter`: open the selected result
- `Ctrl+Enter`: reveal it in File Explorer
- `Down`: move from the search box into the results
- `Escape`: clear the query

## Verify the search engine

```powershell
powershell.exe -NoProfile -File .\QuickSearch.ps1 -SelfTest
```

## Current limitations

This first version uses a background directory traversal and `FileSystemWatcher`.
The next performance step is an elevated NTFS MFT/USN-journal indexer plus a
persisted index, which would make first startup and very large-volume updates
closer to Everything's performance. File contents are not indexed.


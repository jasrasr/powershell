# Filename     : get-browser-bookmarks.ps1
# Revision     : 1.1.4
# Description  : Extracts bookmarks from Chrome, Edge, and Firefox; exports to OneDrive Documents in CSV, JSON, and HTML formats
# Author       : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-04-30
# Modified Date: 2026-06-05
# Changelog    :
# 1.0.0 Initial release; Chrome/Edge extraction, OneDrive detection, multi-format export
# 1.0.1 Changed default export path to $env:OneDriveCommercial\Documents; added export summary
# 1.0.2 Open export folder in Explorer on complete
# 1.0.3 Changed export path to Documents\! Bookmark Export; auto-create folder if missing
# 1.0.4 Include all bookmark roots (Bookmarks bar, Other bookmarks, Mobile bookmarks) — prior versions only extracted the bookmarks bar
# 1.1.0 Add Firefox support: layered extraction (jsonlz4 backup -> pure-PS SQLite reader) with no module/install requirement; also copies raw backup files to export folder for portable migration
# 1.1.1 Fix SQLite reader: use .NET File.Copy/Delete (avoids 8.3 short-path errors in $env:TEMP); replace O(N^2) array += with List<T>; read moz_bookmarks first and filter moz_places to only referenced URLs; O(1) parent lookup via hashtable instead of Where-Object
# 1.1.2 SQLite reader: add visited-page guard in walkTable (prevents infinite loops on corrupt/cyclic b-tree links); add timing + progress output at every major stage to make hangs diagnosable; bound page numbers to actual file extent
# 1.1.3 SQLite reader: bound headerSize varint defensively + safety cap on serial-type loop (prevents runaway decode on malformed records); per-record progress in sqlite_master decode
# 1.1.4 SQLite reader: switch decodeRecord $values to List<object> (PowerShell's `$arr += $null` is a no-op that silently drops NULL columns and shifts positional indices); diagnostic dump of first 3 sqlite_master records

param(
    [string]$ExportPath,
    [ValidateSet('CSV', 'JSON', 'HTML')]
    [string[]]$Formats = @('CSV', 'JSON', 'HTML'),
    [bool]$IncludeChrome = $true,
    [bool]$IncludeEdge = $true,
    [bool]$IncludeFirefox = $true,
    [bool]$CopyFirefoxRawFiles = $true
)

# Initialize variables
$bookmarks = @()
$errors = @()
$exportedFiles = @()

# ============================================================================
# FUNCTION: Detect OneDrive Root
# ============================================================================
function Get-OneDriveRoot {
    <#
    .SYNOPSIS
        Detects Microsoft OneDrive installation and returns root path.
    #>
    
    # Check registry for OneDrive root path
    $oneDrivePath = $null
    
    # Try HKCU first (most common)
    try {
        $regPath = 'HKCU:\Software\Microsoft\OneDrive'
        if (Test-Path $regPath) {
            $oneDrivePath = (Get-ItemProperty -Path $regPath -Name 'UserFolder' -ErrorAction SilentlyContinue).UserFolder
        }
    } catch {
        Write-Verbose "Registry check failed: $_"
    }
    
    # Fallback: Check common OneDrive paths
    if (-not $oneDrivePath) {
        $commonPaths = @(
            "$env:USERPROFILE\OneDrive",
            "$env:USERPROFILE\OneDrive - Personal",
            "$env:USERPROFILE\OneDrive - Business"
        )
        
        foreach ($path in $commonPaths) {
            if (Test-Path $path) {
                $oneDrivePath = $path
                break
            }
        }
    }
    
    if ($oneDrivePath -and (Test-Path $oneDrivePath)) {
        return $oneDrivePath
    }
    
    return $null
}

# ============================================================================
# FUNCTION: Read Bookmarks File with Lock Handling
# ============================================================================
function Get-BookmarksFile {
    <#
    .SYNOPSIS
        Reads bookmarks JSON file, handling browser locks by copying to temp if needed.
    #>
    
    param(
        [string]$FilePath,
        [string]$BrowserName
    )
    
    if (-not (Test-Path $FilePath)) {
        Write-Warning "[$BrowserName] Bookmarks file not found: $FilePath"
        return $null
    }
    
    try {
        # Try to read directly
        $content = Get-Content -Path $FilePath -Raw -ErrorAction Stop
        return $content
    } catch {
        # File is locked (browser running), copy to temp
        Write-Verbose "[$BrowserName] Bookmarks file locked, copying to temp..."
        
        try {
            $tempPath = Join-Path $env:TEMP "bookmarks_$([guid]::NewGuid().Guid).json"
            Copy-Item -Path $FilePath -Destination $tempPath -ErrorAction Stop
            $content = Get-Content -Path $tempPath -Raw -ErrorAction Stop
            Remove-Item -Path $tempPath -ErrorAction SilentlyContinue
            return $content
        } catch {
            $script:errors += "[$BrowserName] Failed to read bookmarks: $_"
            return $null
        }
    }
}

# ============================================================================
# FUNCTION: Recursively Extract Bookmarks from JSON Structure
# ============================================================================
function Get-BookmarkChildren {
    <#
    .SYNOPSIS
        Recursively extracts bookmarks and folders from nested JSON structure.
    #>
    
    param(
        [PSCustomObject]$Node,
        [string]$ParentFolder = "",
        [string]$BrowserName
    )
    
    $results = @()
    
    if ($null -eq $Node) { return $results }
    
    # Process children array
    if ($Node.children) {
        foreach ($child in $Node.children) {
            $currentFolder = $ParentFolder
            
            # Determine node type
            if ($child.type -eq "folder") {
                # Update folder path for recursion
                if ($ParentFolder) {
                    $currentFolder = "$ParentFolder / $($child.name)"
                } else {
                    $currentFolder = $child.name
                }
                
                # Recursively process folder children
                $results += Get-BookmarkChildren -Node $child -ParentFolder $currentFolder -BrowserName $BrowserName
            } 
            elseif ($child.type -eq "url") {
                # Add bookmark to results
                $results += [PSCustomObject]@{
                    Title       = $child.name
                    URL         = $child.url
                    Folder      = $currentFolder
                    Browser     = $BrowserName
                    DateAdded   = if ($child.date_added) { [datetime]::FromFileTime([int64]$child.date_added) } else { "" }
                }
            }
        }
    }
    
    return $results
}

# ============================================================================
# FUNCTION: Discover Default Firefox Profile via profiles.ini
# ============================================================================
function Get-FirefoxProfilePath {
    <#
    .SYNOPSIS
        Reads %APPDATA%\Mozilla\Firefox\profiles.ini and returns the default profile directory.
        Falls back to the most recently modified profile that has places.sqlite.
    #>

    $firefoxRoot = "$env:APPDATA\Mozilla\Firefox"
    $iniPath = Join-Path $firefoxRoot "profiles.ini"

    if (-not (Test-Path $iniPath)) {
        return $null
    }

    # Parse profiles.ini (simple key=value sections)
    $profiles = @()
    $currentSection = $null
    $currentData = $null
    foreach ($line in Get-Content $iniPath) {
        $line = $line.Trim()
        if ($line -match '^\[(.+)\]$') {
            if ($currentData) { $profiles += [PSCustomObject]@{ Section = $currentSection; Data = $currentData } }
            $currentSection = $Matches[1]
            $currentData = @{}
        } elseif ($currentData -and $line -match '^([^=]+)=(.*)$') {
            $currentData[$Matches[1].Trim()] = $Matches[2].Trim()
        }
    }
    if ($currentData) { $profiles += [PSCustomObject]@{ Section = $currentSection; Data = $currentData } }

    # Newer Firefox uses [Install*] sections with a Default= pointing at the profile path
    $installEntry = $profiles | Where-Object { $_.Section -like 'Install*' -and $_.Data.Default } | Select-Object -First 1
    if ($installEntry) {
        $candidate = Join-Path $firefoxRoot $installEntry.Data.Default
        if (Test-Path (Join-Path $candidate "places.sqlite")) { return $candidate }
    }

    # Fall back to [Profile*] with Default=1
    $profileSections = $profiles | Where-Object { $_.Section -like 'Profile*' }
    $defaultEntry = $profileSections | Where-Object { $_.Data.Default -eq '1' } | Select-Object -First 1
    if (-not $defaultEntry) { $defaultEntry = $profileSections | Select-Object -First 1 }

    if ($defaultEntry) {
        $relPath = $defaultEntry.Data.Path
        $isRel = ($defaultEntry.Data.IsRelative -ne '0')
        $candidate = if ($isRel) { Join-Path $firefoxRoot $relPath } else { $relPath }
        if (Test-Path (Join-Path $candidate "places.sqlite")) { return $candidate }
    }

    # Last resort: scan Profiles\ for any profile with places.sqlite, pick most recently modified
    $profilesDir = Join-Path $firefoxRoot "Profiles"
    if (Test-Path $profilesDir) {
        $scan = Get-ChildItem $profilesDir -Directory -ErrorAction SilentlyContinue |
            Where-Object { Test-Path (Join-Path $_.FullName "places.sqlite") } |
            Sort-Object { (Get-Item (Join-Path $_.FullName "places.sqlite")).LastWriteTime } -Descending |
            Select-Object -First 1
        if ($scan) { return $scan.FullName }
    }

    return $null
}

# ============================================================================
# FUNCTION: Decompress Mozilla LZ4 (.jsonlz4 / .mozlz4) — pure PowerShell, no deps
# ============================================================================
function Expand-MozLz4 {
    <#
    .SYNOPSIS
        Decodes Mozilla's LZ4 container used for .jsonlz4 backup files.
        Format: 8-byte "mozLz40\0" magic, 4-byte LE uncompressed size, then raw LZ4 block.
    #>

    param([byte[]]$Data)

    if ($null -eq $Data -or $Data.Length -lt 12) {
        throw "Mozilla LZ4 data too small ($($Data.Length) bytes)"
    }

    $magic = [System.Text.Encoding]::ASCII.GetString($Data, 0, 8)
    if ($magic -ne "mozLz40`0") {
        throw "Not a Mozilla LZ4 file (magic was '$magic')"
    }

    $uncompressedSize = [BitConverter]::ToUInt32($Data, 8)
    $dst = New-Object byte[] $uncompressedSize
    $dstPos = 0
    $srcPos = 12
    $srcLen = $Data.Length

    while ($srcPos -lt $srcLen) {
        $token = $Data[$srcPos]; $srcPos++

        # Literal length (high nibble)
        $litLen = ($token -shr 4) -band 0x0F
        if ($litLen -eq 15) {
            while ($srcPos -lt $srcLen) {
                $b = $Data[$srcPos]; $srcPos++
                $litLen += $b
                if ($b -ne 255) { break }
            }
        }

        # Copy literals
        if ($litLen -gt 0) {
            [Array]::Copy($Data, $srcPos, $dst, $dstPos, $litLen)
            $srcPos += $litLen
            $dstPos += $litLen
        }

        # End of block (last sequence has no match)
        if ($srcPos -ge $srcLen) { break }

        # Match offset (LE uint16)
        $offset = [BitConverter]::ToUInt16($Data, $srcPos)
        $srcPos += 2
        if ($offset -eq 0) { throw "LZ4 stream corrupt: zero offset" }

        # Match length (low nibble + minimum 4)
        $matchLen = ($token -band 0x0F) + 4
        if (($token -band 0x0F) -eq 15) {
            while ($srcPos -lt $srcLen) {
                $b = $Data[$srcPos]; $srcPos++
                $matchLen += $b
                if ($b -ne 255) { break }
            }
        }

        # Copy match byte-by-byte (overlap is intentional in LZ4)
        $matchStart = $dstPos - $offset
        for ($i = 0; $i -lt $matchLen; $i++) {
            $dst[$dstPos] = $dst[$matchStart + $i]
            $dstPos++
        }
    }

    return [System.Text.Encoding]::UTF8.GetString($dst, 0, $dstPos)
}

# ============================================================================
# FUNCTION: Recursively Extract Firefox Bookmarks from Decoded JSON
# ============================================================================
function Get-FirefoxBookmarkChildren {
    <#
    .SYNOPSIS
        Walks Firefox's nested bookmark JSON structure.
        Containers use type "text/x-moz-place-container"; bookmarks "text/x-moz-place".
        dateAdded is in microseconds since Unix epoch.
    #>

    param(
        [PSCustomObject]$Node,
        [string]$ParentFolder = "",
        [string]$BrowserName = "Firefox"
    )

    $results = @()
    if ($null -eq $Node) { return $results }

    if ($Node.children) {
        foreach ($child in $Node.children) {
            $currentFolder = $ParentFolder

            if ($child.type -eq "text/x-moz-place-container") {
                $folderName = if ($child.title) { $child.title } elseif ($child.root) { $child.root } else { "(unnamed)" }
                if ($ParentFolder) {
                    $currentFolder = "$ParentFolder / $folderName"
                } else {
                    $currentFolder = $folderName
                }
                $results += Get-FirefoxBookmarkChildren -Node $child -ParentFolder $currentFolder -BrowserName $BrowserName
            }
            elseif ($child.type -eq "text/x-moz-place") {
                $dateAdded = ""
                if ($child.dateAdded) {
                    try {
                        # Firefox stores microseconds since Unix epoch (PRTime)
                        $baseDate = [datetime]::new(1970,1,1,0,0,0,[DateTimeKind]::Utc)
                        $dateAdded = $baseDate.AddTicks([int64]$child.dateAdded * 10).ToLocalTime()
                    } catch { $dateAdded = "" }
                }
                $results += [PSCustomObject]@{
                    Title     = $child.title
                    URL       = $child.uri
                    Folder    = $currentFolder
                    Browser   = $BrowserName
                    DateAdded = $dateAdded
                }
            }
            # text/x-moz-place-separator is intentionally ignored
        }
    }

    return $results
}

# ============================================================================
# FUNCTION: Extract Firefox Bookmarks from Latest jsonlz4 Backup
# ============================================================================
function Get-FirefoxBookmarksFromBackup {
    <#
    .SYNOPSIS
        Locates the most recent bookmarkbackups/*.jsonlz4 in a Firefox profile,
        decompresses it, and returns the parsed bookmark objects.
    #>

    param(
        [string]$ProfilePath
    )

    $backupDir = Join-Path $ProfilePath "bookmarkbackups"
    if (-not (Test-Path $backupDir)) { return $null }

    $latest = Get-ChildItem $backupDir -Filter "*.jsonlz4" -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1

    if (-not $latest) { return $null }

    Write-Host "[FIREFOX] Using backup: $($latest.Name)" -ForegroundColor Green

    try {
        $bytes = [System.IO.File]::ReadAllBytes($latest.FullName)
        $json = Expand-MozLz4 -Data $bytes
        $tree = $json | ConvertFrom-Json
        return @{
            Bookmarks  = Get-FirefoxBookmarkChildren -Node $tree -BrowserName "Firefox"
            SourceFile = $latest.FullName
        }
    } catch {
        $script:errors += "[Firefox] Failed to decode backup '$($latest.Name)': $_"
        return $null
    }
}

# ============================================================================
# FUNCTION: Pure-PowerShell Mini SQLite Reader for Firefox places.sqlite
# ============================================================================
function Get-FirefoxBookmarksFromSqlite {
    <#
    .SYNOPSIS
        Reads bookmarks directly from places.sqlite without any module or external
        binary. Handles the common SQLite b-tree leaf format used by Firefox's
        moz_bookmarks and moz_places tables. Records that overflow pages are
        attempted via the overflow chain; truly malformed records are skipped
        with a warning count rather than aborting the whole read.

    .NOTES
        Limitations:
        - WAL changes (uncommitted in-memory) are not read; close Firefox first.
        - Index b-trees are not used; the script linearly scans the table b-tree.
    #>

    param(
        [string]$ProfilePath
    )

    $placesPath = Join-Path $ProfilePath "places.sqlite"
    if (-not (Test-Path $placesPath)) { return $null }

    # Warn if WAL is non-empty (Firefox running may have unflushed changes)
    $walPath = "$placesPath-wal"
    if ((Test-Path $walPath) -and ((Get-Item $walPath).Length -gt 32)) {
        Write-Warning "[Firefox] places.sqlite-wal contains pending changes. Close Firefox for the freshest data."
    }

    $srcSize = (Get-Item $placesPath).Length
    Write-Host "[FIREFOX] places.sqlite size: $([Math]::Round($srcSize / 1MB, 2)) MB" -ForegroundColor Gray

    # Copy to temp (file is locked while Firefox is open). Use .NET APIs to avoid
    # PowerShell path-provider issues with 8.3 short paths like C:\Users\JASON~1.LAM
    $tempCopy = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "places_$([guid]::NewGuid().Guid).sqlite")
    Write-Host "[FIREFOX] Copying places.sqlite to temp..." -ForegroundColor Gray
    $copyStart = [DateTime]::Now
    try {
        [System.IO.File]::Copy($placesPath, $tempCopy, $true)
    } catch {
        $script:errors += "[Firefox] Could not copy places.sqlite: $_"
        return $null
    }
    Write-Host "[FIREFOX] Copy complete in $([Math]::Round(([DateTime]::Now - $copyStart).TotalSeconds, 2))s" -ForegroundColor Gray

    Write-Host "[FIREFOX] Loading bytes into memory..." -ForegroundColor Gray
    $loadStart = [DateTime]::Now
    try {
        $bytes = [System.IO.File]::ReadAllBytes($tempCopy)
    } finally {
        try { [System.IO.File]::Delete($tempCopy) } catch { }
    }
    Write-Host "[FIREFOX] Loaded $($bytes.Length) bytes in $([Math]::Round(([DateTime]::Now - $loadStart).TotalSeconds, 2))s" -ForegroundColor Gray

    if ($bytes.Length -lt 100) {
        $script:errors += "[Firefox] places.sqlite is too small to be valid"
        return $null
    }

    # --- SQLite header parsing ---
    $headerMagic = [System.Text.Encoding]::ASCII.GetString($bytes, 0, 15)
    if ($headerMagic -ne "SQLite format 3") {
        $script:errors += "[Firefox] places.sqlite is not a SQLite 3 file"
        return $null
    }

    # Page size: big-endian uint16 at offset 16; value 1 means 65536
    $pageSizeRaw = ([int]$bytes[16] -shl 8) -bor [int]$bytes[17]
    $pageSize = if ($pageSizeRaw -eq 1) { 65536 } else { $pageSizeRaw }
    $reservedSpace = [int]$bytes[20]
    $usableSize = $pageSize - $reservedSpace
    Write-Host "[FIREFOX] Page size: $pageSize, total pages: $([Math]::Floor($bytes.Length / $pageSize))" -ForegroundColor Gray

    # --- Helper: read varint (1-9 bytes, big-endian) ---
    $readVarint = {
        param([byte[]]$Buf, [int]$Offset)
        $value = [int64]0
        for ($i = 0; $i -lt 8; $i++) {
            $b = $Buf[$Offset + $i]
            $value = ($value -shl 7) -bor ($b -band 0x7F)
            if (($b -band 0x80) -eq 0) {
                return @($value, $i + 1)
            }
        }
        # 9th byte: full 8 bits
        $value = ($value -shl 8) -bor $Buf[$Offset + 8]
        return @($value, 9)
    }

    # --- Helper: extract page bytes (pages are 1-indexed) ---
    $getPage = {
        param([int]$PageNum)
        $start = ($PageNum - 1) * $pageSize
        if ($start + $pageSize -gt $bytes.Length) { return $null }
        $page = New-Object byte[] $pageSize
        [Array]::Copy($bytes, $start, $page, 0, $pageSize)
        return $page
    }

    # --- Helper: read overflow chain ---
    $readOverflow = {
        param([int]$FirstPage, [int]$RemainingBytes)
        $collected = New-Object System.Collections.Generic.List[byte]
        $pageNum = $FirstPage
        while ($pageNum -ne 0 -and $RemainingBytes -gt 0) {
            $ovPage = & $getPage $pageNum
            if (-not $ovPage) { break }
            $nextPage = ([int]$ovPage[0] -shl 24) -bor ([int]$ovPage[1] -shl 16) -bor ([int]$ovPage[2] -shl 8) -bor [int]$ovPage[3]
            $available = [Math]::Min($RemainingBytes, $usableSize - 4)
            for ($k = 0; $k -lt $available; $k++) { $collected.Add($ovPage[4 + $k]) }
            $RemainingBytes -= $available
            $pageNum = $nextPage
        }
        return ,$collected.ToArray()
    }

    # --- Helper: parse a table-leaf b-tree page into records ---
    $parseLeafPage = {
        param([byte[]]$Page, [int]$PageOffset)
        # Page header: type(1) + freeblock(2) + ncells(2) + cellstart(2) + frags(1) = 8 bytes for leaves
        $type = $Page[$PageOffset]
        if ($type -ne 0x0D) { return @() }
        $nCells = ([int]$Page[$PageOffset + 3] -shl 8) -bor [int]$Page[$PageOffset + 4]
        $cellArrayStart = $PageOffset + 8

        $records = [System.Collections.Generic.List[object]]::new($nCells)
        for ($c = 0; $c -lt $nCells; $c++) {
            $ptr = ([int]$Page[$cellArrayStart + ($c * 2)] -shl 8) -bor [int]$Page[$cellArrayStart + ($c * 2) + 1]
            $cellOffset = $ptr
            try {
                # Read payload size varint
                $vr = & $readVarint $Page $cellOffset
                $payloadSize = [int64]$vr[0]; $cellOffset += [int]$vr[1]
                # Read rowid varint
                $vr = & $readVarint $Page $cellOffset
                $rowid = [int64]$vr[0]; $cellOffset += [int]$vr[1]

                # Determine how many bytes are stored on this page vs overflow
                $maxLocal = $usableSize - 35
                $minLocal = [int][Math]::Floor((($usableSize - 12) * 32.0 / 255.0) - 23)
                if ($payloadSize -le $maxLocal) {
                    $localBytes = [int]$payloadSize
                    $hasOverflow = $false
                } else {
                    $localBytes = $minLocal + (($payloadSize - $minLocal) % ($usableSize - 4))
                    if ($localBytes -gt $maxLocal) { $localBytes = $minLocal }
                    $hasOverflow = $true
                }

                # Read local payload bytes
                $payload = New-Object byte[] $payloadSize
                [Array]::Copy($Page, $cellOffset, $payload, 0, [Math]::Min($localBytes, [int]$payloadSize))

                if ($hasOverflow -and $payloadSize -gt $localBytes) {
                    $overflowPageNum = ([int]$Page[$cellOffset + $localBytes] -shl 24) -bor
                                       ([int]$Page[$cellOffset + $localBytes + 1] -shl 16) -bor
                                       ([int]$Page[$cellOffset + $localBytes + 2] -shl 8) -bor
                                       [int]$Page[$cellOffset + $localBytes + 3]
                    $remaining = [int]($payloadSize - $localBytes)
                    $ovBytes = & $readOverflow $overflowPageNum $remaining
                    [Array]::Copy($ovBytes, 0, $payload, $localBytes, $ovBytes.Length)
                }

                [void]$records.Add([PSCustomObject]@{ RowId = $rowid; Payload = $payload })
            } catch {
                # Skip malformed cells silently and keep going
                continue
            }
        }
        return ,$records
    }

    # --- Helper: walk a table b-tree (root page may be interior or leaf) ---
    $walkTable = {
        param([int]$RootPageNum)
        $allRecords = [System.Collections.Generic.List[object]]::new()
        $visited = [System.Collections.Generic.HashSet[int]]::new()
        $stack = New-Object System.Collections.Stack
        $stack.Push($RootPageNum)
        $totalPages = [Math]::Floor($bytes.Length / $pageSize)
        $pagesProcessed = 0
        while ($stack.Count -gt 0) {
            $pn = $stack.Pop()
            # Guard against cycles, out-of-range pages, and the special page 0 sentinel
            if ($pn -le 0 -or $pn -gt $totalPages) { continue }
            if (-not $visited.Add([int]$pn)) { continue }
            $page = & $getPage $pn
            if (-not $page) { continue }
            $pagesProcessed++
            # Page 1 has the 100-byte database header before its b-tree header
            $offset = if ($pn -eq 1) { 100 } else { 0 }
            $type = $page[$offset]
            if ($type -eq 0x0D) {
                # Leaf table page
                $leafRecs = & $parseLeafPage $page $offset
                if ($leafRecs -and $leafRecs.Count -gt 0) {
                    $allRecords.AddRange([object[]]$leafRecs)
                }
            } elseif ($type -eq 0x05) {
                # Interior table page: header is 12 bytes (incl. rightmost child pointer)
                $nCells = ([int]$page[$offset + 3] -shl 8) -bor [int]$page[$offset + 4]
                $rightmost = ([int]$page[$offset + 8] -shl 24) -bor ([int]$page[$offset + 9] -shl 16) -bor ([int]$page[$offset + 10] -shl 8) -bor [int]$page[$offset + 11]
                $cellArrayStart = $offset + 12
                $stack.Push($rightmost)
                for ($c = $nCells - 1; $c -ge 0; $c--) {
                    $ptr = ([int]$page[$cellArrayStart + ($c * 2)] -shl 8) -bor [int]$page[$cellArrayStart + ($c * 2) + 1]
                    $leftChild = ([int]$page[$ptr] -shl 24) -bor ([int]$page[$ptr + 1] -shl 16) -bor ([int]$page[$ptr + 2] -shl 8) -bor [int]$page[$ptr + 3]
                    $stack.Push($leftChild)
                }
            }
            # Periodic progress for very large b-trees
            if (($pagesProcessed % 500) -eq 0) {
                Write-Host "[FIREFOX]   ...walked $pagesProcessed pages, $($allRecords.Count) records so far" -ForegroundColor DarkGray
            }
        }
        return ,$allRecords
    }

    # --- Helper: decode a SQLite record payload into column values ---
    # IMPORTANT: $values uses List<object> instead of @() because PowerShell's
    # `$arr += $null` is a no-op (silently drops the null), which would shift
    # subsequent column indices and break positional schema reads.
    $decodeRecord = {
        param([byte[]]$Payload)
        $values = [System.Collections.Generic.List[object]]::new()
        $vr = & $readVarint $Payload 0
        $headerSize = [int]$vr[0]
        $hdrPos = [int]$vr[1]
        if ($headerSize -le 0 -or $headerSize -gt $Payload.Length -or $headerSize -gt 4096) {
            throw "Invalid record header size: $headerSize (payload=$($Payload.Length))"
        }
        $bodyPos = $headerSize
        $serialTypes = [System.Collections.Generic.List[int64]]::new()
        while ($hdrPos -lt $headerSize -and $serialTypes.Count -lt 200) {
            $vr = & $readVarint $Payload $hdrPos
            [void]$serialTypes.Add([int64]$vr[0])
            $advance = [int]$vr[1]
            if ($advance -le 0) { break }
            $hdrPos += $advance
        }
        foreach ($st in $serialTypes) {
            switch ([int64]$st) {
                0 { [void]$values.Add($null) }
                1 { [void]$values.Add([int64][sbyte]$Payload[$bodyPos]); $bodyPos += 1 }
                2 { $v = ([int]$Payload[$bodyPos] -shl 8) -bor [int]$Payload[$bodyPos+1]; if ($v -band 0x8000) { $v = $v - 0x10000 }; [void]$values.Add([int64]$v); $bodyPos += 2 }
                3 { $v = ([int]$Payload[$bodyPos] -shl 16) -bor ([int]$Payload[$bodyPos+1] -shl 8) -bor [int]$Payload[$bodyPos+2]; if ($v -band 0x800000) { $v = $v - 0x1000000 }; [void]$values.Add([int64]$v); $bodyPos += 3 }
                4 { $v = ([int64]$Payload[$bodyPos] -shl 24) -bor ([int64]$Payload[$bodyPos+1] -shl 16) -bor ([int64]$Payload[$bodyPos+2] -shl 8) -bor [int64]$Payload[$bodyPos+3]; if ($v -band 0x80000000) { $v = $v - 0x100000000 }; [void]$values.Add($v); $bodyPos += 4 }
                5 {
                    $v = [int64]0
                    for ($i = 0; $i -lt 6; $i++) { $v = ($v -shl 8) -bor [int64]$Payload[$bodyPos + $i] }
                    if ($v -band 0x800000000000) { $v = $v - 0x1000000000000 }
                    [void]$values.Add($v); $bodyPos += 6
                }
                6 {
                    $v = [int64]0
                    for ($i = 0; $i -lt 8; $i++) { $v = ($v -shl 8) -bor [int64]$Payload[$bodyPos + $i] }
                    [void]$values.Add($v); $bodyPos += 8
                }
                7 {
                    $tmp = New-Object byte[] 8
                    for ($i = 0; $i -lt 8; $i++) { $tmp[7 - $i] = $Payload[$bodyPos + $i] }
                    [void]$values.Add([BitConverter]::ToDouble($tmp, 0))
                    $bodyPos += 8
                }
                8 { [void]$values.Add([int64]0) }
                9 { [void]$values.Add([int64]1) }
                default {
                    if ($st -ge 12) {
                        if (($st -band 1) -eq 0) {
                            $len = [int](($st - 12) / 2)
                            $blob = New-Object byte[] $len
                            if ($len -gt 0) { [Array]::Copy($Payload, $bodyPos, $blob, 0, $len) }
                            [void]$values.Add($blob)
                            $bodyPos += $len
                        } else {
                            $len = [int](($st - 13) / 2)
                            $text = if ($len -gt 0) { [System.Text.Encoding]::UTF8.GetString($Payload, $bodyPos, $len) } else { "" }
                            [void]$values.Add($text)
                            $bodyPos += $len
                        }
                    } else {
                        [void]$values.Add($null)
                    }
                }
            }
        }
        return ,$values
    }

    # --- Read sqlite_master (root page 1) to find target tables ---
    Write-Host "[FIREFOX] Walking sqlite_master (page 1)..." -ForegroundColor Gray
    $masterStart = [DateTime]::Now
    $masterRecords = & $walkTable 1
    Write-Host "[FIREFOX] sqlite_master walk: $($masterRecords.Count) records in $([Math]::Round(([DateTime]::Now - $masterStart).TotalSeconds, 2))s" -ForegroundColor Gray

    $tableRoots = @{}
    $decodeIdx = 0
    $decodeStart = [DateTime]::Now
    foreach ($rec in $masterRecords) {
        $decodeIdx++
        try {
            # Diagnostic: hex dump first 24 bytes of payload for record 1 to verify alignment
            if ($decodeIdx -eq 1) {
                $hexBytes = for ($i = 0; $i -lt [Math]::Min(24, $rec.Payload.Length); $i++) { "{0:X2}" -f $rec.Payload[$i] }
                $asciiBytes = for ($i = 0; $i -lt [Math]::Min(24, $rec.Payload.Length); $i++) {
                    $b = $rec.Payload[$i]
                    if ($b -ge 0x20 -and $b -lt 0x7F) { [char]$b } else { '.' }
                }
                Write-Host "[FIREFOX]   rec 1 first 24 hex: $($hexBytes -join ' ')" -ForegroundColor DarkGray
                Write-Host "[FIREFOX]   rec 1 ascii:        $($asciiBytes -join '  ')" -ForegroundColor DarkGray
                Write-Host "[FIREFOX]   rec 1 rowid: $($rec.RowId)" -ForegroundColor DarkGray
            }
            $cols = & $decodeRecord $rec.Payload
            if ($decodeIdx -le 3) {
                $colSummary = for ($i = 0; $i -lt [Math]::Min($cols.Count, 5); $i++) {
                    $v = $cols[$i]
                    if ($null -eq $v) { '<null>' }
                    elseif ($v -is [byte[]]) { "<blob:$($v.Length)>" }
                    elseif ($v -is [string]) { "`"$(if ($v.Length -gt 40) { $v.Substring(0,40) + '...' } else { $v })`"" }
                    else { "$v" }
                }
                Write-Host "[FIREFOX]   rec $decodeIdx/$($masterRecords.Count) (payload=$($rec.Payload.Length), cols=$($cols.Count)): $($colSummary -join ' | ')" -ForegroundColor DarkGray
            }
            # sqlite_master columns: type, name, tbl_name, rootpage, sql
            if ($cols.Count -ge 4 -and $cols[0] -eq 'table') {
                $tableRoots[$cols[1]] = [int]$cols[3]
            }
        } catch {
            if ($decodeIdx -le 12) {
                Write-Host "[FIREFOX]   rec $decodeIdx skipped: $_" -ForegroundColor DarkYellow
            }
        }
    }
    Write-Host "[FIREFOX] sqlite_master decode: $([Math]::Round(([DateTime]::Now - $decodeStart).TotalSeconds, 2))s, $($masterRecords.Count) records processed" -ForegroundColor Gray
    Write-Host "[FIREFOX] Found $($tableRoots.Count) tables: $(($tableRoots.Keys | Sort-Object) -join ', ')" -ForegroundColor Gray

    if (-not $tableRoots.ContainsKey('moz_bookmarks') -or -not $tableRoots.ContainsKey('moz_places')) {
        $script:errors += "[Firefox] places.sqlite is missing expected tables (moz_bookmarks / moz_places)"
        return $null
    }

    # --- Read moz_bookmarks FIRST so we know which moz_places rows we need ---
    Write-Host "[FIREFOX] Reading moz_bookmarks (root page $($tableRoots['moz_bookmarks']))..." -ForegroundColor Cyan
    $bmStart = [DateTime]::Now
    $bookmarkRecords = & $walkTable $tableRoots['moz_bookmarks']
    Write-Host "[FIREFOX] moz_bookmarks walk: $($bookmarkRecords.Count) records in $([Math]::Round(([DateTime]::Now - $bmStart).TotalSeconds, 2))s" -ForegroundColor Gray
    $bmRows = [System.Collections.Generic.List[object]]::new()
    $bmById = @{}
    $wantedFks = [System.Collections.Generic.HashSet[int64]]::new()
    foreach ($rec in $bookmarkRecords) {
        try {
            $cols = & $decodeRecord $rec.Payload
            # Schema (Firefox ~v90+): id, type, fk, parent, position, title, keyword_id, folder_type, dateAdded, lastModified, guid, ...
            if ($cols.Count -lt 6) { continue }
            $row = [PSCustomObject]@{
                Id         = [int64]$rec.RowId
                Type       = if ($null -ne $cols[1]) { [int]$cols[1] } else { 0 }
                Fk         = if ($null -ne $cols[2]) { [int64]$cols[2] } else { $null }
                Parent     = if ($null -ne $cols[3]) { [int64]$cols[3] } else { $null }
                Title      = [string]$cols[5]
                DateAdded  = if ($cols.Count -gt 8 -and $null -ne $cols[8]) { [int64]$cols[8] } else { $null }
            }
            [void]$bmRows.Add($row)
            $bmById[$row.Id] = $row
            if ($row.Type -eq 1 -and $row.Fk) { [void]$wantedFks.Add([int64]$row.Fk) }
        } catch { }
    }
    Write-Host "[FIREFOX] Found $($bmRows.Count) bookmark rows ($($wantedFks.Count) URL refs)" -ForegroundColor Gray

    # --- Read moz_places, but only keep URLs referenced by bookmarks ---
    Write-Host "[FIREFOX] Reading moz_places (root page $($tableRoots['moz_places']))..." -ForegroundColor Cyan
    $placesStart = [DateTime]::Now
    $placesRecords = & $walkTable $tableRoots['moz_places']
    Write-Host "[FIREFOX] moz_places walk: $($placesRecords.Count) records in $([Math]::Round(([DateTime]::Now - $placesStart).TotalSeconds, 2))s" -ForegroundColor Gray
    $urlById = @{}
    foreach ($rec in $placesRecords) {
        $rowId = [int64]$rec.RowId
        if (-not $wantedFks.Contains($rowId)) { continue }
        try {
            $cols = & $decodeRecord $rec.Payload
            # moz_places: id(0), url(1), title(2), ...   id col is NULL (rowid alias)
            if ($cols.Count -ge 2) {
                $urlById[$rowId] = [string]$cols[1]
            }
        } catch { }
    }

    # --- Build folder name lookup ---
    $folderById = @{}
    foreach ($row in $bmRows) {
        if ($row.Type -eq 2) { $folderById[$row.Id] = $row.Title }
    }

    # --- Resolve folder path by walking parent chain (uses $bmById hashtable, O(1)) ---
    $folderPathCache = @{}
    $resolvePath = {
        param([int64]$Id)
        if ($folderPathCache.ContainsKey($Id)) { return $folderPathCache[$Id] }
        $parts = New-Object System.Collections.Generic.List[string]
        $cur = $Id
        $guard = 0
        while ($cur -and $bmById.ContainsKey($cur) -and $guard -lt 100) {
            $parentRow = $bmById[$cur]
            if ($parentRow.Title) { $parts.Insert(0, $parentRow.Title) }
            if (-not $parentRow.Parent) { break }
            $cur = $parentRow.Parent
            $guard++
        }
        $result = ($parts -join " / ").Trim('/').Trim()
        $folderPathCache[$Id] = $result
        return $result
    }

    # --- Emit bookmark rows ---
    $results = [System.Collections.Generic.List[object]]::new()
    foreach ($row in $bmRows) {
        if ($row.Type -ne 1 -or -not $row.Fk) { continue }   # Only URL bookmarks
        $url = $urlById[$row.Fk]
        if (-not $url) { continue }

        $folder = & $resolvePath $row.Parent
        $dateAdded = ""
        if ($row.DateAdded) {
            try {
                $baseDate = [datetime]::new(1970,1,1,0,0,0,[DateTimeKind]::Utc)
                $dateAdded = $baseDate.AddTicks($row.DateAdded * 10).ToLocalTime()
            } catch { $dateAdded = "" }
        }

        [void]$results.Add([PSCustomObject]@{
            Title     = $row.Title
            URL       = $url
            Folder    = $folder
            Browser   = "Firefox"
            DateAdded = $dateAdded
        })
    }

    return @{
        Bookmarks  = $results.ToArray()
        SourceFile = $placesPath
    }
}

# ============================================================================
# FUNCTION: Copy Raw Firefox Bookmark Files to Export Folder (for migration)
# ============================================================================
function Copy-FirefoxRawFiles {
    <#
    .SYNOPSIS
        Copies the latest jsonlz4 backup and (optionally) places.sqlite to the
        export folder. The jsonlz4 file can be restored on another machine via
        Firefox > Manage Bookmarks > Import and Backup > Restore.
    #>

    param(
        [string]$ProfilePath,
        [string]$ExportPath,
        [string]$Timestamp
    )

    $copied = @()

    # Copy newest jsonlz4 backup if present
    $backupDir = Join-Path $ProfilePath "bookmarkbackups"
    if (Test-Path $backupDir) {
        $latest = Get-ChildItem $backupDir -Filter "*.jsonlz4" -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($latest) {
            $dest = Join-Path $ExportPath "firefox-backup_${Timestamp}.jsonlz4"
            try {
                Copy-Item -Path $latest.FullName -Destination $dest -ErrorAction Stop
                $copied += (Split-Path $dest -Leaf)
            } catch {
                $script:errors += "[Firefox] Could not copy backup: $_"
            }
        }
    }

    # Copy places.sqlite for full migration (optional, larger file)
    $placesPath = Join-Path $ProfilePath "places.sqlite"
    if (Test-Path $placesPath) {
        $dest = Join-Path $ExportPath "firefox-places_${Timestamp}.sqlite"
        try {
            Copy-Item -Path $placesPath -Destination $dest -ErrorAction Stop
            $copied += (Split-Path $dest -Leaf)
        } catch {
            $script:errors += "[Firefox] Could not copy places.sqlite: $_"
        }
    }

    return $copied
}

# ============================================================================
# FUNCTION: Export to CSV
# ============================================================================
function Export-BookmarksCSV {
    param(
        [PSCustomObject[]]$Bookmarks,
        [string]$OutputPath
    )
    
    try {
        $Bookmarks | Select-Object Title, URL, Folder, Browser, DateAdded | 
            Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8
        Write-Host "[CSV] Exported to: $OutputPath" -ForegroundColor Green
        return $true
    } catch {
        $script:errors += "CSV export failed: $_"
        return $false
    }
}

# ============================================================================
# FUNCTION: Export to JSON
# ============================================================================
function Export-BookmarksJSON {
    param(
        [PSCustomObject[]]$Bookmarks,
        [string]$OutputPath
    )
    
    try {
        $json = $Bookmarks | ConvertTo-Json -Depth 10
        Set-Content -Path $OutputPath -Value $json -Encoding UTF8
        Write-Host "[JSON] Exported to: $OutputPath" -ForegroundColor Green
        return $true
    } catch {
        $script:errors += "JSON export failed: $_"
        return $false
    }
}

# ============================================================================
# FUNCTION: Export to HTML (Netscape Format)
# ============================================================================
function Export-BookmarksHTML {
    param(
        [PSCustomObject[]]$Bookmarks,
        [string]$OutputPath
    )
    
    try {
        $html = @"
<!DOCTYPE NETSCAPE-Bookmark-file-1>
<!-- This is an auto-generated file. -->
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<TITLE>Bookmarks</TITLE>
<H1>Bookmarks</H1>
<DL><p>
"@
        
        # Group by folder and browser
        $grouped = $Bookmarks | Group-Object -Property Folder, Browser
        
        foreach ($group in $grouped) {
            $folderInfo = $group.Name -split ", "
            $folder = $folderInfo[0]
            $browser = $folderInfo[1]
            
            $html += "`n    <DT><H3>$folder ($browser)</H3>`n    <DL><p>`n"
            
            foreach ($bookmark in $group.Group) {
                $addTime = if ($bookmark.DateAdded) { [int64]([datetime]$bookmark.DateAdded).ToFileTime() } else { "0" }
                $html += "        <DT><A HREF=`"$($bookmark.URL)`" ADD_DATE=`"$addTime`">$($bookmark.Title)</A>`n"
            }
            
            $html += "    </DL><p>`n"
        }
        
        $html += @"
</DL><p>
</BODY>
</HTML>
"@
        
        Set-Content -Path $OutputPath -Value $html -Encoding UTF8
        Write-Host "[HTML] Exported to: $OutputPath" -ForegroundColor Green
        return $true
    } catch {
        $script:errors += "HTML export failed: $_"
        return $false
    }
}

# ============================================================================
# MAIN SCRIPT
# ============================================================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Browser Bookmarks Export" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Determine export path
if (-not $ExportPath) {
    if ($env:OneDriveCommercial) {
        $ExportPath = Join-Path $env:OneDriveCommercial "Documents\! Bookmark Export"
        Write-Host "OneDrive (Commercial) detected: $ExportPath" -ForegroundColor Green
    } else {
        $ExportPath = if ($PSExports) { $PSExports } else { $PSScriptRoot }
        Write-Host "OneDriveCommercial not found, using: $ExportPath" -ForegroundColor Yellow
    }
}

if (-not (Test-Path $ExportPath)) {
    New-Item -ItemType Directory -Path $ExportPath -Force | Out-Null
    Write-Host "Created export folder: $ExportPath" -ForegroundColor Yellow
}

Write-Host "Export path: $ExportPath" -ForegroundColor Cyan

# ============================================================================
# Extract Chrome Bookmarks
# ============================================================================
if ($IncludeChrome) {
    Write-Host "`n[CHROME] Extracting bookmarks..." -ForegroundColor Cyan
    $chromeBookmarksPath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Bookmarks"
    $chromeContent = Get-BookmarksFile -FilePath $chromeBookmarksPath -BrowserName "Chrome"

    if ($chromeContent) {
        try {
            $chromeJson = $chromeContent | ConvertFrom-Json
            $chromeBookmarks = @()
            foreach ($rootName in @('bookmark_bar', 'other', 'synced')) {
                $rootNode = $chromeJson.roots.$rootName
                if ($rootNode) {
                    $chromeBookmarks += Get-BookmarkChildren -Node $rootNode -ParentFolder $rootNode.name -BrowserName "Chrome"
                }
            }
            $bookmarks += $chromeBookmarks
            Write-Host "Chrome: $($chromeBookmarks.Count) bookmarks found" -ForegroundColor Green
        } catch {
            $script:errors += "Chrome JSON parsing failed: $_"
            Write-Warning "Failed to parse Chrome bookmarks"
        }
    }
}

# ============================================================================
# Extract Edge Bookmarks
# ============================================================================
if ($IncludeEdge) {
    Write-Host "`n[EDGE] Extracting bookmarks..." -ForegroundColor Cyan
    $edgeBookmarksPath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Bookmarks"
    $edgeContent = Get-BookmarksFile -FilePath $edgeBookmarksPath -BrowserName "Edge"

    if ($edgeContent) {
        try {
            $edgeJson = $edgeContent | ConvertFrom-Json
            $edgeBookmarks = @()
            foreach ($rootName in @('bookmark_bar', 'other', 'synced')) {
                $rootNode = $edgeJson.roots.$rootName
                if ($rootNode) {
                    $edgeBookmarks += Get-BookmarkChildren -Node $rootNode -ParentFolder $rootNode.name -BrowserName "Edge"
                }
            }
            $bookmarks += $edgeBookmarks
            Write-Host "Edge: $($edgeBookmarks.Count) bookmarks found" -ForegroundColor Green
        } catch {
            $script:errors += "Edge JSON parsing failed: $_"
            Write-Warning "Failed to parse Edge bookmarks"
        }
    }
}

# ============================================================================
# Extract Firefox Bookmarks (jsonlz4 backup -> SQLite fallback)
# ============================================================================
if ($IncludeFirefox) {
    Write-Host "`n[FIREFOX] Extracting bookmarks..." -ForegroundColor Cyan
    $firefoxProfile = Get-FirefoxProfilePath

    if (-not $firefoxProfile) {
        Write-Host "Firefox not detected (no profile found)" -ForegroundColor Yellow
    } else {
        Write-Host "Firefox profile: $firefoxProfile" -ForegroundColor Gray
        $firefoxResult = Get-FirefoxBookmarksFromBackup -ProfilePath $firefoxProfile

        if (-not $firefoxResult -or $firefoxResult.Bookmarks.Count -eq 0) {
            Write-Host "[FIREFOX] No jsonlz4 backup found; reading places.sqlite directly..." -ForegroundColor Yellow
            $firefoxResult = Get-FirefoxBookmarksFromSqlite -ProfilePath $firefoxProfile
        }

        if ($firefoxResult -and $firefoxResult.Bookmarks.Count -gt 0) {
            $bookmarks += $firefoxResult.Bookmarks
            Write-Host "Firefox: $($firefoxResult.Bookmarks.Count) bookmarks found" -ForegroundColor Green
        } else {
            Write-Warning "[Firefox] No bookmarks could be read. To migrate manually: in Firefox, Bookmarks > Manage Bookmarks > Import and Backup > Export Bookmarks to HTML."
        }
    }
}

# ============================================================================
# Export to Selected Formats
# ============================================================================
if ($bookmarks.Count -eq 0) {
    Write-Warning "No bookmarks found to export"
    exit 1
}

Write-Host "`nTotal bookmarks: $($bookmarks.Count)" -ForegroundColor Cyan
Write-Host "`n[EXPORT] Writing files..." -ForegroundColor Cyan

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

if ($Formats -contains 'CSV') {
    $csvPath = Join-Path $ExportPath "bookmarks_$timestamp.csv"
    if (Export-BookmarksCSV -Bookmarks $bookmarks -OutputPath $csvPath) {
        $exportedFiles += "bookmarks_$timestamp.csv"
    }
}

if ($Formats -contains 'JSON') {
    $jsonPath = Join-Path $ExportPath "bookmarks_$timestamp.json"
    if (Export-BookmarksJSON -Bookmarks $bookmarks -OutputPath $jsonPath) {
        $exportedFiles += "bookmarks_$timestamp.json"
    }
}

if ($Formats -contains 'HTML') {
    $htmlPath = Join-Path $ExportPath "bookmarks_$timestamp.html"
    if (Export-BookmarksHTML -Bookmarks $bookmarks -OutputPath $htmlPath) {
        $exportedFiles += "bookmarks_$timestamp.html"
    }
}

# ============================================================================
# Copy Firefox Raw Files (portable migration backup)
# ============================================================================
if ($IncludeFirefox -and $CopyFirefoxRawFiles -and $firefoxProfile) {
    Write-Host "`n[FIREFOX] Copying raw backup files for portable migration..." -ForegroundColor Cyan
    $rawCopied = Copy-FirefoxRawFiles -ProfilePath $firefoxProfile -ExportPath $ExportPath -Timestamp $timestamp
    foreach ($f in $rawCopied) {
        Write-Host "[FIREFOX] Copied: $f" -ForegroundColor Green
        $exportedFiles += $f
    }
}

# ============================================================================
# Summary
# ============================================================================
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Export Complete" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "`nSave Location : $ExportPath" -ForegroundColor Cyan
if ($exportedFiles.Count -gt 0) {
    Write-Host "Files Exported:" -ForegroundColor Cyan
    $exportedFiles | ForEach-Object { Write-Host "  - $_" -ForegroundColor White }
}

if ($errors.Count -gt 0) {
    Write-Host "`nWarnings/Errors:" -ForegroundColor Yellow
    $errors | ForEach-Object { Write-Host "  - $_" }
}

Start-Process explorer.exe $ExportPath

# Example Usage:
# .\get-browser-bookmarks.ps1
# .\get-browser-bookmarks.ps1 -ExportPath "C:\temp"
# .\get-browser-bookmarks.ps1 -Formats 'CSV', 'JSON'
# .\get-browser-bookmarks.ps1 -IncludeChrome $false
# .\get-browser-bookmarks.ps1 -IncludeFirefox $false
# .\get-browser-bookmarks.ps1 -CopyFirefoxRawFiles $false  (skip copying jsonlz4 + places.sqlite to export folder)

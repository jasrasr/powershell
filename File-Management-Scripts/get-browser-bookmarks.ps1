#Requires -Version 5.1
<#
.SYNOPSIS
    Extracts browser bookmarks from Chrome and Edge, exports to OneDrive root in multiple formats.

.DESCRIPTION
    Retrieves bookmarks from Google Chrome and Microsoft Edge, merges them, and exports to
    OneDrive root directory in CSV, JSON, and HTML (Netscape) formats. Handles browser file locks
    by copying bookmarks to temp location if needed. Recursively processes folder structures.

.PARAMETER ExportPath
    Path to export bookmarks. Defaults to OneDrive root if detected, otherwise $PSExports.

.PARAMETER Formats
    Array of export formats: 'CSV', 'JSON', 'HTML'. Defaults to all three.

.PARAMETER IncludeChrome
    Include Chrome bookmarks. Defaults to $true.

.PARAMETER IncludeEdge
    Include Edge bookmarks. Defaults to $true.

.EXAMPLE
    .\get-browser-bookmarks.ps1
    Exports all bookmarks to OneDrive root in CSV, JSON, and HTML formats.

.EXAMPLE
    .\get-browser-bookmarks.ps1 -ExportPath "C:\temp" -Formats 'CSV', 'JSON'
    Exports bookmarks to C:\temp in CSV and JSON formats only.

.NOTES
    Author: Jason Lamb with help from Claude Code
    Created: 2026-04-30
    Modified: 2026-05-05
    Changelog:
        1.0.0 - Initial release; Chrome/Edge extraction, OneDrive detection, multi-format export
        1.0.1 - Changed default export path to $env:OneDriveCommercial\Documents; added export summary

#>

param(
    [string]$ExportPath,
    [ValidateSet('CSV', 'JSON', 'HTML')]
    [string[]]$Formats = @('CSV', 'JSON', 'HTML'),
    [bool]$IncludeChrome = $true,
    [bool]$IncludeEdge = $true
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
        $ExportPath = Join-Path $env:OneDriveCommercial "Documents"
        Write-Host "OneDrive (Commercial) detected: $ExportPath" -ForegroundColor Green
    } else {
        $ExportPath = if ($PSExports) { $PSExports } else { $PSScriptRoot }
        Write-Host "OneDriveCommercial not found, using: $ExportPath" -ForegroundColor Yellow
    }
}

if (-not (Test-Path $ExportPath)) {
    Write-Error "Export path does not exist: $ExportPath"
    exit 1
}

Write-Host "Export path: $ExportPath" -ForegroundColor Cyan

# ============================================================================
# Extract Chrome Bookmarks
# ============================================================================
if ($IncludeChrome) {
    Write-Host "`n[CHROME] Extracting bookmarks..." -ForegroundColor Cyan
    $chromeBookmarks = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Bookmarks"
    $chromeContent = Get-BookmarksFile -FilePath $chromeBookmarks -BrowserName "Chrome"
    
    if ($chromeContent) {
        try {
            $chromeJson = $chromeContent | ConvertFrom-Json
            $chromeBookmarks = Get-BookmarkChildren -Node $chromeJson.roots.bookmark_bar -BrowserName "Chrome"
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
    $edgeBookmarks = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Bookmarks"
    $edgeContent = Get-BookmarksFile -FilePath $edgeBookmarks -BrowserName "Edge"
    
    if ($edgeContent) {
        try {
            $edgeJson = $edgeContent | ConvertFrom-Json
            $edgeBookmarks = Get-BookmarkChildren -Node $edgeJson.roots.bookmark_bar -BrowserName "Edge"
            $bookmarks += $edgeBookmarks
            Write-Host "Edge: $($edgeBookmarks.Count) bookmarks found" -ForegroundColor Green
        } catch {
            $script:errors += "Edge JSON parsing failed: $_"
            Write-Warning "Failed to parse Edge bookmarks"
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

# Example Usage:
# .\get-browser-bookmarks.ps1
# .\get-browser-bookmarks.ps1 -ExportPath "C:\temp"
# .\get-browser-bookmarks.ps1 -Formats 'CSV', 'JSON'
# .\get-browser-bookmarks.ps1 -IncludeChrome $false

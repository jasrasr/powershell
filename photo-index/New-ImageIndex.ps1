# Filename: New-ImageIndex.ps1
# Revision : 1.1.0
# Description : Generate searchable and sortable HTML indexes for large local photo collections.
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2026-07-30
# Modified Date : 2026-07-30
# Changelog :
# 1.0.0 Initial release.
#       - Added GUI folder picker and optional -Path parameter.
#       - Added recursive and non-recursive image scanning.
#       - Generated photo-table.html and photo-list.html.
# 1.1.0 Added report navigation, sorting, and collection summary features.
#       - Added reusable PhotoPreview browser tab behavior.
#       - Added Ctrl+Click, Shift+Click, and middle-click support for separate tabs.
#       - Added sorting by file name, folder, modified date, and file size.
#       - Added accurate image count, folder count, and total image size.
#       - Added newest and oldest image information.
#       - Added full resolved root path and report generation timestamp.
#       - Added ROADMAP.md documentation for planned releases.

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$Path,

    [switch]$NoRecurse
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Select-Folder {
    Add-Type -AssemblyName System.Windows.Forms

    $dialog = [System.Windows.Forms.FolderBrowserDialog]::new()
    $dialog.Description = 'Select the folder containing your images'
    $dialog.ShowNewFolderButton = $false

    try {
        if ($dialog.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) {
            throw 'No folder was selected.'
        }

        return $dialog.SelectedPath
    }
    finally {
        $dialog.Dispose()
    }
}

function ConvertTo-FileUri {
    param(
        [Parameter(Mandatory)]
        [string]$LiteralPath
    )

    return ([System.Uri]::new($LiteralPath)).AbsoluteUri
}

function ConvertTo-HtmlText {
    param(
        [AllowEmptyString()]
        [string]$Text
    )

    return [System.Net.WebUtility]::HtmlEncode($Text)
}

function Format-FileSize {
    param(
        [Parameter(Mandatory)]
        [double]$Bytes
    )

    if ($Bytes -ge 1TB) { return '{0:N2} TB' -f ($Bytes / 1TB) }
    if ($Bytes -ge 1GB) { return '{0:N2} GB' -f ($Bytes / 1GB) }
    if ($Bytes -ge 1MB) { return '{0:N2} MB' -f ($Bytes / 1MB) }
    if ($Bytes -ge 1KB) { return '{0:N2} KB' -f ($Bytes / 1KB) }
    return '{0:N0} bytes' -f $Bytes
}

if ([string]::IsNullOrWhiteSpace($Path)) {
    $Path = Select-Folder
}

if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
    throw "Folder not found: $Path"
}

$sourceFolder = (Resolve-Path -LiteralPath $Path).Path
$tableOutputPath = Join-Path -Path $sourceFolder -ChildPath 'photo-table.html'
$listOutputPath  = Join-Path -Path $sourceFolder -ChildPath 'photo-list.html'

$imageExtensions = @(
    '.jpg', '.jpeg', '.png', '.gif', '.bmp',
    '.tif', '.tiff', '.webp', '.heic', '.avif'
)

$getChildItemParameters = @{
    LiteralPath = $sourceFolder
    File        = $true
    ErrorAction = 'SilentlyContinue'
}

if (-not $NoRecurse) {
    $getChildItemParameters.Recurse = $true
}

$images = @(
    Get-ChildItem @getChildItemParameters |
        Where-Object { $_.Extension.ToLowerInvariant() -in $imageExtensions } |
        Sort-Object Name, FullName
)

if ($images.Count -eq 0) {
    throw "No supported image files were found in: $sourceFolder"
}

$generated = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
$sourceEncoded = ConvertTo-HtmlText $sourceFolder
$totalImageCount = [int]$images.Count
$countText = '{0:N0}' -f $totalImageCount
$folderCount = @($images | Select-Object -ExpandProperty DirectoryName -Unique).Count
$totalBytes = ($images | Measure-Object -Property Length -Sum).Sum
$totalSizeText = Format-FileSize -Bytes $totalBytes
$newestImage = $images | Sort-Object LastWriteTime -Descending | Select-Object -First 1
$oldestImage = $images | Sort-Object LastWriteTime | Select-Object -First 1
$newestImageText = ConvertTo-HtmlText ('{0} ({1})' -f $newestImage.Name, $newestImage.LastWriteTime.ToString('yyyy-MM-dd HH:mm'))
$oldestImageText = ConvertTo-HtmlText ('{0} ({1})' -f $oldestImage.Name, $oldestImage.LastWriteTime.ToString('yyyy-MM-dd HH:mm'))

$commonCss = @'
:root {
    color-scheme: light dark;
    --background: #f4f6f8;
    --surface: #ffffff;
    --surface-alt: #f8fafc;
    --text: #17202a;
    --muted: #667085;
    --border: #d8dee6;
    --accent: #2563eb;
    --hover: #eaf2ff;
}

@media (prefers-color-scheme: dark) {
    :root {
        --background: #111827;
        --surface: #1f2937;
        --surface-alt: #172033;
        --text: #f3f4f6;
        --muted: #a8b1c0;
        --border: #374151;
        --accent: #7aa2ff;
        --hover: #263a5c;
    }
}

* { box-sizing: border-box; }
body {
    margin: 0;
    padding: 24px;
    background: var(--background);
    color: var(--text);
    font-family: "Segoe UI", Arial, sans-serif;
}
main { max-width: 1500px; margin: 0 auto; }
header { margin-bottom: 18px; }
h1 { margin: 0 0 8px; font-size: 1.7rem; }
.summary-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(190px, 1fr));
    gap: 10px 18px;
    margin-top: 14px;
    padding: 14px;
    border: 1px solid var(--border);
    border-radius: 10px;
    background: var(--surface);
}
.summary-label { display: block; margin-bottom: 2px; color: var(--muted); font-size: 0.86rem; }
.summary-value { display: block; color: var(--text); font-weight: 600; overflow-wrap: anywhere; }
.summary-item.wide { grid-column: 1 / -1; }
.controls { display: flex; flex-wrap: wrap; gap: 12px; margin: 18px 0; }
input[type="search"], select {
    padding: 11px 13px;
    border: 1px solid var(--border);
    border-radius: 8px;
    background: var(--surface);
    color: var(--text);
    font-size: 1rem;
}
input[type="search"] { width: min(620px, 100%); }
select { min-width: 210px; }
.no-results {
    display: none;
    padding: 20px;
    border: 1px solid var(--border);
    border-radius: 8px;
    background: var(--surface);
    color: var(--muted);
}
a { color: inherit; }
'@

$summaryHtml = @"
<div class="summary-grid">
    <div class="summary-item"><span class="summary-label">Total image files</span><span class="summary-value">$countText</span></div>
    <div class="summary-item"><span class="summary-label">Folders containing images</span><span class="summary-value">$folderCount</span></div>
    <div class="summary-item"><span class="summary-label">Total image size</span><span class="summary-value">$totalSizeText</span></div>
    <div class="summary-item"><span class="summary-label">Newest image</span><span class="summary-value">$newestImageText</span></div>
    <div class="summary-item"><span class="summary-label">Oldest image</span><span class="summary-value">$oldestImageText</span></div>
    <div class="summary-item"><span class="summary-label">Generated</span><span class="summary-value">$generated</span></div>
    <div class="summary-item wide"><span class="summary-label">Root path</span><span class="summary-value">$sourceEncoded</span></div>
</div>
"@

$tableRows = foreach ($image in $images) {
    $uri = ConvertTo-FileUri $image.FullName
    $name = ConvertTo-HtmlText $image.Name
    $folder = ConvertTo-HtmlText $image.DirectoryName
    $date = $image.LastWriteTime.ToString('yyyy-MM-dd HH:mm')
    $size = Format-FileSize -Bytes $image.Length
    $search = ConvertTo-HtmlText ('{0} {1} {2}' -f $image.Name, $image.DirectoryName, $date)

    @"
<tr class="image-row"
    data-href="$uri"
    data-search="$search"
    data-name="$([System.Net.WebUtility]::HtmlEncode($image.Name.ToLowerInvariant()))"
    data-folder="$([System.Net.WebUtility]::HtmlEncode($image.DirectoryName.ToLowerInvariant()))"
    data-date="$($image.LastWriteTime.Ticks)"
    data-size="$($image.Length)"
    tabindex="0"
    role="link"
    aria-label="Open $name">
    <td class="name">$name</td>
    <td>$folder</td>
    <td>$date</td>
    <td>$size</td>
</tr>
"@
}

$tableCss = @'
.table-wrap { overflow-x: auto; border: 1px solid var(--border); border-radius: 10px; background: var(--surface); }
table { width: 100%; border-collapse: collapse; }
th, td { padding: 11px 13px; border-bottom: 1px solid var(--border); text-align: left; vertical-align: top; }
th { position: sticky; top: 0; background: var(--surface-alt); color: var(--muted); font-weight: 600; }
tbody tr:last-child td { border-bottom: 0; }
.image-row { cursor: pointer; }
.image-row:hover, .image-row:focus { background: var(--hover); outline: none; }
.name { font-weight: 600; min-width: 220px; }
td:nth-child(2) { overflow-wrap: anywhere; }
.sort-button { padding: 0; border: 0; background: transparent; color: inherit; font: inherit; font-weight: 600; cursor: pointer; }
.sort-button::after { content: " ↕"; color: var(--muted); }
.sort-button[data-direction="asc"]::after { content: " ↑"; }
.sort-button[data-direction="desc"]::after { content: " ↓"; }
'@

$tableScript = @'
const search = document.getElementById("search");
const tableBody = document.getElementById("imageList");
const rows = Array.from(document.querySelectorAll(".image-row"));
const sortButtons = Array.from(document.querySelectorAll(".sort-button"));
const noResults = document.getElementById("noResults");

function openRow(row, event) {
    if (event.ctrlKey || event.metaKey || event.shiftKey || event.button === 1) {
        window.open(row.dataset.href, "_blank");
        return;
    }
    window.open(row.dataset.href, "PhotoPreview");
}

rows.forEach((row) => {
    row.addEventListener("click", (event) => openRow(row, event));
    row.addEventListener("auxclick", (event) => { if (event.button === 1) openRow(row, event); });
    row.addEventListener("keydown", (event) => {
        if (event.key === "Enter" || event.key === " ") {
            event.preventDefault();
            openRow(row, event);
        }
    });
});

function compareRows(a, b, key, direction) {
    let valueA = a.dataset[key];
    let valueB = b.dataset[key];
    if (key === "date" || key === "size") {
        valueA = Number(valueA);
        valueB = Number(valueB);
    }
    let result = typeof valueA === "number"
        ? valueA - valueB
        : valueA.localeCompare(valueB, undefined, { numeric: true, sensitivity: "base" });
    return direction === "asc" ? result : -result;
}

sortButtons.forEach((button) => {
    button.addEventListener("click", () => {
        const key = button.dataset.sort;
        const direction = button.dataset.direction === "asc" ? "desc" : "asc";
        sortButtons.forEach((item) => item.removeAttribute("data-direction"));
        button.dataset.direction = direction;
        rows.slice().sort((a, b) => compareRows(a, b, key, direction)).forEach((row) => tableBody.appendChild(row));
    });
});

search.addEventListener("input", () => {
    const query = search.value.trim().toLowerCase();
    let visible = 0;
    rows.forEach((row) => {
        const match = row.dataset.search.toLowerCase().includes(query);
        row.hidden = !match;
        if (match) visible++;
    });
    noResults.style.display = visible === 0 ? "block" : "none";
});
'@

$tableHtml = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Photo Table</title>
    <style>$commonCss$tableCss</style>
</head>
<body>
<main>
    <header><h1>Photo Table</h1>$summaryHtml</header>
    <div class="controls"><input id="search" type="search" placeholder="Search filenames or folders..." autocomplete="off"></div>
    <div class="table-wrap">
        <table>
            <thead><tr>
                <th><button type="button" class="sort-button" data-sort="name">File name</button></th>
                <th><button type="button" class="sort-button" data-sort="folder">Folder</button></th>
                <th><button type="button" class="sort-button" data-sort="date">Modified</button></th>
                <th><button type="button" class="sort-button" data-sort="size">Size</button></th>
            </tr></thead>
            <tbody id="imageList">$($tableRows -join "`n")</tbody>
        </table>
    </div>
    <div id="noResults" class="no-results">No matching images.</div>
</main>
<script>$tableScript</script>
</body>
</html>
"@

$listLinks = foreach ($image in $images) {
    $uri = ConvertTo-FileUri $image.FullName
    $name = ConvertTo-HtmlText $image.Name
    $search = ConvertTo-HtmlText ('{0} {1}' -f $image.Name, $image.DirectoryName)

    @"
<a class="image-link"
   href="$uri"
   target="PhotoPreview"
   data-search="$search"
   data-name="$([System.Net.WebUtility]::HtmlEncode($image.Name.ToLowerInvariant()))"
   data-folder="$([System.Net.WebUtility]::HtmlEncode($image.DirectoryName.ToLowerInvariant()))"
   data-date="$($image.LastWriteTime.Ticks)"
   data-size="$($image.Length)"
   title="$([System.Net.WebUtility]::HtmlEncode($image.FullName))">$name</a>
"@
}

$listCss = @'
.name-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(210px, 1fr)); gap: 8px; }
.image-link { display: block; padding: 10px 12px; border: 1px solid var(--border); border-radius: 8px; background: var(--surface); text-decoration: none; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.image-link:hover, .image-link:focus { background: var(--hover); border-color: var(--accent); outline: none; }
'@

$listScript = @'
const search = document.getElementById("search");
const sort = document.getElementById("sort");
const list = document.getElementById("imageList");
const links = Array.from(document.querySelectorAll(".image-link"));
const noResults = document.getElementById("noResults");

function applySort() {
    const [key, direction] = sort.value.split("-");
    links.slice().sort((a, b) => {
        let valueA = a.dataset[key];
        let valueB = b.dataset[key];
        if (key === "date" || key === "size") {
            valueA = Number(valueA);
            valueB = Number(valueB);
        }
        let result = typeof valueA === "number"
            ? valueA - valueB
            : valueA.localeCompare(valueB, undefined, { numeric: true, sensitivity: "base" });
        return direction === "asc" ? result : -result;
    }).forEach((link) => list.appendChild(link));
}

sort.addEventListener("change", applySort);
search.addEventListener("input", () => {
    const query = search.value.trim().toLowerCase();
    let visible = 0;
    links.forEach((link) => {
        const match = link.dataset.search.toLowerCase().includes(query);
        link.hidden = !match;
        if (match) visible++;
    });
    noResults.style.display = visible === 0 ? "block" : "none";
});
applySort();
'@

$listHtml = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Photo List</title>
    <style>$commonCss$listCss</style>
</head>
<body>
<main>
    <header><h1>Photo List</h1>$summaryHtml</header>
    <div class="controls">
        <input id="search" type="search" placeholder="Search filenames or folders..." autocomplete="off">
        <select id="sort" aria-label="Sort photos">
            <option value="name-asc">Name: A to Z</option>
            <option value="name-desc">Name: Z to A</option>
            <option value="folder-asc">Folder: A to Z</option>
            <option value="folder-desc">Folder: Z to A</option>
            <option value="date-desc">Date: Newest first</option>
            <option value="date-asc">Date: Oldest first</option>
            <option value="size-desc">Size: Largest first</option>
            <option value="size-asc">Size: Smallest first</option>
        </select>
    </div>
    <div id="imageList" class="name-grid">$($listLinks -join "`n")</div>
    <div id="noResults" class="no-results">No matching images.</div>
</main>
<script>$listScript</script>
</body>
</html>
"@

$tableHtml | Set-Content -LiteralPath $tableOutputPath -Encoding UTF8
$listHtml  | Set-Content -LiteralPath $listOutputPath -Encoding UTF8

Write-Host ''
Write-Host "Total image files: $totalImageCount"
Write-Host "Folders:           $folderCount"
Write-Host "Total image size:  $totalSizeText"
Write-Host "Newest image:      $($newestImage.Name)"
Write-Host "Oldest image:      $($oldestImage.Name)"
Write-Host "Root path:         $sourceFolder"
Write-Host "Photo table:       $tableOutputPath"
Write-Host "Photo list:        $listOutputPath"
Write-Host ''

Start-Process -FilePath $tableOutputPath
Start-Process -FilePath $listOutputPath

# Revision : 1.5
# Description : Auto-picks the latest two Excel files in a folder (newest = $NewFile, second-newest = $OldFile) and compares by Project# (A) vs Stat (B).
#               Headers start on row 2. Exports a SINGLE CSV with only Added/Removed/Modified rows and auto-opens it in Excel. Rev 1.5
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-09-04
# Modified Date : 2025-09-04

param(
    # Where your dated project list XLSX files live
    [string] $Folder = 'C:\Users\jason.lamb\OneDrive - middough\General - IT\U & N Drive clean up',
    # Pattern to match the dated files (e.g., "Project List Download 090425.xlsx")
    [string] $SearchMask = 'Project List Download*.xlsx',

    # Excel compare settings
    [string] $WorksheetName = 'MIDD0821_proj_list_weekly',
    [string] $KeyHeader = 'Project#',
    [string] $StatusHeader = 'Stat',
    [switch] $StrictMatch,

    # Output
    [string] $OutputFolder = 'C:\temp\powershell-exports'
)

# --- Setup ---
$null = New-Item -Path $OutputFolder -ItemType Directory -Force | Out-Null
$TimeStamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$OutCsv    = Join-Path $OutputFolder "excel-status-changes-$TimeStamp.csv"

# --- Find latest two files ---
if (-not (Test-Path -LiteralPath $Folder)) {
    Write-Host "Folder not found : $Folder"
    exit 1
}

$files = Get-ChildItem -LiteralPath $Folder -Filter $SearchMask -File -ErrorAction Stop |
         Sort-Object LastWriteTime -Descending

if ($files.Count -lt 2) {
    Write-Host "Not enough files found in $Folder matching $SearchMask . Need at least 2."
    if ($files.Count -gt 0) { Write-Host "Found latest file : $($files[0].FullName)" }
    exit 1
}

$NewFile = $files[0].FullName
$OldFile = $files[1].FullName

Write-Host "New file : $NewFile"
Write-Host "Old file : $OldFile"

# --- Require ImportExcel (PowerShell 7 compatible) ---
if (-not (Get-Module -ListAvailable -Name ImportExcel)) {
    try {
        Write-Host "ImportExcel module missing, installing to CurrentUser..."
        Install-Module ImportExcel -Scope CurrentUser -Force -ErrorAction Stop
        Write-Host "ImportExcel installed successfully."
    } catch {
        Write-Host "Failed to install ImportExcel : $_"
        exit 1
    }
}
Import-Module ImportExcel -ErrorAction Stop

# --- Allowed statuses ---
$AllowedStatuses = @(
    'ACTIVE',
    'PERMANENTLY CLOSED',
    'RESTRICTED',
    'PERM CLOSE IN PROGRESS',
    'INACTIVE'
)

function Normalize-Status {
    param([string] $s)
    if ($StrictMatch) { return $s }
    if ([string]::IsNullOrWhiteSpace($s)) { return '' }
    $t = ($s -replace '\s+', ' ').Trim().ToUpperInvariant()
    return $t
}

function Read-ExcelRows {
    param([string] $Path)
    # Headers are on row 2
    return Import-Excel -Path $Path -WorksheetName $WorksheetName -StartRow 2
}

function Open-InExcel {
    param([string] $Path)
    try {
        $excelCmd = Get-Command excel.exe -ErrorAction SilentlyContinue
        if ($excelCmd) {
            Start-Process -FilePath $excelCmd.Source -ArgumentList "`"$Path`""
        } else {
            Invoke-Item -Path $Path
        }
    } catch {
        Write-Host "Could not open in Excel : $_"
    }
}

# --- Load both files ---
try {
    $oldRows = Read-ExcelRows -Path $OldFile
    $newRows = Read-ExcelRows -Path $NewFile
} catch {
    Write-Host "Error reading Excel files : $_"
    exit 1
}

# Validate headers exist
foreach ($h in @($KeyHeader, $StatusHeader)) {
    if ($oldRows.Count -gt 0 -and -not ($oldRows[0].PSObject.Properties.Name -contains $h)) {
        Write-Host "Old file missing expected header $h ."
        exit 1
    }
    if ($newRows.Count -gt 0 -and -not ($newRows[0].PSObject.Properties.Name -contains $h)) {
        Write-Host "New file missing expected header $h ."
        exit 1
    }
}

# --- Build maps keyed by Project# ---
$oldMap = @{}
foreach ($r in $oldRows) {
    $k = "$($r.$KeyHeader)".Trim()
    if ($k) { $oldMap[$k] = $r }
}
$newMap = @{}
foreach ($r in $newRows) {
    $k = "$($r.$KeyHeader)".Trim()
    if ($k) { $newMap[$k] = $r }
}

# --- Diff logic: only changes (Added/Removed/Modified) ---
$allKeys = (($oldMap.Keys + $newMap.Keys) | Sort-Object -Unique)

$results  = New-Object System.Collections.Generic.List[object]
$added = 0; $removed = 0; $modified = 0; $unchanged = 0

foreach ($k in $allKeys) {
    $inOld = $oldMap.ContainsKey($k)
    $inNew = $newMap.ContainsKey($k)

    $oldStatRaw = if ($inOld) { "$($oldMap[$k].$StatusHeader)" } else { $null }
    $newStatRaw = if ($inNew) { "$($newMap[$k].$StatusHeader)" } else { $null }

    $oldStat = Normalize-Status $oldStatRaw
    $newStat = Normalize-Status $newStatRaw

    $obj = [PSCustomObject]@{
        Project      = $k
        Status       = $null
        OldStatusRaw = $oldStatRaw
        NewStatusRaw = $newStatRaw
        OldStatus    = $oldStat
        NewStatus    = $newStat
        Transition   = if ($inOld -and $inNew) { "{0} -> {1}" -f $oldStat,$newStat } else { "" }
    }

    if ($inOld -and -not $inNew) {
        $removed++; $obj.Status = 'Removed'
        $results.Add($obj) | Out-Null
        continue
    }
    if (-not $inOld -and $inNew) {
        $added++; $obj.Status = 'Added'
        $results.Add($obj) | Out-Null
        continue
    }

    if ($oldStat -ne $newStat) {
        $modified++; $obj.Status = 'Modified'
        $results.Add($obj) | Out-Null
    } else {
        $unchanged++  # do not add unchanged
    }
}

# --- Export ONLY changes and open in Excel ---
try {
    if ($results.Count -gt 0) {
        $results | Export-Csv -NoTypeInformation -Encoding UTF8 -Path $OutCsv
    } else {
        # Header-only file so Excel opens cleanly
        'Project,Status,OldStatusRaw,NewStatusRaw,OldStatus,NewStatus,Transition' | Set-Content -Path $OutCsv -Encoding UTF8
    }
    Open-InExcel -Path $OutCsv
} catch {
    Write-Host "Failed to write or open CSV : $_"
}

# --- Summary ---
Write-Host "Folder : $Folder"
Write-Host "SearchMask : $SearchMask"
Write-Host "Worksheet : $WorksheetName"
Write-Host "Headers assumed on row : 2"
Write-Host "Key header : $KeyHeader"
Write-Host "Status header : $StatusHeader"
Write-Host "Added : $added  Removed : $removed  Modified : $modified  Unchanged : $unchanged"
Write-Host "Changes CSV : $OutCsv"

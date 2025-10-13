# Revision : 2.9
# Description : Timestamped backup, then (optionally) apply selected filters:
#   (1) remove lines with 11+ backslashes,
#   (2) remove lines ending in specific file extensions (includes .mp4, .lnk, .mpg),
#   (3) remove specific Newforma child folders (keep Newforma root),
#   (4) remove rows under a provided child-folder list (proper "\*" handling; includes '5.1 Quality Checklist*' and 'Field Measurements*'),
#   (5) remove children under '11.0 Issued Documents' (keep folder root),
#   (6) remove children under _Gen, _Stds, _Transfer at archive\<*>\ (keep roots) + general Issued Documents and Photos children removal,
#   (7) remove duplicate lines (case-insensitive; keeps first occurrence),
#   (8) export (do NOT delete) any rows containing a comma to a separate file.
# Includes progress bar and final report. Rev 2.9
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-10-12
# Modified Date : 2025-10-13

param(
    [Parameter(Position = 0, Mandatory = $true)]
    [string]$InputFile,

    # Choose which filters to apply. If none specified, all enabled by default.
    [switch]$RemoveSlash11,            # Rule 1
    [switch]$RemoveExtensions,         # Rule 2
    [switch]$RemoveNewformaChildren,   # Rule 3
    [switch]$RemoveChildFolders,       # Rule 4
    [switch]$RemoveIssuedChildren,     # Rule 5
    [switch]$RemoveGSTChildren,        # Rule 6 (_Gen, _Stds, _Transfer + Issued/Photos children)
    [switch]$RemoveDuplicates,         # Rule 7 (deduplicate lines)
    [switch]$ExportCommaRows           # Rule 8 (export rows containing commas, do not delete)
)

# If no switches provided, enable all rules by default
if (-not ($RemoveSlash11 -or $RemoveExtensions -or $RemoveNewformaChildren -or $RemoveChildFolders -or $RemoveIssuedChildren -or $RemoveGSTChildren -or $RemoveDuplicates -or $ExportCommaRows)) {
    $RemoveSlash11 = $true
    $RemoveExtensions = $true
    $RemoveNewformaChildren = $true
    $RemoveChildFolders = $true
    $RemoveIssuedChildren = $true
    $RemoveGSTChildren = $true
    $RemoveDuplicates = $true
    $ExportCommaRows = $true
    Write-Host "No filters specified, applying all filters by default." -ForegroundColor DarkYellow
}

# Timestamp for backup name
$datetime = Get-Date -Format 'yyyyMMdd-HHmmss'

# Backup path(s)
$backupFile = "$($InputFile)-backup-$datetime.txt"
$commaFile  = "$($InputFile)-comma-$datetime.txt"

# Backup original
Copy-Item -Path $InputFile -Destination $backupFile -Force
Write-Host "Backup created : $backupFile" -ForegroundColor Cyan

# Load file
$allLines = Get-Content -Path $InputFile
$total = $allLines.Count
$filteredLines = New-Object System.Collections.Generic.List[string]
$commaLines    = New-Object System.Collections.Generic.List[string]
$removedCount = 0

# -------------------------------
# Rule 2 : File extension patterns (END OF LINE)
# -------------------------------
$extPatterns = @(
    '\.msg$', '\.xlsx$', '\.docx$', '\.pdf$', '\.xls$', '\.doc$', '\.pptx$', '\.csv$', '\.zip$',
    '\.log$', '\.txt$', '\.dcf$', '\.dcfx$', '\.xml$', '\.xml\.lock$', '\.dwg$', '\.mp4$', '\.lnk$', '\.mpg$', '\.nwc$'
)

# -------------------------------------------
# Rule 3 : Newforma - remove specific children (not the Newforma root)
# Keep root ...\Newforma but remove: Email, Field Notes, PunchList, Record Copies
# Note : allow one-or-more folders between "archive\" and "Newforma\"
# -------------------------------------------
$rxNewformaChildren = '^\\\\middough\.local\\corp\\data\\archive\\(?:[^\\]+\\){1,}Newforma\\(Email|Field Notes|PunchList|Record Copies)(?:\\|$)'

# -------------------------------------------
# Rule 4 : Remove any of these folders + subfolders (match anywhere in the path)
# NOTE: trailing "\*" means "this folder and below" — handled by trimming "\*"
# -------------------------------------------
$childFolders = @(
    '1.1 Proposal Cover Letter\*',
    '1.10 Project Closeout\*',
    '1.10 Project Profile\*',
    '1.11 Standard File Index\*',
    '1.12 Hours Tracking and Forecast\*',
    '1.12 MAPP\*',
    '1.12 Middough-JSW Reports\*',
    '1.12 Local Backup\*',
    '1.12 Received Monthly Reports\*',
    '1.12 Special Inspections\*',
    '1.13 Dastur Danieli Scopes of Work\*',
    '1.13 Fee Estimate\*',
    '1.13 TPT Documents\*',
    '1.14 Proposal Sign Off\*',
    '1.2 Contract Release PO-CO\*',
    '1.3 CA-Change Authorization\*',
    '1.4 Secrecy Agreements\*',
    '1.6 Patents\*',
    '1.5 Subconsultant Prop Contract-PO\*',
    '1.7 Invoices\*',
    '1.8 Sr. Mgmt. Review\*',
    '1.8 Sr. Mgmt. Review-\*',
    '1.9 Close-Out Report\*',
    '2.0 Correspondence\*',
    '7.0 Construction\*',
    '1.12 Rate Override\*',
    '1.12 PCA Rate Override\*',
    '_General\*',
    '1.12 Manditory Gates Log\*',
    '1.12 Manditory Gates.Log\*',
    '1.16 Negotiate Agreement\*',
    '1.17 Signature Authority\*',
    'Formal Proposal\*',
    '2.1 Distribution-Communication Matrix\*',
    '2.2 Internal\*',
    '2.3 External\*',
    '2.3 Client\*',
    '2.4 Transmittals\*',
    '2.5 Meeting Minutes\*',
    '2.6 Action Item List\*',
    '2.7 Regulatory Agencies\*',
    '2.8 Vendor-Subconsultant\*',
    '2.9 Logos\*',
    '3.1 PDS\*',
    '3.2 DTSR\*',
    '3.3 PSR\*',
    '3.4 Schedule\*',
    '3.5 Project Evaluation Report\*',
    '3.6 Project Plan\*',
    '3.7 Misc. Status Reports\*',
    '4.1 Scope of Services\*',
    '4.2 Coordination Manual\*',
    '4.3 Design Manual\*',
    '4.4 Statement-Requirements\*',
    '4.5 Design Spec\*',
    '4.6 Environ-Geotech Data Surveys\*',
    '4.7 Design Basis\*',
    '4.8 Middough Tech Reports\*',
    '4.9 Drawing List\*',
    '4.10 Equipment List\*',
    '4.11 Piping Line List\*',
    '4.12 Tie-In List\*',
    '4.13 Instrument List\*',
    '4.14 Deliverables List-File\*',
    '4.15 I-O List\*',
    '4.16 Vendor Files\*',
    '4.17 Photos\*',
    '4.18 Discipline\*',
    '4.19 Word templates\*',
    '4.19 Word template\*',
    '4.19 ICORs\*',
    '5.1 TQI Checklist\*',
    '5.1 Quality Checklist\*',
    '5.2 Design Reviews\*',
    '5.3 Safety-HAZOP Reviews\*',
    '5.4 Constructability Reviews\*',
    '5.5 Operability Reviews\*',
    '5.6 Procedures\*',
    '6.1 Capital Cost Estimate\*',
    '6.2 Back-up - Take-offs\*',
    '6.3 Cost Report\*',
    '6.4 Overall Project\*',
    '7.1 Status Reports\*',
    '7.10 Field CO Request\*',
    '7.11 Punch List\*',
    '7.12 Execution Plan\*',
    '7.13 Field Study\*',
    '7.2 Schedules\*',
    '7.3 Constr Package\*',
    '7.4 Meeting Minutes\*',
    '7.5 Submittals - Approvals\*',
    '7.6 Contractor Correspondence\*',
    '7.7 Constr Permits\*',
    '7.8 Field Test Reports\*',
    '7.9 Field Design CA\*',
    '8.1 Project Purchasing Procedure\*',
    '8.2 Purchase Orders - Bid Packages\*',
    '8.3 Subcontracts\*',
    '8.4 Vendor Data\*',
    '9.1 Plant Safety Procedure\*',
    '9.2 Site Specific Plan\*',
    '9.3 Incident Reports\*',
    '9.4 Training Records\*',
    '9.5 Report\*',
    'sept 23\*',
    '10.1 Blocks\*',
    '10.2 Client Originals\*',
    '10.3 Temp Wrk Files\*',
    '10.4 Vendor Dwgs\*',
    '10.5 Wrk Dwgs\*',
    '10.6 Discipline\*',
    '10.6 Laser Scan Data\*',
    '10.7 Laser Scan Data\*',
    '10.7 Laser Scan\*',
    '10.7 Navisworks\*',
    '10.8 Laser Scan from Becht\*',
    '10.8 Laser Scan Data\*',
    '10.1 Support\*',
    '10.1 Inventor\*',
    '10.11 Navis\*',
    '10.13 Export\*',
    '10.14 Vendor\*',
    '10.15 Visualization\*',
    '10.2 AutoCAD\*',
    '10.3 Revit\*',
    '10.4 Plant 3D\*',
    '10.5 Civil 3D\*',
    '10.6 Advance Steel\*',
    '10.7 Microstation\*',
    '10.8 CADWorx\*',
    '10.8 Navisworks\*',
    '10.9 SOLIDWORKS\*',
    'Field Measurements\*',
    '10.10 Inventor\*',
    '10.12 Scanning\*',
    '10.13 Exports\*',
    '3.2a Change Management\*',
    '3.8 Client Comments\*',
    '1.12 Mandatory Gates\*',
    '1.14 Proposal Sign-Off\*',
    '4.19 Construction Administration\*',
    '4.20 Pending Release\*',
    '10.8 Naviswork\*',
    '3.8 Database\*',
    '1.12 Working Docs Logs\*',
    '4.22 Change Management - ICORs\*',
    '1.18 SPM Email Archives\*',
    '4.19 Change Management\*',
    '10.7 NAVIS\*',
    '3.8 DQR',
    '3.9 ICOR',
    '1.3 Change Authorization (ICOR, CN, COR)',
    '1.12 Mandatory Gates Log'
)

# Build regexes that match "\<FolderName>(\|$)" anywhere in the path
# Strip a trailing "\*" if present (meaning "this folder and below")
$childFolderRegexes = foreach ($p in $childFolders) {
    $base = ($p -replace '\\\*$', '')
    '\\' + [regex]::Escape($base) + '(\\|$)'
}

# -------------------------------------------
# Rule 5 : Remove children under "11.0 Issued Documents" but keep the folder root
# Examples to REMOVE : \\...\archive\*\*\11.0 Issued Documents\something
# Example to KEEP    : \\...\archive\*\*\11.0 Issued Documents
# -------------------------------------------
$rxIssuedChildren = '^\\\\middough\.local\\corp\\data\\archive\\(?:[^\\]+\\){2,}11\.0 Issued Documents\\.+'

# -------------------------------------------
# Rule 6 : Remove children under:
#   - _Gen, _Stds, _Transfer at \\...archive\<one-folder>\
#   - Any children beneath Issued Documents (keep root)
#   - Any children beneath Photos (keep root)
# -------------------------------------------
$rxGST_TripletChildren = '^\\\\middough\.local\\corp\\data\\archive\\[^\\]+\\_(Gen|Stds|Transfer)\\.+'
$rxGST_IssuedChildren  = '^\\\\middough\.local\\corp\\data\\archive\\[^\\]+\\Issued Documents\\.+'
$rxGST_PhotosChildren  = '^\\\\middough\.local\\corp\\data\\archive\\[^\\]+\\Photos\\.+'

# -------------------------------------------
# Rule 7 : Duplicate lines (case-insensitive) — keep first occurrence only
# -------------------------------------------
$seen = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)

Write-Host "Processing $total lines ..." -ForegroundColor Yellow

for ($i = 0; $i -lt $total; $i++) {
    $line = $allLines[$i]
    $remove = $false

    # Rule 8 : Export comma rows (do NOT delete)
    if ($ExportCommaRows -and ($line -like '*,*')) {
        $commaLines.Add($line) | Out-Null
    }

    # Rule 1 : 11+ backslashes
    if (-not $remove -and $RemoveSlash11) {
        $slashCount = [regex]::Matches($line, '\\').Count
        if ($slashCount -ge 11) { $remove = $true }
    }

    # Rule 2 : ends with specified extension
    if (-not $remove -and $RemoveExtensions) {
        foreach ($pattern in $extPatterns) {
            if ($line -match $pattern) { $remove = $true; break }
        }
    }

    # Rule 3 : Newforma children
    if (-not $remove -and $RemoveNewformaChildren) {
        $trimmed = $line.Trim()
        if ($trimmed -match $rxNewformaChildren) { $remove = $true }
    }

    # Rule 4 : listed child folders + subfolders
    if (-not $remove -and $RemoveChildFolders) {
        foreach ($rx in $childFolderRegexes) {
            if ($line -match $rx) { $remove = $true; break }
        }
    }

    # Rule 5 : "11.0 Issued Documents" children (keep the root)
    if (-not $remove -and $RemoveIssuedChildren) {
        if ($line -match $rxIssuedChildren) { $remove = $true }
    }

    # Rule 6 : _Gen/_Stds/_Transfer + Issued/Photos children (keep their roots)
    if (-not $remove -and $RemoveGSTChildren) {
        if ( ($line -match $rxGST_TripletChildren) -or
             ($line -match $rxGST_IssuedChildren) -or
             ($line -match $rxGST_PhotosChildren) ) {
            $remove = $true
        }
    }

    # Rule 7 : remove duplicates (keep first occurrence)
    if (-not $remove -and $RemoveDuplicates) {
        if (-not $seen.Add($line)) { $remove = $true }
    }

    if (-not $remove) {
        $filteredLines.Add($line)
    }
    else {
        $removedCount++
    }

    # Progress
    $percent = if ($total -gt 0) { [math]::Round((($i + 1) / $total) * 100, 2) } else { 100 }
    Write-Progress -Activity "Parsing text file" -Status "Processing line $($i + 1) of $total" -PercentComplete $percent
}

# Save cleaned file
$filteredLines | Set-Content -Path $InputFile -Encoding UTF8

# Save comma rows (if any)
$commaExported = 0
if ($ExportCommaRows -and $commaLines.Count -gt 0) {
    $commaLines | Set-Content -Path $commaFile -Encoding UTF8
    $commaExported = $commaLines.Count
    Write-Host "Comma rows exported to : $commaFile" -ForegroundColor Magenta
}

# Report
$keptCount = $filteredLines.Count
$removedPercent = if ($total -gt 0) { [math]::Round(($removedCount / $total) * 100, 2) } else { 0 }

Write-Host ""
Write-Host "-------------------------" -ForegroundColor DarkGray
Write-Host "       FINAL REPORT       " -ForegroundColor Cyan
Write-Host "-------------------------" -ForegroundColor DarkGray
Write-Host "Total lines processed : $total" -ForegroundColor Yellow
Write-Host "Lines removed         : $removedCount ($removedPercent%)" -ForegroundColor Red
Write-Host "Lines kept            : $keptCount" -ForegroundColor Green
Write-Host "Comma rows exported   : $commaExported" -ForegroundColor Magenta
Write-Host "Clean file saved to   : $InputFile" -ForegroundColor Cyan
Write-Host "Backup created at     : $backupFile" -ForegroundColor Gray
Write-Host "Operation complete at : $(Get-Date)" -ForegroundColor Yellow

<# -----------------
Usage examples
-------------------
# Apply ALL rules (default if none specified)
.\parse-txt-file.ps1 'K:\101225 txt\archive-depth3.txt'

# Only export comma rows (no deletions)
.\parse-txt-file.ps1 'K:\101225 txt\archive-depth3.txt' -ExportCommaRows

# Export comma rows AND remove duplicates
.\parse-txt-file.ps1 'K:\101225 txt\archive-depth3.txt' -ExportCommaRows -RemoveDuplicates

# Combine as needed
.\parse-txt-file.ps1 'K:\101225 txt\archive-depth3.txt' -RemoveExtensions -RemoveNewformaChildren -RemoveIssuedChildren -RemoveGSTChildren -RemoveDuplicates -ExportCommaRows
#>

<# -----------------
Rule examples (kept vs removed)
-------------------

# Rule 1 : 11+ backslashes
# Kept:
\\middough.local\corp\data\archive\Basf\ENG1\Folder
# Removed (>= 11 slashes):
\\middough.local\corp\data\archive\Basf\ENG1\A\B\C\D\E\F\G\H

# Rule 2 : File extensions (line must END with one of these)
# Extensions : .msg .xlsx .docx .pdf .xls .doc .pptx .csv .zip .log .txt .dcf .dcfx .xml .xml.lock .dwg .mp4 .lnk .mpg
# Kept:
\\server\share\folder\readme.md
# Removed:
\\server\share\folder\mail.msg
\\server\share\folder\video.mpg

# Rule 3 : Newforma children (keep Newforma root)
# Kept:
\\middough.local\corp\data\archive\Basf\ENG1840\Newforma
# Removed:
\\middough.local\corp\data\archive\Basf\ENG1840\Newforma\Email
\\middough.local\corp\data\archive\Basf\ENG1840\Newforma\Field Notes
\\middough.local\corp\data\archive\Basf\ENG1840\Newforma\PunchList
\\middough.local\corp\data\archive\Basf\ENG1840\Newforma\Record Copies

# Rule 4 : Listed child folders (keep parents like "\9.0 Health & Safety")
# Kept:
\\middough.local\corp\data\archive\Basf\ENG1830B\9.0 Health & Safety
# Removed:
\\middough.local\corp\data\archive\Basf\ENG1830B\9.0 Health & Safety\9.5 Report

# Rule 5 : "11.0 Issued Documents" children (keep the root)
# Kept:
\\middough.local\corp\data\archive\Basf\ENG1840\11.0 Issued Documents
# Removed:
\\middough.local\corp\data\archive\Basf\ENG1840\11.0 Issued Documents\Rev A

# Rule 6 : _Gen / _Stds / _Transfer + Issued/Photos children (keep roots)
# Kept:
\\middough.local\corp\data\archive\Basf\_Gen
\\middough.local\corp\data\archive\Basf\_Stds
\\middough.local\corp\data\archive\Basf\_Transfer
\\middough.local\corp\data\archive\Basf\Issued Documents
\\middough.local\corp\data\archive\Basf\Photos
# Removed:
\\middough.local\corp\data\archive\Basf\_Gen\folder
\\middough.local\corp\data\archive\Basf\_Stds\folder
\\middough.local\corp\data\archive\Basf\_Transfer\folder
\\middough.local\corp\data\archive\Basf\Issued Documents\2010_9-10-10
\\middough.local\corp\data\archive\Basf\Photos\01-18-10 Sebek\image.jpg

# Rule 7 : Duplicates (case-insensitive)
# Kept (first occurrence only):
\\server\share\path\example
# Removed (duplicate lines later in the file):
\\server\share\path\example
\\SERVER\SHARE\PATH\Example

# Rule 8 : Export comma rows (do NOT delete)
# Kept in main file, but written to a separate export file:
#   Export path : <InputFile>-comma-<timestamp>.txt
# Examples exported:
\\server\path\with,comma
"Quoted, CSV, like, line"
#>
<# -----------------
Revision History (recap)
-------------------
1.6 : Added selectable switches for Rules 1–3; summary report.
1.7 : Added Rule 4 (child folder list removal) and included .mp4; kept roots.
1.8 : Added .lnk to Rule 2 and Rule 5 (Issued Documents children).
1.9 : Fixed Rule 4 regex builder (proper trimming of trailing "\*").
2.0 : Added Rule 6 for _Gen/_Stds/_Transfer children at archive\<*> roots; kept base folders.
2.1 : Added Rule 6 special cases: Issued Documents\...\V&M Uploads and Photos\01-18-10 Sebek.
2.2 : Added .mpg to Rule 2; appended detailed examples for each rule.
2.3 : Added '5.1 Quality Checklist*' to Rule 4 list.
2.4 : Added 'Field Measurements*' to Rule 4 list.
2.5 : Added Rule 6 case to remove Issued Documents\2010_9-10-10 children.
2.6 : Generalized Rule 6 to remove any children under Issued Documents and Photos (kept roots).
2.7 : Added Rule 7 to remove duplicate lines (case-insensitive; keeps first occurrence).
2.8 : Rule 3 regex loosened to allow one-or-more folders before "Newforma\".
2.9 : Added Rule 8 to export comma rows to a separate file without deleting them.
#>

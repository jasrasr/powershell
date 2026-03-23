# Revision : 5.5
# Description : GUI HEIC/HEIF to JPG Converter using bundled portable ImageMagick
# Author : Jason Lamb (with help from ChatGPT & Claude Code)
# Created Date : 2025-04-01
# Modified Date : 2026-03-23

# -----------------------------
# Changelog
# -----------------------------
# v5.5 : Switched conversion engine from Windows WIC (PresentationCore) to
#         ImageMagick (bundled portable or system PATH). WIC failed with
#         0xC00D5212 because the HEIF AppX codec does not register with the
#         WPF WIC layer. Merged HEICconvert2JPG-GUI-1.ps1 into this file.
#         Fixed metaLabel clipping (AutoSize). Drag-drop now populates input/
#         output path boxes. Case-insensitive extension matching (-imatch).
#         Improved catch block (logs exception message). Archive folder now
#         created per source directory (multi-folder drag-drop support).
# v5.4 : Added WIC-based conversion (Windows.Media.Imaging). Added stream
#         leak fixes (try/finally). Fixed undefined $file in catch block.
#         Added progress bar. Added CSV conversion log to C:\temp\powershell-exports.
# v5.0 : Initial GUI release with drag-drop, browse, output folder selection.

# -----------------------------
# Globals
# -----------------------------
$global:collectedFiles = @()
$logRoot = 'C:\temp\powershell-exports'
$scriptRoot = Split-Path -Parent $PSCommandPath
$magickCandidates = @(
    (Join-Path $scriptRoot 'ImageMagick\magick-heic.exe'),
    (Join-Path $scriptRoot 'ImageMagick\magick.exe'),
    'magick'
)
$magickExe = $magickCandidates | Where-Object { $_ -eq 'magick' -or (Test-Path $_) } | Select-Object -First 1

# -----------------------------
# PowerShell Version Check
# -----------------------------
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.MessageBox]::Show(
        "This script requires PowerShell 7 or later.",
        "PowerShell Version Too Low"
    )
    exit
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

if (-not $magickExe) {
    [System.Windows.Forms.MessageBox]::Show(
        "ImageMagick was not found. Expected '.\ImageMagick\magick.exe' or 'magick' in PATH.",
        "ImageMagick Not Found"
    )
    exit
}

# -----------------------------
# Conversion Function
# -----------------------------
function Start-Convert {
    param (
        [string[]]$Files,
        [string]$OutputFolder,
        [System.Windows.Forms.RichTextBox]$LogBox,
        [System.Windows.Forms.ProgressBar]$ProgressBar
    )

    if (-not (Test-Path $logRoot)) {
        New-Item -ItemType Directory -Path $logRoot | Out-Null
    }

    $Files = $Files | Sort-Object -Unique
    if (-not $Files.Count) { return }

    $datetime = Get-Date -Format 'yyyyMMdd-HHmmss'
    $logPath = Join-Path $logRoot "heic-conversion-$datetime.csv"
    "OriginalFile,ConvertedFile,Status,HEIC_KB,JPG_KB,Dimensions,Timestamp" |
        Out-File $logPath -Encoding utf8

    $ProgressBar.Minimum = 0
    $ProgressBar.Maximum = $Files.Count
    $ProgressBar.Value   = 0

    $converted = 0
    $skipped   = 0
    $failed    = 0
    foreach ($filePath in $Files) {
        $ProgressBar.Value++

        $file = $null
        $heicSize = ''
        $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

        try {
            $file = Get-Item -LiteralPath $filePath -ErrorAction Stop
            if ($file.Extension.ToLower() -notin '.heic', '.heif') { continue }

            $archiveFolder = Join-Path (Split-Path $file.FullName -Parent) 'Original HEIC'
            if (-not (Test-Path $archiveFolder)) {
                New-Item -ItemType Directory -Path $archiveFolder | Out-Null
            }

            $jpgPath   = Join-Path $OutputFolder ($file.BaseName + '.jpg')
            $heicSize  = [math]::Round($file.Length / 1KB, 2)

            if (Test-Path $jpgPath) {
                $jpgSize = [math]::Round((Get-Item $jpgPath).Length / 1KB, 2)
                "$($file.Name),$($file.BaseName).jpg,Skipped,$heicSize,$jpgSize,N/A,$timestamp" |
                    Out-File $logPath -Append
                $LogBox.AppendText("Skipped : $($file.Name)`n")
                $skipped++
                continue
            }

            & $magickExe $file.FullName $jpgPath
            if ($LASTEXITCODE -ne 0 -or -not (Test-Path $jpgPath)) {
                throw "ImageMagick failed to convert '$($file.FullName)'."
            }

            $jpg = Get-Item $jpgPath
            $jpgSize = [math]::Round($jpg.Length / 1KB, 2)
            $dimensions = & $magickExe identify -format '%wx%h' $jpgPath
            if ($LASTEXITCODE -ne 0) {
                $dimensions = 'N/A'
            }

            Move-Item $file.FullName (Join-Path $archiveFolder $file.Name) -Force

            "$($file.Name),$($jpg.Name),Success,$heicSize,$jpgSize,$dimensions,$timestamp" |
                Out-File $logPath -Append

            $LogBox.AppendText("Converted : $($file.Name)`n")
            $converted++
        }
        catch {
            $failedName = if ($file) { $file.Name } else { [System.IO.Path]::GetFileName($filePath) }
            "$failedName,,Failed,$heicSize,,,$timestamp" |
                Out-File $logPath -Append
            $LogBox.AppendText("Failed : $failedName`n")
            $failed++
        }
    }

    [System.Windows.Forms.MessageBox]::Show(
        "Converted : $converted`nSkipped : $skipped`nFailed : $failed",
        "Conversion Complete"
    )

    $global:collectedFiles = @()
}

# -----------------------------
# GUI
# -----------------------------
$form = New-Object System.Windows.Forms.Form
$form.Text = 'HEIC to JPG Converter (GUI Rev 5.5)'
$form.Size = New-Object System.Drawing.Size(640,540)
$form.StartPosition = 'CenterScreen'
$form.Topmost = $true

$infoLabel = New-Object System.Windows.Forms.Label
$infoLabel.Text = "Drag && drop HEIC/HEIF files or use Browse. Output defaults to input."
$infoLabel.AutoSize = $false
$infoLabel.Size = New-Object System.Drawing.Size(600,40)
$infoLabel.Location = New-Object System.Drawing.Point(10,10)
$infoLabel.Font = New-Object System.Drawing.Font("Segoe UI",9)
$form.Controls.Add($infoLabel)

$metaLabel = New-Object System.Windows.Forms.Label
$metaLabel.Text = "Author : Jason Lamb    Version : GUI Rev 5.5 (ImageMagick)"
$metaLabel.Font = New-Object System.Drawing.Font("Segoe UI",8,[System.Drawing.FontStyle]::Italic)
$metaLabel.AutoSize = $true
$metaLabel.Location = New-Object System.Drawing.Point(10,50)
$form.Controls.Add($metaLabel)

# Input
$inputLabel = New-Object System.Windows.Forms.Label
$inputLabel.Text = 'Input file/folder:'
$inputLabel.AutoSize = $true
$inputLabel.Location = New-Object System.Drawing.Point(10,83)
$form.Controls.Add($inputLabel)

$inputBox = New-Object System.Windows.Forms.TextBox
$inputBox.Location = New-Object System.Drawing.Point(110,80)
$inputBox.Size = New-Object System.Drawing.Size(395,20)
$form.Controls.Add($inputBox)

$inputBrowse = New-Object System.Windows.Forms.Button
$inputBrowse.Text = 'Browse'
$inputBrowse.Location = New-Object System.Drawing.Point(515,78)
$inputBrowse.Add_Click({
    $ofd = New-Object System.Windows.Forms.OpenFileDialog
    $ofd.Multiselect = $true
    $ofd.Filter = "HEIC/HEIF (*.heic;*.heif)|*.heic;*.heif"
    if ($ofd.ShowDialog() -eq 'OK') {
        $global:collectedFiles += $ofd.FileNames
        $inputBox.Text = (Split-Path $ofd.FileNames[0])
        $outputBox.Text = $inputBox.Text
        $logBox.AppendText("Ready : $($global:collectedFiles.Count) file(s)`n")
    }
})
$form.Controls.Add($inputBrowse)

# Drag-drop
$dropLabel = New-Object System.Windows.Forms.Label
$dropLabel.Text = 'Drag && drop files or folders here'
$dropLabel.Size = New-Object System.Drawing.Size(600,50)
$dropLabel.Location = New-Object System.Drawing.Point(10,110)
$dropLabel.BorderStyle = 'FixedSingle'
$dropLabel.TextAlign = 'MiddleCenter'
$dropLabel.AllowDrop = $true
$form.Controls.Add($dropLabel)

$dropLabel.Add_DragEnter({
    if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
        $_.Effect = 'Copy'
    }
})

$dropLabel.Add_DragDrop({
    $firstResolvedPath = $null
    foreach ($item in $_.Data.GetData([Windows.Forms.DataFormats]::FileDrop)) {
        if (Test-Path $item -PathType Container) {
            if (-not $firstResolvedPath) {
                $firstResolvedPath = $item
            }
            $global:collectedFiles += (Get-ChildItem $item -Recurse -Include *.heic,*.heif).FullName
        } elseif ($item -match '\.heic$|\.heif$') {
            if (-not $firstResolvedPath) {
                $firstResolvedPath = Split-Path $item -Parent
            }
            $global:collectedFiles += $item
        }
    }
    if ($firstResolvedPath) {
        $inputBox.Text = $firstResolvedPath
        if (-not $outputBox.Text) {
            $outputBox.Text = $firstResolvedPath
        }
    }
    $logBox.AppendText("Ready : $($global:collectedFiles.Count) file(s)`n")
})

# Output
$outputLabel = New-Object System.Windows.Forms.Label
$outputLabel.Text = 'Export folder:'
$outputLabel.AutoSize = $true
$outputLabel.Location = New-Object System.Drawing.Point(10,173)
$form.Controls.Add($outputLabel)

$outputBox = New-Object System.Windows.Forms.TextBox
$outputBox.Location = New-Object System.Drawing.Point(110,170)
$outputBox.Size = New-Object System.Drawing.Size(395,20)
$form.Controls.Add($outputBox)

$outputBrowse = New-Object System.Windows.Forms.Button
$outputBrowse.Text = 'Browse'
$outputBrowse.Location = New-Object System.Drawing.Point(515,168)
$outputBrowse.Add_Click({
    $fbd = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($fbd.ShowDialog() -eq 'OK') {
        $outputBox.Text = $fbd.SelectedPath
    }
})
$form.Controls.Add($outputBrowse)

# Log + Progress
$logBox = New-Object System.Windows.Forms.RichTextBox
$logBox.Location = New-Object System.Drawing.Point(10,230)
$logBox.Size = New-Object System.Drawing.Size(600,200)
$logBox.ReadOnly = $true
$form.Controls.Add($logBox)

$progress = New-Object System.Windows.Forms.ProgressBar
$progress.Location = New-Object System.Drawing.Point(10,440)
$progress.Size = New-Object System.Drawing.Size(600,20)
$form.Controls.Add($progress)

$convertButton = New-Object System.Windows.Forms.Button
$convertButton.Text = 'Convert'
$convertButton.Location = New-Object System.Drawing.Point(270,470)
$convertButton.Add_Click({
    if (-not $global:collectedFiles.Count) {
        [System.Windows.Forms.MessageBox]::Show("Select at least one HEIC or HEIF file.")
        return
    }
    if (-not (Test-Path $outputBox.Text)) {
        [System.Windows.Forms.MessageBox]::Show("Select a valid output folder.")
        return
    }

    $logBox.Clear()
    Start-Convert -Files $global:collectedFiles -OutputFolder $outputBox.Text -LogBox $logBox -ProgressBar $progress
})
$form.Controls.Add($convertButton)

$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()

# -----------------------------
# Usage
# -----------------------------
# .\HEICconvert2JPG-GUI.ps1

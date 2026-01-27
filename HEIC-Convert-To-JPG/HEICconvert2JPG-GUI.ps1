# Revision : 5.4
# Description : GUI HEIC/HEIF to JPG Converter using Windows-native WIC decoding (no ImageMagick dependency)
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-04-01
# Modified Date : 2026-01-27

# -----------------------------
# Globals
# -----------------------------
$global:collectedFiles = @()
$logRoot = 'C:\temp\powershell-exports'

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
Add-Type -AssemblyName PresentationCore   # required for WIC BitmapDecoder

# -----------------------------
# Conversion Function (WIC)
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
    $archiveFolder = $null

    foreach ($filePath in $Files) {
        $ProgressBar.Value++

        try {
            $file = Get-Item -LiteralPath $filePath -ErrorAction Stop
            if ($file.Extension.ToLower() -notin '.heic', '.heif') { continue }

            if (-not $archiveFolder) {
                $archiveFolder = Join-Path (Split-Path $file.FullName) 'Original HEIC'
                if (-not (Test-Path $archiveFolder)) {
                    New-Item -ItemType Directory -Path $archiveFolder | Out-Null
                }
            }

            $jpgPath   = Join-Path $OutputFolder ($file.BaseName + '.jpg')
            $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
            $heicSize  = [math]::Round($file.Length / 1KB, 2)

            if (Test-Path $jpgPath) {
                $jpgSize = [math]::Round((Get-Item $jpgPath).Length / 1KB, 2)
                "$($file.Name),$($file.BaseName).jpg,Skipped,$heicSize,$jpgSize,N/A,$timestamp" |
                    Out-File $logPath -Append
                $LogBox.AppendText("Skipped : $($file.Name)`n")
                $skipped++
                continue
            }

            # ---- WIC decode ----
            $stream = [System.IO.File]::OpenRead($file.FullName)
            $decoder = [Windows.Media.Imaging.BitmapDecoder]::Create(
                $stream,
                [Windows.Media.Imaging.BitmapCreateOptions]::PreservePixelFormat,
                [Windows.Media.Imaging.BitmapCacheOption]::OnLoad
            )

            $frame = $decoder.Frames[0]
            $width  = $frame.PixelWidth
            $height = $frame.PixelHeight

            $encoder = New-Object Windows.Media.Imaging.JpegBitmapEncoder
            $encoder.Frames.Add([Windows.Media.Imaging.BitmapFrame]::Create($frame))

            $outStream = [System.IO.File]::Open($jpgPath, [System.IO.FileMode]::Create)
            $encoder.Save($outStream)

            $outStream.Close()
            $stream.Close()

            $jpg = Get-Item $jpgPath
            $jpgSize = [math]::Round($jpg.Length / 1KB, 2)

            Move-Item $file.FullName (Join-Path $archiveFolder $file.Name) -Force

            "$($file.Name),$($jpg.Name),Success,$heicSize,$jpgSize,${width}x${height},$timestamp" |
                Out-File $logPath -Append

            $LogBox.AppendText("Converted : $($file.Name)`n")
            $converted++
        }
        catch {
            "$($file.Name),,Failed,$heicSize,,,$timestamp" |
                Out-File $logPath -Append
            $LogBox.AppendText("Failed : $($file.Name)`n")
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
$form.Text = 'HEIC to JPG Converter (GUI Rev 5.4)'
$form.Size = New-Object System.Drawing.Size(640,540)
$form.StartPosition = 'CenterScreen'
$form.Topmost = $true

$infoLabel = New-Object System.Windows.Forms.Label
$infoLabel.Text = "Drag && drop HEIC/HEIF files or use Browse. Output defaults to input."
$infoLabel.Size = New-Object System.Drawing.Size(600,30)
$infoLabel.Location = New-Object System.Drawing.Point(10,10)
$form.Controls.Add($infoLabel)

$metaLabel = New-Object System.Windows.Forms.Label
$metaLabel.Text = "Author : Jason Lamb    Version : GUI Rev 5.4 (Windows-native)"
$metaLabel.Font = New-Object System.Drawing.Font("Segoe UI",8,[System.Drawing.FontStyle]::Italic)
$metaLabel.Location = New-Object System.Drawing.Point(10,40)
$form.Controls.Add($metaLabel)

# Input
$inputBox = New-Object System.Windows.Forms.TextBox
$inputBox.Location = New-Object System.Drawing.Point(100,70)
$inputBox.Size = New-Object System.Drawing.Size(400,20)
$form.Controls.Add($inputBox)

$inputBrowse = New-Object System.Windows.Forms.Button
$inputBrowse.Text = 'Browse'
$inputBrowse.Location = New-Object System.Drawing.Point(510,68)
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
$dropLabel.Location = New-Object System.Drawing.Point(10,100)
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
    foreach ($item in $_.Data.GetData([Windows.Forms.DataFormats]::FileDrop)) {
        if (Test-Path $item -PathType Container) {
            $global:collectedFiles += (Get-ChildItem $item -Recurse -Include *.heic,*.heif).FullName
        } elseif ($item -match '\.heic$|\.heif$') {
            $global:collectedFiles += $item
        }
    }
    $logBox.AppendText("Ready : $($global:collectedFiles.Count) file(s)`n")
})

# Output
$outputBox = New-Object System.Windows.Forms.TextBox
$outputBox.Location = New-Object System.Drawing.Point(100,160)
$outputBox.Size = New-Object System.Drawing.Size(400,20)
$form.Controls.Add($outputBox)

$outputBrowse = New-Object System.Windows.Forms.Button
$outputBrowse.Text = 'Browse'
$outputBrowse.Location = New-Object System.Drawing.Point(510,158)
$outputBrowse.Add_Click({
    $fbd = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($fbd.ShowDialog() -eq 'OK') {
        $outputBox.Text = $fbd.SelectedPath
    }
})
$form.Controls.Add($outputBrowse)

# Log + Progress
$logBox = New-Object System.Windows.Forms.RichTextBox
$logBox.Location = New-Object System.Drawing.Point(10,220)
$logBox.Size = New-Object System.Drawing.Size(600,200)
$logBox.ReadOnly = $true
$form.Controls.Add($logBox)

$progress = New-Object System.Windows.Forms.ProgressBar
$progress.Location = New-Object System.Drawing.Point(10,430)
$progress.Size = New-Object System.Drawing.Size(600,20)
$form.Controls.Add($progress)

$convertButton = New-Object System.Windows.Forms.Button
$convertButton.Text = 'Convert'
$convertButton.Location = New-Object System.Drawing.Point(270,460)
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
# pwsh .\HEICconvert2JPG-GUI.ps1

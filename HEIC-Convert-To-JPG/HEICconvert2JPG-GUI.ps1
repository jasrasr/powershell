<#
GUI Revision 2
- Convert $collectedFiles to a global variable
- Use += safely inside drag/drop to accumulate files
- Clear it after conversion
#>

<#
GUI Revision 3
- 🔁 Global file tracking is fixed — no more "drop a file first" false errors
- 📥 Multiple drops are supported — files accumulate
- 🧹 Files are reset after successful conversion
- ✅ Tested file persistence between events
- Drop files = ✔️ recognized
- Convert = ✅ processes
- Log + summary = 📋 working
- Files reset after conversion
#>

<#
GUI Revision 4
✅ Input folder browse option
✅ Output defaults to the same folder
✅ Instructions + metadata box (version, author, usage)
✅ Existing drag & drop support
✅ Logging, size tracking, dimensions, and summary — all still intact
#>

<#
GUI Revision 4.1
🧼 Replace the TextBox with:
A read-only Label (or multiple labels)
Styled with bold + spacing to look like grouped info
Not selectable, doesn't highlight, never takes focus
🧼 Instruction text is now a clean Label — no highlighting or focus issues
📄 Metadata (Author, Created, Version) is now visible and styled
💻 Input and output folder logic still intact, defaulting to same folder
#>
<#
Revision 4.2
input "Browse" button to select multiple .heic/.heif files
#>

<#
Revision 4.3
update "&" in output
#>

<#
Revision 5.0
package as exe
#>

# GUI Revision 5 - HEIC to JPG Converter
# Author: Jason Lamb
# Created: 2025-04
# Version: GUI Rev 5.0
# Description: Converts HEIC/HEIF files to JPG using ImageMagick via PowerShell GUI.
# Dependencies: ImageMagick (https://imagemagick.org)

$global:collectedFiles = @()

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Start-Convert {
    param (
        [string[]]$Files,
        [string]$OutputFolder,
        [System.Windows.Forms.RichTextBox]$LogBox,
        [System.Windows.Forms.ProgressBar]$ProgressBar
    )

    $converted = 0
    $skipped = 0
    $failed = 0

    $OutputFolder = (Resolve-Path $OutputFolder).Path
    $logPath = Join-Path $OutputFolder "conversion-log.csv"
    $archiveFolder = Join-Path (Split-Path -Path $Files[0]) 'Original HEIC'

    if (-not (Test-Path $archiveFolder)) { New-Item -ItemType Directory -Path $archiveFolder | Out-Null }

    if (-not (Test-Path $logPath)) {
        "Original File Name,Converted File Name,Status,HEIC Size (KB),JPG Size (KB),Dimensions,Timestamp" | Out-File $logPath -Encoding utf8
    }

    $ProgressBar.Maximum = $Files.Count
    $ProgressBar.Value = 0

    foreach ($filePath in $Files) {
        $ProgressBar.PerformStep()
        $file = Get-Item $filePath
        $ext = $file.Extension.ToLower()
        if ($ext -notin '.heic', '.heif') { continue }

        $jpgName = $file.BaseName + ".jpg"
        $jpgPath = Join-Path $OutputFolder $jpgName
        $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        $heicSize = [math]::Round($file.Length / 1KB, 2)

        if (Test-Path $jpgPath) {
            $jpgSize = [math]::Round((Get-Item $jpgPath).Length / 1KB, 2)
            "$($file.Name),$jpgName,Skipped (JPG exists),$heicSize,$jpgSize,N/A,$timestamp" | Out-File -FilePath $logPath -Append -Encoding utf8
            $LogBox.AppendText("⚠ Skipped: $($file.Name)`n")
            $skipped++
            continue
        }

        try {
            magick $file.FullName $jpgPath
            $jpg = Get-Item $jpgPath
            $jpgSize = [math]::Round($jpg.Length / 1KB, 2)
            $dimensions = magick identify -format "%wx%h" $jpgPath

            Move-Item -Path $file.FullName -Destination (Join-Path $archiveFolder $file.Name) -Force

            "$($file.Name),$jpgName,Success,$heicSize,$jpgSize,$dimensions,$timestamp" | Out-File -FilePath $logPath -Append -Encoding utf8
            $LogBox.AppendText("✔ Converted: $($file.Name)`n")
            $converted++
        }
        catch {
            "$($file.Name),$jpgName,Failed,$heicSize,,,$timestamp" | Out-File -FilePath $logPath -Append -Encoding utf8
            $LogBox.AppendText("❌ Failed: $($file.Name)`n")
            $failed++
        }
    }

    [System.Windows.Forms.MessageBox]::Show("Done! ✅ $converted converted, ⚠ $skipped skipped, ❌ $failed failed.","Conversion Summary")
    $global:collectedFiles = @()
}

# GUI Setup
$form = New-Object System.Windows.Forms.Form
$form.Text = "HEIC to JPG Converter (GUI Rev 4.3)"
$form.Size = New-Object System.Drawing.Size(640,540)
$form.StartPosition = "CenterScreen"

# Instructions (as label)
$infoLabel = New-Object System.Windows.Forms.Label
$infoLabel.AutoSize = $false
$infoLabel.Size = New-Object System.Drawing.Size(600, 40)
$infoLabel.Location = New-Object System.Drawing.Point(10,10)
$infoLabel.Text = "📅 Drag && drop HEIC/HEIF files below or use the Browse button.\n📁 Output folder defaults to input."
$infoLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$form.Controls.Add($infoLabel)

# Metadata label
$metaLabel = New-Object System.Windows.Forms.Label
$metaLabel.AutoSize = $false
$metaLabel.Size = New-Object System.Drawing.Size(600, 20)
$metaLabel.Location = New-Object System.Drawing.Point(10, 50)
$metaLabel.Text = "Author: Jason Lamb    Created: 2025-04    Version: GUI Rev 4.3"
$metaLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Italic)
$form.Controls.Add($metaLabel)

# Input Browse
$inputLabel = New-Object System.Windows.Forms.Label
$inputLabel.Text = "Input File(s):"
$inputLabel.Location = New-Object System.Drawing.Point(10,80)
$form.Controls.Add($inputLabel)

$inputBox = New-Object System.Windows.Forms.TextBox
$inputBox.Size = New-Object System.Drawing.Size(400,20)
$inputBox.Location = New-Object System.Drawing.Point(100,77)
$form.Controls.Add($inputBox)

$inputBrowse = New-Object System.Windows.Forms.Button
$inputBrowse.Text = "Browse"
$inputBrowse.Location = New-Object System.Drawing.Point(510,75)
$inputBrowse.Add_Click({
    $ofd = New-Object System.Windows.Forms.OpenFileDialog
    $ofd.Multiselect = $true
    $ofd.Filter = "HEIC and HEIF Files (*.heic;*.heif)|*.heic;*.heif"
    if ($ofd.ShowDialog() -eq "OK") {
        $global:collectedFiles += $ofd.FileNames
        $inputBox.Text = [System.IO.Path]::GetDirectoryName($ofd.FileNames[0])
        $outputBox.Text = $inputBox.Text
        $logBox.AppendText("📥 Ready: $($global:collectedFiles.Count) file(s)`n")
    }
})
$form.Controls.Add($inputBrowse)

# Drop zone
$dropLabel = New-Object System.Windows.Forms.Label
$dropLabel.Text = "Drag && drop files/folders here"
$dropLabel.Size = New-Object System.Drawing.Size(600,50)
$dropLabel.Location = New-Object System.Drawing.Point(10,110)
$dropLabel.BorderStyle = 'FixedSingle'
$dropLabel.TextAlign = "MiddleCenter"
$dropLabel.AllowDrop = $true
$form.Controls.Add($dropLabel)

# Output box
$outputLabel = New-Object System.Windows.Forms.Label
$outputLabel.Text = "Output Folder:"
$outputLabel.Location = New-Object System.Drawing.Point(10,170)
$form.Controls.Add($outputLabel)

$outputBox = New-Object System.Windows.Forms.TextBox
$outputBox.Size = New-Object System.Drawing.Size(400,20)
$outputBox.Location = New-Object System.Drawing.Point(100,167)
$form.Controls.Add($outputBox)

$browseButton = New-Object System.Windows.Forms.Button
$browseButton.Text = "Browse"
$browseButton.Location = New-Object System.Drawing.Point(510,165)
$browseButton.Add_Click({
    $fbd = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($fbd.ShowDialog() -eq "OK") {
        $outputBox.Text = $fbd.SelectedPath
    }
})
$form.Controls.Add($browseButton)

# Log box
$logBox = New-Object System.Windows.Forms.RichTextBox
$logBox.Size = New-Object System.Drawing.Size(600,200)
$logBox.Location = New-Object System.Drawing.Point(10,200)
$logBox.ReadOnly = $true
$form.Controls.Add($logBox)

# Progress bar
$progress = New-Object System.Windows.Forms.ProgressBar
$progress.Size = New-Object System.Drawing.Size(600,20)
$progress.Location = New-Object System.Drawing.Point(10,410)
$form.Controls.Add($progress)

# Convert button
$convertButton = New-Object System.Windows.Forms.Button
$convertButton.Text = "Convert"
$convertButton.Location = New-Object System.Drawing.Point(270,440)
$convertButton.Add_Click({
    if (-not $global:collectedFiles.Count) {
        [System.Windows.Forms.MessageBox]::Show("Drop or browse at least one file/folder first.")
        return
    }
    if (-not (Test-Path $outputBox.Text)) {
        [System.Windows.Forms.MessageBox]::Show("Please select a valid output folder.")
        return
    }

    $logBox.Clear()
    Start-Convert -Files $global:collectedFiles -OutputFolder $outputBox.Text -LogBox $logBox -ProgressBar $progress
})
$form.Controls.Add($convertButton)

# Drag/drop logic
$dropLabel.Add_DragEnter({
    if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
        $_.Effect = [Windows.Forms.DragDropEffects]::Copy
    }
})

$dropLabel.Add_DragDrop({
    $dropped = $_.Data.GetData([Windows.Forms.DataFormats]::FileDrop)
    foreach ($item in $dropped) {
        if (Test-Path $item -PathType Container) {
            $files = Get-ChildItem -Path $item -Include *.heic,*.heif -Recurse
            $global:collectedFiles += $files.FullName
        } elseif ($item -match "\.heic$|\.heif$") {
            $global:collectedFiles += $item
        }
    }
    $logBox.AppendText("📥 Ready: $($global:collectedFiles.Count) file(s)`n")
})

$form.Topmost = $true
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()

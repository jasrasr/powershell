<#
.SYNOPSIS
    Byte ↔ Bit Converter GUI with Download/Upload Simulation
.DESCRIPTION
    Converts between bytes and bits (KB/MB/GB/TB) and simulates both download
    and upload speeds using colored progress bars and directional animation.
.AUTHOR
    Jason Lamb (jasr.me)
.REVISION
    4.0
.CREATED
    2025-10-29
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- Custom colored ProgressBar class ---
Add-Type -TypeDefinition @"
using System;
using System.Windows.Forms;
using System.Drawing;
public class ColorProgressBar : ProgressBar
{
    public Color BarColor = Color.LimeGreen;
    protected override void OnPaint(PaintEventArgs e)
    {
        Rectangle rect = e.ClipRectangle;
        if (ProgressBarRenderer.IsSupported)
            ProgressBarRenderer.DrawHorizontalBar(e.Graphics, rect);
        rect.Inflate(-3, -3);
        int width = (int)((float)Value / Maximum * rect.Width);
        if (width <= 0) width = 1;
        using (SolidBrush brush = new SolidBrush(BarColor))
        {
            e.Graphics.FillRectangle(brush, rect.X, rect.Y, width, rect.Height);
        }
    }
}
"@

# --- Create Form ---
$form               = New-Object System.Windows.Forms.Form
$form.Text          = "Byte ↔ Bit Converter + NetSim"
$form.Size          = New-Object System.Drawing.Size(440,470)
$form.StartPosition = "CenterScreen"
$form.BackColor     = [System.Drawing.Color]::WhiteSmoke

# --- Title ---
$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = "Byte ↔ Bit Converter"
$lblTitle.Font = New-Object System.Drawing.Font("Segoe UI",14,[System.Drawing.FontStyle]::Bold)
$lblTitle.AutoSize = $true
$lblTitle.Location = New-Object System.Drawing.Point(90,20)
$form.Controls.Add($lblTitle)

# --- Input fields ---
$lblInput = New-Object System.Windows.Forms.Label
$lblInput.Text = "Enter Value:"
$lblInput.Location = New-Object System.Drawing.Point(30,70)
$form.Controls.Add($lblInput)

$txtInput = New-Object System.Windows.Forms.TextBox
$txtInput.Location = New-Object System.Drawing.Point(120,65)
$txtInput.Width = 120
$form.Controls.Add($txtInput)

$lblUnit = New-Object System.Windows.Forms.Label
$lblUnit.Text = "Unit:"
$lblUnit.Location = New-Object System.Drawing.Point(30,110)
$form.Controls.Add($lblUnit)

$cmbUnit = New-Object System.Windows.Forms.ComboBox
$cmbUnit.Location = New-Object System.Drawing.Point(120,105)
$cmbUnit.Width = 120
$cmbUnit.DropDownStyle = "DropDownList"
$cmbUnit.Items.AddRange(@("B","KB","MB","GB","TB"))
$cmbUnit.SelectedIndex = 2
$form.Controls.Add($cmbUnit)

$lblDir = New-Object System.Windows.Forms.Label
$lblDir.Text = "Convert:"
$lblDir.Location = New-Object System.Drawing.Point(30,150)
$form.Controls.Add($lblDir)

$cmbDirection = New-Object System.Windows.Forms.ComboBox
$cmbDirection.Location = New-Object System.Drawing.Point(120,145)
$cmbDirection.Width = 120
$cmbDirection.DropDownStyle = "DropDownList"
$cmbDirection.Items.AddRange(@("Bytes → Bits","Bits → Bytes"))
$cmbDirection.SelectedIndex = 0
$form.Controls.Add($cmbDirection)

$btnConvert = New-Object System.Windows.Forms.Button
$btnConvert.Text = "Convert"
$btnConvert.Location = New-Object System.Drawing.Point(260,145)
$btnConvert.Width = 90
$form.Controls.Add($btnConvert)

$lblOutput = New-Object System.Windows.Forms.Label
$lblOutput.Text = "Result:"
$lblOutput.Location = New-Object System.Drawing.Point(30,190)
$form.Controls.Add($lblOutput)

$txtOutput = New-Object System.Windows.Forms.TextBox
$txtOutput.Location = New-Object System.Drawing.Point(120,185)
$txtOutput.Width = 230
$txtOutput.ReadOnly = $true
$form.Controls.Add($txtOutput)

# --- Divider ---
$line = New-Object System.Windows.Forms.Label
$line.BorderStyle = 'Fixed3D'
$line.AutoSize = $false
$line.Width = 360
$line.Height = 2
$line.Location = New-Object System.Drawing.Point(30,225)
$form.Controls.Add($line)

# --- Network Speed ---
$lblSpeed = New-Object System.Windows.Forms.Label
$lblSpeed.Text = "Network Speed Simulation"
$lblSpeed.Font = New-Object System.Drawing.Font("Segoe UI",11,[System.Drawing.FontStyle]::Bold)
$lblSpeed.AutoSize = $true
$lblSpeed.Location = New-Object System.Drawing.Point(90,240)
$form.Controls.Add($lblSpeed)

$cmbSpeedPreset = New-Object System.Windows.Forms.ComboBox
$cmbSpeedPreset.Location = New-Object System.Drawing.Point(30,270)
$cmbSpeedPreset.Width = 200
$cmbSpeedPreset.DropDownStyle = "DropDownList"
$cmbSpeedPreset.Items.AddRange(@("10 Mbps","50 Mbps","100 Mbps","250 Mbps","500 Mbps","1 Gbps","10 Gbps"))
$cmbSpeedPreset.SelectedIndex = 2
$form.Controls.Add($cmbSpeedPreset)

$btnSpeedCalc = New-Object System.Windows.Forms.Button
$btnSpeedCalc.Text = "Show MB/s"
$btnSpeedCalc.Location = New-Object System.Drawing.Point(250,270)
$btnSpeedCalc.Width = 100
$form.Controls.Add($btnSpeedCalc)

$lblSpeedResult = New-Object System.Windows.Forms.Label
$lblSpeedResult.Text = ""
$lblSpeedResult.Location = New-Object System.Drawing.Point(30,305)
$lblSpeedResult.Width = 350
$form.Controls.Add($lblSpeedResult)

# --- Mode Selection ---
$lblMode = New-Object System.Windows.Forms.Label
$lblMode.Text = "Mode:"
$lblMode.Location = New-Object System.Drawing.Point(30,335)
$form.Controls.Add($lblMode)

$radioDownload = New-Object System.Windows.Forms.RadioButton
$radioDownload.Text = "Download"
$radioDownload.Checked = $true
$radioDownload.Location = New-Object System.Drawing.Point(120,330)
$form.Controls.Add($radioDownload)

$radioUpload = New-Object System.Windows.Forms.RadioButton
$radioUpload.Text = "Upload"
$radioUpload.Location = New-Object System.Drawing.Point(230,330)
$form.Controls.Add($radioUpload)

# --- ProgressBar ---
$progress = [ColorProgressBar]::new()
$progress.Location = New-Object System.Drawing.Point(30,365)
$progress.Size = New-Object System.Drawing.Size(360,25)
$progress.Minimum = 0
$progress.Maximum = 100
$progress.Value = 0
$form.Controls.Add($progress)

# --- Simulate Button ---
$btnSimulate = New-Object System.Windows.Forms.Button
$btnSimulate.Text = "Start Simulation"
$btnSimulate.Location = New-Object System.Drawing.Point(130,400)
$btnSimulate.Width = 160
$form.Controls.Add($btnSimulate)

# --- Conversion logic ---
$btnConvert.Add_Click({
    try {
        $value = [double]$txtInput.Text
        if ($value -lt 0) { throw "Value cannot be negative." }

        $multipliers = @{
            "B"  = 1
            "KB" = 1KB
            "MB" = 1MB
            "GB" = 1GB
            "TB" = 1TB
        }

        $baseBytes = $value * $multipliers[$cmbUnit.SelectedItem]

        if ($cmbDirection.SelectedItem -eq "Bytes → Bits") {
            $result = $baseBytes * 8
            $txtOutput.Text = "$result bits"
        } else {
            $result = $baseBytes / 8
            $txtOutput.Text = "$result bytes"
        }
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("Please enter a valid numeric value.","Invalid Input",
            [System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error)
    }
})

# --- MB/s calculation ---
$btnSpeedCalc.Add_Click({
    $sel = $cmbSpeedPreset.SelectedItem
    if ($sel -match "(\d+)\s*([MG])bps") {
        $num = [double]$matches[1]
        $mult = if ($matches[2] -eq "G") { 1e9 } else { 1e6 }
        $bps = $num * $mult
        $mbPerSec = ($bps / 8) / 1MB
        $lblSpeedResult.Text = "$sel ≈ {0:N2} MB/s" -f $mbPerSec
    }
})

# --- Simulation logic ---
$btnSimulate.Add_Click({
    $sel = $cmbSpeedPreset.SelectedItem
    if ($sel -match "(\d+)\s*([MG])bps") {
        $num = [double]$matches[1]
        $mult = if ($matches[2] -eq "G") { 1e9 } else { 1e6 }
        $bps = $num * $mult
        $mbPerSec = ($bps / 8) / 1MB
        $lblSpeedResult.Text = "$sel ≈ {0:N2} MB/s" -f $mbPerSec

        $progress.Value = 0
        if ($radioDownload.Checked) {
            $progress.BarColor = [System.Drawing.Color]::LimeGreen
            for ($i = 0; $i -le 100; $i++) {
                $progress.Value = $i
                Start-Sleep -Milliseconds (50 / [Math]::Max(1,($mbPerSec/10)))
                $progress.Refresh()
            }
            [System.Windows.Forms.MessageBox]::Show("Download simulation complete at $sel","Done")
        }
        else {
            $progress.BarColor = [System.Drawing.Color]::Crimson
            for ($i = 100; $i -ge 0; $i--) {
                $progress.Value = $i
                Start-Sleep -Milliseconds (50 / [Math]::Max(1,($mbPerSec/10)))
                $progress.Refresh()
            }
            [System.Windows.Forms.MessageBox]::Show("Upload simulation complete at $sel","Done")
        }
    }
})

# --- Show the form ---
[void]$form.ShowDialog()

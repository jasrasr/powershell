<#
.SYNOPSIS
    Byte ↔ Bit + Network Speed Converter (stable + reverse support)
.DESCRIPTION
    Converts between bits and bytes across units (storage + network).
    Includes presets for Mbps ↔ MB/s and custom reverse mode (MB/s → Mbps).
.AUTHOR
    Jason Lamb (jasr.me)
.REVISION
    2.5
.CHANGES
    - Added reverse MB/s → Mbps support for "Custom" preset
    - Fixed numeric parsing for both modes
    - Ensured Convert logic adapts dynamically to context
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ---------- Layout ----------
$leftLabel = 30
$leftInput = 150
$row1Y     = 60
$rowGap    = 40

$form = New-Object Windows.Forms.Form
$form.Text = "Byte ↔ Bit + Network Speed Converter"
$form.Size = [Drawing.Size]::new(500,360)
$form.StartPosition = 'CenterScreen'
$form.BackColor = [Drawing.Color]::WhiteSmoke
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.MinimizeBox = $false

$lblTitle = New-Object Windows.Forms.Label
$lblTitle.Text = "Byte ↔ Bit + Network Speed Converter"
$lblTitle.Font = [Drawing.Font]::new("Segoe UI",14,[Drawing.FontStyle]::Bold)
$lblTitle.AutoSize = $true
$lblTitle.Location = [Drawing.Point]::new(40,15)
$form.Controls.Add($lblTitle)

# ---------- Input ----------
$lblInput = New-Object Windows.Forms.Label
$lblInput.Text = "Enter Value:"
$lblInput.AutoSize = $true
$lblInput.Location = [Drawing.Point]::new($leftLabel,$row1Y)
$form.Controls.Add($lblInput)

$txtInput = New-Object Windows.Forms.TextBox
$txtInput.Location = [Drawing.Point]::new($leftInput,($row1Y-3))
$txtInput.Width = 160
$txtInput.BackColor = [Drawing.Color]::White
$txtInput.BorderStyle = 'FixedSingle'
$form.Controls.Add($txtInput)

# ---------- Unit ----------
$lblUnit = New-Object Windows.Forms.Label
$lblUnit.Text = "Unit:"
$lblUnit.AutoSize = $true
$lblUnit.Location = [Drawing.Point]::new($leftLabel,($row1Y+$rowGap))
$form.Controls.Add($lblUnit)

$cmbUnit = New-Object Windows.Forms.ComboBox
$cmbUnit.Location = [Drawing.Point]::new($leftInput,($row1Y+$rowGap-5))
$cmbUnit.Width = 160
$cmbUnit.DropDownStyle = 'DropDownList'
$cmbUnit.Items.AddRange(@("b","Kb","Mb","Gb","B","KB","MB","GB"))
$cmbUnit.SelectedIndex = 2
$form.Controls.Add($cmbUnit)

# ---------- Direction ----------
$lblDir = New-Object Windows.Forms.Label
$lblDir.Text = "Convert:"
$lblDir.AutoSize = $true
$lblDir.Location = [Drawing.Point]::new($leftLabel,($row1Y+2*$rowGap))
$form.Controls.Add($lblDir)

$cmbDirection = New-Object Windows.Forms.ComboBox
$cmbDirection.Location = [Drawing.Point]::new($leftInput,($row1Y+2*$rowGap-5))
$cmbDirection.Width = 160
$cmbDirection.DropDownStyle = 'DropDownList'
$cmbDirection.Items.AddRange(@("Bits → Bytes","Bytes → Bits"))
$cmbDirection.SelectedIndex = 0
$form.Controls.Add($cmbDirection)

$btnConvert = New-Object Windows.Forms.Button
$btnConvert.Text = "Convert"
$btnConvert.Width = 90
$btnConvert.Location = [Drawing.Point]::new(($leftInput+170),($row1Y+2*$rowGap-5))
$form.Controls.Add($btnConvert)
$form.AcceptButton = $btnConvert

# ---------- Presets ----------
$lblPreset = New-Object Windows.Forms.Label
$lblPreset.Text = "Network Preset:"
$lblPreset.AutoSize = $true
$lblPreset.Location = [Drawing.Point]::new($leftLabel,($row1Y+3*$rowGap))
$form.Controls.Add($lblPreset)

$cmbPreset = New-Object Windows.Forms.ComboBox
$cmbPreset.Location = [Drawing.Point]::new($leftInput,($row1Y+3*$rowGap-5))
$cmbPreset.Width = 300
$cmbPreset.DropDownStyle = 'DropDownList'
$cmbPreset.Items.AddRange(@(
    "Select preset…",
    "10 Mbps → MB/s",
    "25 Mbps → MB/s",
    "50 Mbps → MB/s",
    "100 Mbps → MB/s",
    "250 Mbps → MB/s",
    "500 Mbps → MB/s",
    "1 Gbps → MB/s",
    "2.5 Gbps → MB/s",
    "5 Gbps → MB/s",
    "10 Gbps → MB/s",
    "Custom: MB/s → Mbps"
))
$cmbPreset.SelectedIndex = 0
$form.Controls.Add($cmbPreset)

# ---------- Output ----------
$lblOutput = New-Object Windows.Forms.Label
$lblOutput.Text = "Result:"
$lblOutput.AutoSize = $true
$lblOutput.Location = [Drawing.Point]::new($leftLabel,($row1Y+4*$rowGap))
$form.Controls.Add($lblOutput)

$txtOutput = New-Object Windows.Forms.TextBox
$txtOutput.Location = [Drawing.Point]::new($leftInput,($row1Y+4*$rowGap-3))
$txtOutput.Width = 320
$txtOutput.ReadOnly = $true
$txtOutput.BackColor = [Drawing.Color]::White
$txtOutput.BorderStyle = 'FixedSingle'
$form.Controls.Add($txtOutput)

# ---------- Bit factor table ----------
$BitsPerUnit = @{
    'bit'   = 1
    'kbit'  = 1e3
    'mbit'  = 1e6
    'gbit'  = 1e9
    'byte'  = 8
    'kbyte' = 8e3
    'mbyte' = 8e6
    'gbyte' = 8e9
}

function Normalize-Unit {
    param([string]$u)
    switch -Regex ($u) {
        '^(b)$'  { 'bit' }
        '^(kb)$' { 'kbit' }
        '^(mb)$' { 'mbit' }
        '^(gb)$' { 'gbit' }
        '^(B)$'  { 'byte' }
        '^(KB)$' { 'kbyte' }
        '^(MB)$' { 'mbyte' }
        '^(GB)$' { 'gbyte' }
        default  { throw "Unknown unit: $u" }
    }
}

function Convert-Unit {
    param(
        [double]$Value,
        [string]$UiUnit,
        [string]$Direction
    )
    $key = Normalize-Unit ($UiUnit.ToString())
    $bits = $Value * $BitsPerUnit[$key]
    if ($Direction -eq 'Bits → Bytes') { return $bits / 8 }
    else { return $bits * 8 }
}

# ---------- Conversion Button ----------
$btnConvert.Add_Click({
    try {
        if ([string]::IsNullOrWhiteSpace($txtInput.Text)) { throw "Empty input" }
        $val = [double]::Parse($txtInput.Text)
        $preset = $cmbPreset.SelectedItem

        # If using Custom preset (MB/s → Mbps)
        if ($preset -like 'Custom*') {
            # MB/s → bits per second, then to Mbps
            $mbs = $val
            $mbps = ($mbs * 8)
            $txtOutput.Text = "{0:N2} MB/s ≈ {1:N2} Mbps" -f $mbs, $mbps
            return
        }

        # Normal conversion path
        $res = Convert-Unit -Value $val -UiUnit $cmbUnit.SelectedItem -Direction $cmbDirection.SelectedItem
        if ($cmbDirection.SelectedItem -eq 'Bits → Bytes') {
            $txtOutput.Text = "{0:N2} bytes" -f $res
        } else {
            $txtOutput.Text = "{0:N2} bits" -f $res
        }
    }
    catch {
        [Windows.Forms.MessageBox]::Show("Please enter a valid number.","Error",
            [Windows.Forms.MessageBoxButtons]::OK,[Windows.Forms.MessageBoxIcon]::Error)
    }
})

# ---------- Preset Logic ----------
$cmbPreset.Add_SelectedIndexChanged({
    $choice = $cmbPreset.SelectedItem
    $txtOutput.Clear()

    if ($choice -match '^\d+(\.\d+)?\s*Mbps') {
        $mbps = [double]($choice -replace '[^\d\.]','')
        $mbpsDecimalMBs = $mbps / 8
        $mbpsBinaryMiBs = $mbps / 8 * (1000/1024)
        $txtInput.Text = $mbps
        $cmbUnit.SelectedItem = 'Mb'
        $cmbDirection.SelectedItem = 'Bits → Bytes'
        $txtOutput.Text = ("{0} Mbps ≈ {1:N2} MB/s (decimal) / {2:N2} MiB/s (binary)" -f $mbps, $mbpsDecimalMBs, $mbpsBinaryMiBs)
    }
    elseif ($choice -like 'Custom: MB/s → Mbps') {
        $cmbUnit.SelectedItem = 'MB'
        $cmbDirection.SelectedItem = 'Bytes → Bits'
        [Windows.Forms.MessageBox]::Show(
            "Enter MB/s in 'Enter Value', then click Convert to see Mbps.",
            "Custom Reverse Mode",
            [Windows.Forms.MessageBoxButtons]::OK,[Windows.Forms.MessageBoxIcon]::Information)
    }
})

# ---------- Show ----------
[void]$form.ShowDialog()

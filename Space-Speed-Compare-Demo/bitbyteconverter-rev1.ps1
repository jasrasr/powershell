<#
.SYNOPSIS
    Byte ↔ Bit Converter GUI
.DESCRIPTION
    WinForms GUI that converts between bytes and bits across units (KB, MB, GB, TB).
.AUTHOR
    Jason Lamb (jasr.me)
.REVISION
    1.2
.CREATED
    2025-10-29
.CHANGES
    - Aligned labels and inputs in neat columns
    - Increased control width for readability
    - Fixed textboxes looking cut off
    - Added Enter key = Convert
    - Cleaned spacing so those weird "lines" don't appear
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ---------- Layout constants ----------
$leftLabel  = 30    # x position for labels
$leftInput  = 140   # x position for textboxes/comboboxes
$row1Y      = 70    # starting Y for first row
$rowGap     = 40    # vertical spacing between rows

# ---------- Form ----------
$form                       = New-Object System.Windows.Forms.Form
$form.Text                  = "Byte ↔ Bit Converter"
$form.Size                  = New-Object System.Drawing.Size(420,260)
$form.StartPosition         = "CenterScreen"
$form.BackColor             = [System.Drawing.Color]::WhiteSmoke
$form.FormBorderStyle       = 'FixedDialog'
$form.MaximizeBox           = $false
$form.MinimizeBox           = $false

# ---------- Title ----------
$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text      = "Byte ↔ Bit Converter"
$lblTitle.Font      = New-Object System.Drawing.Font("Segoe UI",14,[System.Drawing.FontStyle]::Bold)
$lblTitle.AutoSize  = $true
# Center the title based on form width
$lblTitle.Location  = New-Object System.Drawing.Point( ( ($form.ClientSize.Width - $lblTitle.PreferredWidth) / 2 ), 20 )
$form.Controls.Add($lblTitle)

# ---------- Row 1: Input Value ----------
$lblInput = New-Object System.Windows.Forms.Label
$lblInput.Text      = "Enter Value:"
$lblInput.AutoSize  = $true
$lblInput.Location  = New-Object System.Drawing.Point($leftLabel, $row1Y)
$form.Controls.Add($lblInput)

$txtInput = New-Object System.Windows.Forms.TextBox
$txtInput.Location  = New-Object System.Drawing.Point($leftInput, ($row1Y - 3))
$txtInput.Width     = 140
$txtInput.BackColor = [System.Drawing.Color]::White
$txtInput.BorderStyle = 'FixedSingle'
$form.Controls.Add($txtInput)

# ---------- Row 2: Unit ----------
$lblUnit = New-Object System.Windows.Forms.Label
$lblUnit.Text       = "Unit:"
$lblUnit.AutoSize   = $true
$lblUnit.Location   = New-Object System.Drawing.Point($leftLabel, ($row1Y + $rowGap))
$form.Controls.Add($lblUnit)

$cmbUnit = New-Object System.Windows.Forms.ComboBox
$cmbUnit.Location       = New-Object System.Drawing.Point($leftInput, ($row1Y + $rowGap - 5))
$cmbUnit.Width          = 140
$cmbUnit.DropDownStyle  = "DropDownList"
$cmbUnit.Items.AddRange(@("B","KB","MB","GB","TB"))
$cmbUnit.SelectedIndex  = 2   # default MB
$form.Controls.Add($cmbUnit)

# ---------- Row 3: Direction + Button ----------
$lblDir = New-Object System.Windows.Forms.Label
$lblDir.Text        = "Convert:"
$lblDir.AutoSize    = $true
$lblDir.Location    = New-Object System.Drawing.Point($leftLabel, ($row1Y + 2*$rowGap))
$form.Controls.Add($lblDir)

$cmbDirection = New-Object System.Windows.Forms.ComboBox
$cmbDirection.Location      = New-Object System.Drawing.Point($leftInput, ($row1Y + 2*$rowGap - 5))
$cmbDirection.Width         = 140
$cmbDirection.DropDownStyle = "DropDownList"
$cmbDirection.Items.AddRange(@("Bytes → Bits","Bits → Bytes"))
$cmbDirection.SelectedIndex = 0
$form.Controls.Add($cmbDirection)

$btnConvert = New-Object System.Windows.Forms.Button
$btnConvert.Text        = "Convert"
$btnConvert.Width       = 90
$btnConvert.Location    = New-Object System.Drawing.Point(($leftInput + 150), ($row1Y + 2*$rowGap - 5))
$form.Controls.Add($btnConvert)

# Make Enter key press the Convert button
$form.AcceptButton = $btnConvert

# ---------- Row 4: Result ----------
$lblOutput = New-Object System.Windows.Forms.Label
$lblOutput.Text      = "Result:"
$lblOutput.AutoSize  = $true
$lblOutput.Location  = New-Object System.Drawing.Point($leftLabel, ($row1Y + 3*$rowGap))
$form.Controls.Add($lblOutput)

$txtOutput = New-Object System.Windows.Forms.TextBox
$txtOutput.Location     = New-Object System.Drawing.Point($leftInput, ($row1Y + 3*$rowGap - 3))
$txtOutput.Width        = 240
$txtOutput.ReadOnly     = $true
$txtOutput.BackColor    = [System.Drawing.Color]::White
$txtOutput.BorderStyle  = 'FixedSingle'
$form.Controls.Add($txtOutput)

# ---------- Conversion Logic ----------
$doConvert = {
    try {
        $value = [double]$txtInput.Text
        if ($value -lt 0) { throw "Value cannot be negative." }

        # NOTE: These are binary units (1KB = 1024B, 1MB = 1024KB, etc.)
        $multipliers = @{
            "B"  = 1
            "KB" = 1KB
            "MB" = 1MB
            "GB" = 1GB
            "TB" = 1TB
        }

        $baseBytes = $value * $multipliers[$cmbUnit.SelectedItem]

        if ($cmbDirection.SelectedItem -eq "Bytes → Bits") {
            $resultBits = $baseBytes * 8
            $txtOutput.Text = "{0:N0} bits" -f $resultBits
        }
        else {
            # Bits → Bytes
            # if they say "5 MB" and choose "Bits → Bytes"
            # we're interpreting that as: treat input as MB *in bits*
            # so: first get bytes from that MB, then divide by 8 to get bytes from bits.
            $resultBytes = ($baseBytes / 8)
            $txtOutput.Text = "{0:N0} bytes" -f $resultBytes
        }
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show(
            "Please enter a valid non-negative number.",
            "Invalid Input",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        )
    }
}

$btnConvert.Add_Click($doConvert)

# ---------- Show ----------
[void]$form.ShowDialog()

<#
USAGE EXAMPLES
-------------
. .\ByteBitConverter.ps1
# Type 1
# Unit: MB
# Convert: Bytes → Bits
# Press Enter
# → Result ~ 8,388,608 bits

RUNNING CHANGELOG
-----------------
Rev 1.0  - Initial GUI, basic convert logic
Rev 1.1  - White textboxes, border style, fixed dialog, commas in output
Rev 1.2  - Proper align/spacing, wider inputs, Enter key triggers Convert, cleaner Result row
#>

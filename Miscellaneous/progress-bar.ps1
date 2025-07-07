# Revision : 2.1
# Description : GUI version of variable-time progress bar using WinForms (param fix)
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-07-01
# Modified Date : 2025-07-01

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# === CONFIGURATION ===
$MinSeconds = 3
$MaxSeconds = 10

# Generate random duration
$duration = Get-Random -Minimum $MinSeconds -Maximum ($MaxSeconds + 1)
$steps = 100
$interval = $duration / $steps

# === BUILD GUI ===
$form = New-Object System.Windows.Forms.Form
$form.Text = "Progress Task"
$form.Size = New-Object System.Drawing.Size(400,120)
$form.StartPosition = "CenterScreen"
$form.Topmost = $true

# Label
$label = New-Object System.Windows.Forms.Label
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(10,10)
$label.Text = "Processing... 0%"
$form.Controls.Add($label)

# Progress bar
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(10,40)
$progressBar.Size = New-Object System.Drawing.Size(360,25)
$progressBar.Minimum = 0
$progressBar.Maximum = 100
$form.Controls.Add($progressBar)

# Timer
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = $interval * 1000  # milliseconds

$i = 0
$timer.Add_Tick({
    $i++
    $progressBar.Value = $i
    $label.Text = "Processing... $i%"

    if ($i -ge 100) {
        $timer.Stop()
        $label.Text = "Completed in $duration seconds!"
        Start-Sleep -Milliseconds 500
        $form.Close()
    }
})

# Start timer when form is shown
$form.Add_Shown({ $timer.Start() })

# Show the GUI
[void]$form.ShowDialog()

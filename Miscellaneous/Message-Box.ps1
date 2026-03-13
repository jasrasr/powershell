# Filename: Message-Box.ps1
# Revision : 1.1
# Description : PowerShell MessageBox reference guide - demonstrates all button and icon combinations
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-03-13
# Modified Date : 2025-03-13
# Changelog :
# 1.0 initial release
# 1.1 add examples with notes

# Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show("Your message here", "IT Notice", "OK", "Information")
# SYNTAX INLINE EXPLANATION
# Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show("[Message Text Displayed]", "[Message box header]", "[Button Text]", "[Message box type]")
# SYNTAX BREAKDOWN
<#
[System.Windows.MessageBox]::Show(
"Your message here", # the text displayed
"IT Notice", # mesage header
"OK", # button to click
"Information") # Type of message
#>

# THIS IS REQUIRED
# Without Add-Type -AssemblyName PresentationFramework, PowerShell won't know where to find the MessageBox class and will throw an error.

# showing different button types
Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show("ok - informational - sound 1", "IT Notice", "OK", "Information")
Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show("okcancel - informational - sound 1", "IT Notice", "okcancel", "Information")
Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show("yesno - informational - sound 1", "IT Notice", "yesno", "Information")
Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show("yesnocancel - informational - sound 1", "IT Notice", "yesnocancel", "Information")

# showing different message types
Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show("ok - none - no sound", "IT Notice", "OK", "None")
Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show("ok - question - no sound", "IT Notice", "OK", "Question")
Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show("ok - warning - sound 1", "IT Notice", "OK", "Warning")
Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show("ok - error - sound 2", "IT Notice", "OK", "Error")
Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show("ok - asterisk - sound 1", "IT Notice", "OK", "Asterisk")
# Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show("ok - exclamation - sound 1", "IT Notice", "OK", "Exclamation") # same as WARNING, duplicate alias
# Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show("ok - hand - sound 2", "IT Notice", "OK", "Hand") # same as ERROR, duplicate alias
# Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show("ok - stop - sound 2 ", "IT Notice", "OK", "Stop") # same as ERROR, duplicate alias

<#
Button Type (3rd parameter)
OK — single OK button
OKCancel — OK and Cancel
YesNo — Yes and No
YesNoCancel — Yes, No, and Cancel
#>

<#
Message Type (4th parameter)
None — no icon
Information — ℹ️ blue info circle
Question — ❓ question mark
Warning — ⚠️ yellow warning triangle
Error — ❌ red X / stop sign
Asterisk — same as Information
Exclamation — same as Warning
Hand — same as Error
Stop — same as Error
#>

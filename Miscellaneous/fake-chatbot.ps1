# Revision : 1.0
# Description : Simple WinForms GUI chat window with text prompt and bot-style responses. Rev 1.0
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-12-03
# Modified Date : 2025-12-03

<#
    Recap / Features
    - Opens a small chat-style window.
    - Top box shows the running conversation (read-only).
    - Bottom box is where you type your message.
    - Click "Send" or press Enter to get a simple bot response.
    - Basic canned responses for greetings, time, date, and fallback echo.

    Revision History
    - 1.0 : Initial GUI chat bot mockup.
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Get-ChatBotReply {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    $trimmed = $Message.Trim().ToLower()

    if ([string]::IsNullOrWhiteSpace($trimmed)) {
        return "Please type something so I can respond."
    }

    switch -regex ($trimmed) {
        '^(hi|hello|hey)\b' {
            return "Hello $env:USERNAME, how can I help you today?"
        }
        'time' {
            $now = Get-Date
            return "Current time on this machine is $now"
        }
        'date' {
            $today = Get-Date -Format 'yyyy-MM-dd'
            return "Today's date is $today"
        }
        'who are you' {
            return "I am a tiny fake chat bot living inside PowerShell."
        }
        'clear chat' {
            return "Type '/clear' to clear the chat window."
        }
        default {
            return "You said : '$Message'. I am just a demo bot, but I heard you."
        }
    }
}

function Start-ChatBotGui {

    # --- Form setup ---
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "PowerShell Chat Bot Demo"
    $form.StartPosition = "CenterScreen"
    $form.Size = New-Object System.Drawing.Size(700, 450)
    $form.MinimumSize = New-Object System.Drawing.Size(600, 400)

    # --- Conversation textbox (top, multiline, read-only) ---
    $txtConversation = New-Object System.Windows.Forms.TextBox
    $txtConversation.Multiline = $true
    $txtConversation.ReadOnly = $true
    $txtConversation.ScrollBars = "Vertical"
    $txtConversation.WordWrap = $true
    $txtConversation.Font = New-Object System.Drawing.Font("Consolas", 10)
    $txtConversation.BackColor = [System.Drawing.Color]::White
    $txtConversation.Location = New-Object System.Drawing.Point(10, 10)
    $txtConversation.Size = New-Object System.Drawing.Size(($form.ClientSize.Width - 20), 280)
    $txtConversation.Anchor = "Top,Left,Right"
    $txtConversation.Text = "Bot : Hello $env:USERNAME, I am your PowerShell chat demo. Type a message below and click Send.`r`n"

    # --- Input textbox (bottom, single-line) ---
    $txtInput = New-Object System.Windows.Forms.TextBox
    $txtInput.Multiline = $false
    $txtInput.Font = New-Object System.Drawing.Font("Consolas", 10)
    $txtInput.Location = New-Object System.Drawing.Point(10, 310)
    $txtInput.Size = New-Object System.Drawing.Size(($form.ClientSize.Width - 120), 30)
    $txtInput.Anchor = "Bottom,Left,Right"

    # --- Send button ---
    $btnSend = New-Object System.Windows.Forms.Button
    $btnSend.Text = "Send"
    $btnSend.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $btnSend.Size = New-Object System.Drawing.Size(80, 30)
    $btnSend.Location = New-Object System.Drawing.Point(($form.ClientSize.Width - 90), 310)
    $btnSend.Anchor = "Bottom,Right"

    # --- Optional Clear button ---
    $btnClear = New-Object System.Windows.Forms.Button
    $btnClear.Text = "Clear"
    $btnClear.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $btnClear.Size = New-Object System.Drawing.Size(80, 28)
    $btnClear.Location = New-Object System.Drawing.Point(($form.ClientSize.Width - 90), 350)
    $btnClear.Anchor = "Bottom,Right"

    # Make Enter key trigger Send
    $form.AcceptButton = $btnSend

    # --- Helper : append text to conversation box safely ---
    $appendConversation = {
        param(
            [string]$newLine
        )

        if (-not [string]::IsNullOrEmpty($txtConversation.Text)) {
            $txtConversation.AppendText("`r`n")
        }
        $txtConversation.AppendText($newLine)
        $txtConversation.SelectionStart = $txtConversation.Text.Length
        $txtConversation.ScrollToCaret()
    }

    # --- Send click event ---
    $btnSend.Add_Click({
        $userText = $txtInput.Text.Trim()
        if ([string]::IsNullOrWhiteSpace($userText)) {
            return
        }

        # Allow a magic /clear command to wipe history
        if ($userText -eq "/clear") {
            $txtConversation.Text = "Bot : Chat cleared. Start again whenever you are ready."
            $txtInput.Clear()
            return
        }

        & $appendConversation.Invoke("You  : $userText")

        $reply = Get-ChatBotReply -Message $userText
        & $appendConversation.Invoke("Bot : $reply")

        $txtInput.Clear()
        $txtInput.Focus()
    })

    # --- Clear button event (same as /clear) ---
    $btnClear.Add_Click({
        $txtConversation.Text = "Bot : Chat cleared. Start again whenever you are ready."
        $txtInput.Clear()
        $txtInput.Focus()
    })

    # --- Resize handler so controls follow the form size nicely ---
    $form.Add_Resize({
        $txtConversation.Size = New-Object System.Drawing.Size(($form.ClientSize.Width - 20), ($form.ClientSize.Height - 160))
        $txtInput.Location     = New-Object System.Drawing.Point(10, ($form.ClientSize.Height - 90))
        $txtInput.Size         = New-Object System.Drawing.Size(($form.ClientSize.Width - 120), 30)
        $btnSend.Location      = New-Object System.Drawing.Point(($form.ClientSize.Width - 90), ($form.ClientSize.Height - 90))
        $btnClear.Location     = New-Object System.Drawing.Point(($form.ClientSize.Width - 90), ($form.ClientSize.Height - 50))
    })

    # --- Add controls to form ---
    $form.Controls.Add($txtConversation)
    $form.Controls.Add($txtInput)
    $form.Controls.Add($btnSend)
    $form.Controls.Add($btnClear)

    # --- Show the form ---
    [void]$form.ShowDialog()
}

# Auto-start the GUI when the script is run directly
Start-ChatBotGui

# ============================================
# Example usage (dot-sourcing style)
# . .\chatbot-gui-demo.ps1
# Start-ChatBotGui
# ============================================

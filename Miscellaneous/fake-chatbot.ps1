# Revision : 1.1
# Description : WinForms Chat Bot with external prompt-answer text file support. Rev 1.1
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-12-03
# Modified Date : 2025-12-03

<# 
    Recap / Changes in Rev 1.1
    - Added Get-StoredReply function to load prompts + answers from file
    - Prompts file format:
           prompt=hello|hi|hey
           reply=Hello there, human.

           prompt=time
           reply=The current time is $(Get-Date).

           prompt=weather
           reply=I am not a weather bot, but it's probably cold. Because Ohio.

    - Script now checks keywords in the message and returns the stored reply
    - Falls back to default "I heard you" answer if no match exists
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Path to prompts file (modify as needed)
$PromptsFile = "C:\temp\chatbot-prompts.txt"

function Get-StoredReply {
    param(
        [Parameter(Mandatory = $true)]
        [string]$UserMessage
    )

    if (-not (Test-Path $PromptsFile)) {
        return "Prompts file missing at $PromptsFile , so I'm just guessing."
    }

    $content = Get-Content $PromptsFile -Raw
    $blocks  = $content -split '(?=prompt=)'  # split on each "prompt=" line

    $msgLower = $UserMessage.ToLower()

    foreach ($block in $blocks) {
        if ($block.Trim().Length -eq 0) { continue }

        # Extract prompt keywords
        if ($block -match "prompt=(.+)"){
            $keywords = $Matches[1].Split("|") | ForEach-Object { $_.Trim().ToLower() }
        }

        # Extract reply text
        if ($block -match "reply=(.+)") {
            $reply = $Matches[1].Trim()
        }

        # Keyword match — any keyword must appear in message
        foreach ($k in $keywords) {
            if ($msgLower -like "*$k*") {
                # Evaluate PowerShell inside the reply if it exists
                if ($reply -match '\$\(') {
                    return (Invoke-Expression "`"$reply`"")
                }
                return $reply
            }
        }
    }

    return $null  # No match found
}

function Get-ChatBotReply {
    param(
        [string]$Message
    )

    if ([string]::IsNullOrWhiteSpace($Message)) {
        return "Please type something so I can respond."
    }

    $stored = Get-StoredReply -UserMessage $Message

    if ($stored) { return $stored }

    return "You said : '$Message' ... and I have no clue what that means yet."
}

function Start-ChatBotGui {

    # --- Main Form ---
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "PowerShell Chat Bot Demo"
    $form.StartPosition = "CenterScreen"
    $form.Size = New-Object System.Drawing.Size(700, 450)

    # Conversation window
    $txtConversation = New-Object System.Windows.Forms.TextBox
    $txtConversation.Multiline = $true
    $txtConversation.ReadOnly = $true
    $txtConversation.ScrollBars = "Vertical"
    $txtConversation.Location = New-Object System.Drawing.Point(10, 10)
    $txtConversation.Font = "Consolas,10"
    $txtConversation.Size = New-Object System.Drawing.Size(660, 280)

    $txtConversation.Text = "Bot : Hello $env:USERNAME , I loaded my brain from $PromptsFile .`r`n"

    # Input
    $txtInput = New-Object System.Windows.Forms.TextBox
    $txtInput.Location = New-Object System.Drawing.Point(10, 310)
    $txtInput.Size = New-Object System.Drawing.Size(560, 30)
    $txtInput.Font = "Consolas,10"

    # Send button
    $btnSend = New-Object System.Windows.Forms.Button
    $btnSend.Text = "Send"
    $btnSend.Location = New-Object System.Drawing.Point(580, 310)
    $btnSend.Size = New-Object System.Drawing.Size(90, 30)

    # Clear button
    $btnClear = New-Object System.Windows.Forms.Button
    $btnClear.Text = "Clear"
    $btnClear.Location = New-Object System.Drawing.Point(580, 350)
    $btnClear.Size = New-Object System.Drawing.Size(90, 28)

    # Add events
    $appendConversation = {
        param([string]$line)
        $txtConversation.AppendText("`r`n$line")
        $txtConversation.ScrollToCaret()
    }

    # Send logic
    $btnSend.Add_Click({
        $msg = $txtInput.Text.Trim()
        if ($msg.Length -eq 0) { return }

        if ($msg -eq "/clear") {
            $txtConversation.Text = "Bot : Chat cleared. Ready again."
            $txtInput.Clear()
            return
        }

        & $appendConversation.Invoke("You  : $msg")

        $reply = Get-ChatBotReply -Message $msg
        & $appendConversation.Invoke("Bot : $reply")

        $txtInput.Clear()
    })

    # Clear logic
    $btnClear.Add_Click({
        $txtConversation.Text = "Bot : Chat cleared."
    })

    # Show GUI
    $form.Controls.Add($txtConversation)
    $form.Controls.Add($txtInput)
    $form.Controls.Add($btnSend)
    $form.Controls.Add($btnClear)
    $form.ShowDialog()
}

Start-ChatBotGui

# Example usage:
# . .\ChatBot.ps1
# Start-ChatBotGui

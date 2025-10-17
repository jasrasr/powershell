<#
  File        : QuizEngine.ps1
  Revision    : 1.5
  Author      : You + ChatGPT
  Purpose     : Reusable PowerShell Quiz Engine (WinForms)
  Notes       : - Loads question set via -QuestionSetPath (dot-sourced)
                - Answers kept XOR-obfuscated in set file; engine never stores plaintext
                - Reveals plaintext answers ONLY if score == 100%
                - If <100%, offers Restart with a forced cooldown timer
                - Logs include duration, per-question timing & behavior, encoded key, and SHA256 of plaintext

  Revision Log:
  - 1.2: Per-question timing & change counts
  - 1.3: Encoded key + SHA256 in log
  - 1.4: Reveal plaintext only on perfect score; restart prompt otherwise
  - 1.5: Split engine from question sets; added retry cooldown & attempt counter in logs

#>

param(
    [Parameter(Mandatory)]
    [string] $QuestionSetPath,                 # e.g. ".\questions-easy.ps1" or ".\questions-medium.ps1"

    [int] $RetryCooldownSeconds = 10           # forced wait before retry, if not perfect
)

# ---------------------------
# Load Question Set (dot-source)
# ---------------------------
if (-not (Test-Path -LiteralPath $QuestionSetPath)) {
    throw "Question set not found at path: $QuestionSetPath"
}
. $QuestionSetPath

# The set must define: $Questions (array of 10), [byte[]] $ObfuscatedAnswers, $AnswerKeyXor
if (-not $Questions -or -not $ObfuscatedAnswers -or -not $AnswerKeyXor) {
    throw "Question set did not define required variables `$Questions, `$ObfuscatedAnswers, `$AnswerKeyXor."
}

# ---------------------------
# Imports
# ---------------------------
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Security

# ---------------------------
# Helpers
# ---------------------------
function Get-DecodedAnswers {
    param([byte[]] $Blob, [byte] $Key)
    -join (foreach ($b in $Blob) { [char] ($b -bxor $Key) })
}

function To-Base64 {
    param([string] $s)
    [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($s))
}

function To-BinaryString {
    param([string] $s)
    ($s.ToCharArray() | ForEach-Object { [Convert]::ToString([byte][char]$_,2).PadLeft(8,'0') }) -join ' '
}

function Compute-SHA256Hex {
    param([string] $plain)
    $sha = [System.Security.Cryptography.SHA256]::Create()
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($plain)
    $hash = $sha.ComputeHash($bytes)
    -join ($hash | ForEach-Object { $_.ToString("x2") })
}

function Format-TimeSpan {
    param([TimeSpan] $ts)
    "{0:00}:{1:00}:{2:00}.{3:000}" -f [int]$ts.Hours, [int]$ts.Minutes, [int]$ts.Seconds, [int]($ts.Milliseconds)
}

# ---------------------------
# Logging / Session
# ---------------------------
$LogRoot = 'C:\temp\powershell-exports'
if (-not (Test-Path $LogRoot)) { New-Item -Path $LogRoot -ItemType Directory -Force | Out-Null }
$SessionStamp = (Get-Date -Format 'yyyyMMdd-HHmmss')
$LogPath = Join-Path $LogRoot "powershell-quiz-$SessionStamp.log"

$AttemptNumber = 0

# ---------------------------
# Timing / Tracking State
# ---------------------------
$Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$QuizStartTime = $null
$QuizEndTime = $null

$QuestionEnterAt      = New-Object 'System.Collections.Generic.List[datetime]'
$QuestionTimeSpent    = New-Object 'System.Collections.Generic.List[TimeSpan]'
$AnswerFirstAt        = New-Object 'System.Collections.Generic.List[Nullable[datetime]]'
$AnswerChangeCount    = New-Object 'System.Collections.Generic.List[int]'
1..$Questions.Count | ForEach-Object {
    [void]$QuestionEnterAt.Add([datetime]::MinValue)
    [void]$QuestionTimeSpent.Add([TimeSpan]::Zero)
    [void]$AnswerFirstAt.Add([Nullable[datetime]]::new())
    [void]$AnswerChangeCount.Add(0)
}

# ---------------------------
# GUI
# ---------------------------
$form = New-Object System.Windows.Forms.Form
$form.Text = "PowerShell Quiz"
$form.Size = New-Object System.Drawing.Size(720, 560)
$form.StartPosition = "CenterScreen"

$lblQuestionNum = New-Object System.Windows.Forms.Label
$lblQuestionNum.Location = New-Object System.Drawing.Point(20, 15)
$lblQuestionNum.Size = New-Object System.Drawing.Size(300, 20)
$form.Controls.Add($lblQuestionNum)

$txtQuestion = New-Object System.Windows.Forms.Label
$txtQuestion.Location = New-Object System.Drawing.Point(20, 45)
$txtQuestion.Size = New-Object System.Drawing.Size(660, 40)
$txtQuestion.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($txtQuestion)

$grpAnswers = New-Object System.Windows.Forms.GroupBox
$grpAnswers.Location = New-Object System.Drawing.Point(20, 95)
$grpAnswers.Size = New-Object System.Drawing.Size(660, 200)
$grpAnswers.Text = "Choose one:"
$form.Controls.Add($grpAnswers)

$radioButtons = @()
for ($i = 0; $i -lt 4; $i++) {
    $rb = New-Object System.Windows.Forms.RadioButton
    $rb.Location = New-Object System.Drawing.Point(15, 30 + ($i * 35))
    $rb.Size = New-Object System.Drawing.Size(620, 30)
    $grpAnswers.Controls.Add($rb)
    $radioButtons += $rb
}

$btnPrev = New-Object System.Windows.Forms.Button
$btnPrev.Location = New-Object System.Drawing.Point(20, 310)
$btnPrev.Size = New-Object System.Drawing.Size(90, 35)
$btnPrev.Text = "Previous"
$form.Controls.Add($btnPrev)

$btnNext = New-Object System.Windows.Forms.Button
$btnNext.Location = New-Object System.Drawing.Point(120, 310)
$btnNext.Size = New-Object System.Drawing.Size(90, 35)
$btnNext.Text = "Next"
$form.Controls.Add($btnNext)

$btnSubmit = New-Object System.Windows.Forms.Button
$btnSubmit.Location = New-Object System.Drawing.Point(230, 310)
$btnSubmit.Size = New-Object System.Drawing.Size(90, 35)
$btnSubmit.Text = "Submit"
$form.Controls.Add($btnSubmit)

$btnReveal = New-Object System.Windows.Forms.Button
$btnReveal.Location = New-Object System.Drawing.Point(330, 310)
$btnReveal.Size = New-Object System.Drawing.Size(120, 35)
$btnReveal.Text = "Reveal Answers"
$btnReveal.Enabled = $false
$form.Controls.Add($btnReveal)

$lblStatus = New-Object System.Windows.Forms.Label
$lblStatus.Location = New-Object System.Drawing.Point(20, 360)
$lblStatus.Size = New-Object System.Drawing.Size(660, 40)
$lblStatus.Text = "Answer all questions, then click Submit."
$form.Controls.Add($lblStatus)

$lblLegend = New-Object System.Windows.Forms.Label
$lblLegend.Location = New-Object System.Drawing.Point(20, 405)
$lblLegend.Size = New-Object System.Drawing.Size(660, 35)
$lblLegend.Text = "Perfect score reveals answers. Otherwise, retry after cooldown."
$lblLegend.ForeColor = [System.Drawing.Color]::Gray
$form.Controls.Add($lblLegend)

$lblCooldown = New-Object System.Windows.Forms.Label
$lblCooldown.Location = New-Object System.Drawing.Point(20, 445)
$lblCooldown.Size = New-Object System.Drawing.Size(660, 35)
$lblCooldown.Text = ""
$lblCooldown.ForeColor = [System.Drawing.Color]::Tomato
$form.Controls.Add($lblCooldown)

# ---------------------------
# Quiz State
# ---------------------------
$currentIndex = 0
$userSelections = New-Object System.Collections.Generic.List[string]
1..$Questions.Count | ForEach-Object { [void]$userSelections.Add($null) }

$CooldownTimer = New-Object System.Windows.Forms.Timer
$CooldownTimer.Interval = 1000
$CooldownRemaining = 0

function Disable-Navigation {
    $btnPrev.Enabled = $false
    $btnNext.Enabled = $false
    $btnSubmit.Enabled = $false
    foreach ($rb in $radioButtons) { $rb.Enabled = $false }
}

function Enable-Navigation {
    $btnPrev.Enabled = ($currentIndex -gt 0)
    $btnNext.Enabled = ($currentIndex -lt ($Questions.Count - 1))
    $btnSubmit.Enabled = $true
    foreach ($rb in $radioButtons) { $rb.Enabled = $true }
}

function Reset-Tracking {
    0..($Questions.Count - 1) | ForEach-Object {
        $userSelections[$_] = $null
        $QuestionEnterAt[$_] = [datetime]::MinValue
        $QuestionTimeSpent[$_] = [TimeSpan]::Zero
        $AnswerFirstAt[$_] = [Nullable[datetime]]::new()
        $AnswerChangeCount[$_] = 0
    }
}

function Reset-Quiz {
    Reset-Tracking
    $currentIndex = 0
    $script:HasEntered = $false
    $script:PrevIndex = 0
    $btnReveal.Enabled = $false
    $lblStatus.Text = "Answer all questions, then click Submit."
    $lblCooldown.Text = ""
    $Stopwatch.Restart()
    $QuizStartTime = Get-Date
    Load-Question -index 0
}

function Load-Question {
    param([int] $index)
    $now = Get-Date
    if ($script:HasEntered -and $QuestionEnterAt[$script:PrevIndex] -ne [datetime]::MinValue) {
        $QuestionTimeSpent[$script:PrevIndex] = $QuestionTimeSpent[$script:PrevIndex] + ($now - $QuestionEnterAt[$script:PrevIndex])
    }

    $q = $Questions[$index]
    $lblQuestionNum.Text = "Question $($index + 1) of $($Questions.Count)"
    $txtQuestion.Text = $q.Q

    for ($i = 0; $i -lt 4; $i++) {
        $radioButtons[$i].Text = $q.A[$i]
        $radioButtons[$i].Checked = $false
    }

    $sel = $userSelections[$index]
    if ($sel) {
        $map = @{ 'A' = 0; 'B' = 1; 'C' = 2; 'D' = 3 }
        if ($map.ContainsKey($sel)) { $radioButtons[$map[$sel]].Checked = $true }
    }

    $QuestionEnterAt[$index] = Get-Date
    $script:HasEntered = $true
    $script:PrevIndex = $index
    Enable-Navigation
}

function Capture-Selection {
    $mapBack = @('A','B','C','D')
    $selected = $null
    for ($i = 0; $i -lt 4; $i++) {
        if ($radioButtons[$i].Checked) { $selected = $mapBack[$i]; break }
    }

    $prior = $userSelections[$currentIndex]
    if ($selected -and -not $AnswerFirstAt[$currentIndex].HasValue) {
        $AnswerFirstAt[$currentIndex] = Get-Date
    }
    if ($prior -ne $selected -and $prior -ne $null -and $selected -ne $null) {
        $AnswerChangeCount[$currentIndex] = $AnswerChangeCount[$currentIndex] + 1
    }
    $userSelections[$currentIndex] = $selected
}

foreach ($rb in $radioButtons) { $rb.Add_CheckedChanged({ Capture-Selection }) }

$btnPrev.Add_Click({
    Capture-Selection
    if ($currentIndex -gt 0) { $currentIndex--; Load-Question -index $currentIndex }
})
$btnNext.Add_Click({
    Capture-Selection
    if ($currentIndex -lt ($Questions.Count - 1)) { $currentIndex++; Load-Question -index $currentIndex }
})

$form.Add_Shown({
    $Stopwatch.Restart()
    $QuizStartTime = Get-Date
    $QuestionEnterAt[0] = $QuizStartTime
    Load-Question -index 0
})

$CooldownTimer.Add_Tick({
    if ($CooldownRemaining -le 0) {
        $CooldownTimer.Stop()
        $lblCooldown.Text = ""
        Reset-Quiz
    } else {
        $lblCooldown.Text = "Retry unlocks in $CooldownRemaining seconds…"
        $CooldownRemaining--
    }
})

$btnSubmit.Add_Click({
    Capture-Selection

    # Accumulate time for the current question
    $now = Get-Date
    if ($QuestionEnterAt[$currentIndex] -ne [datetime]::MinValue) {
        $QuestionTimeSpent[$currentIndex] = $QuestionTimeSpent[$currentIndex] + ($now - $QuestionEnterAt[$currentIndex])
    }

    # Validate completeness
    $unanswered = @()
    for ($i = 0; $i -lt $Questions.Count; $i++) { if (-not $userSelections[$i]) { $unanswered += ($i + 1) } }
    if ($unanswered.Count -gt 0) {
        [System.Windows.Forms.MessageBox]::Show("Please answer all questions.`nUnanswered : " + ($unanswered -join ", "), "Hold your horses") | Out-Null
        return
    }

    # Score attempt
    $AttemptNumber++
    $answerLetters = Get-DecodedAnswers -Blob $ObfuscatedAnswers -Key $AnswerKeyXor
    $correct = 0
    $feedback = New-Object System.Text.StringBuilder
    for ($i = 0; $i -lt $Questions.Count; $i++) {
        $u = $userSelections[$i]
        $c = $answerLetters[$i]
        if ($u -eq $c) { $correct++ } else { [void]$feedback.AppendLine("Q$($i+1) : You answered $u — correct is $c") }
    }

    # Stop timing
    $Stopwatch.Stop()
    $QuizEndTime = Get-Date
    $elapsed = $Stopwatch.Elapsed
    $elapsedHuman = Format-TimeSpan $elapsed
    $elapsedSeconds = [math]::Round($elapsed.TotalSeconds, 3)
    $lblStatus.Text = "Score : $correct / $($Questions.Count) | Time : $elapsedHuman | Attempt : $AttemptNumber"

    # Perfect? reveal; else start cooldown & lock UI
    if ($correct -eq $Questions.Count) {
        $plainKey = $answerLetters
        $binary = To-BinaryString $plainKey
        $b64 = To-Base64 $plainKey
        [System.Windows.Forms.MessageBox]::Show("Perfect! Answers revealed.", "Results") | Out-Null
        $btnReveal.Enabled = $true
        [System.Windows.Forms.MessageBox]::Show("Plain key: $plainKey`nBase64: $b64`nBinary: $binary`nTime: $elapsedHuman ($elapsedSeconds s)`nAttempt: $AttemptNumber", "Perfect Score — Answers")
    } else {
        $msg = "You scored $correct / $($Questions.Count) in $elapsedHuman (Attempt $AttemptNumber).`nAnswers remain hidden. Retry after cooldown?"
        $res = [System.Windows.Forms.MessageBox]::Show($msg, "Try again?", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question)
        if ($res -eq [System.Windows.Forms.DialogResult]::Yes) {
            Disable-Navigation
            $CooldownRemaining = [math]::Max(0, $RetryCooldownSeconds)
            $lblCooldown.Text = "Retry unlocks in $CooldownRemaining seconds…"
            $CooldownRemaining--
            $CooldownTimer.Start()
        }
    }

    # Always log attempt
    try {
        $plainKey = $answerLetters
        $b64Key = To-Base64 $plainKey
        $binKey = To-BinaryString $plainKey
        $sha256 = Compute-SHA256Hex $plainKey

        $header = @(
            "===== Attempt $AttemptNumber =====",
            "Session Start : $($QuizStartTime)",
            "Session End   : $($QuizEndTime)",
            "Duration      : $elapsedHuman ($elapsedSeconds seconds)",
            "User          : $($env:USERNAME)",
            "Computer      : $($env:COMPUTERNAME)",
            "Score         : $correct / $($Questions.Count)",
            "EncodedKeyBase64 : $b64Key",
            "EncodedKeyBinary : $binKey",
            "PlainKeySHA256   : $sha256",
            ""
        )

        $perQ = for ($i = 0; $i -lt $Questions.Count; $i++) {
            $u = $userSelections[$i]
            $c = $answerLetters[$i]
            $isCorrect = if ($u -eq $c) { "Correct" } else { "Wrong" }
            $dwell = $QuestionTimeSpent[$i]
            $dwellFmt = Format-TimeSpan $dwell
            $firstAns = if ($AnswerFirstAt[$i].HasValue) { $AnswerFirstAt[$i].Value } else { "<none>" }
            $changes = $AnswerChangeCount[$i]
            "Q$($i+1) : You=$u | Correct=$c | $isCorrect | Dwell=$dwellFmt | FirstAnswerAt=$firstAns | Changes=$changes"
        }

        $susNote = ""
        if ($elapsed.TotalSeconds -lt 20 -and $correct -ge 9) { $susNote = "FLAG : Completion under 20s with high score. Consider side-eye." }

        $footer = @("", $susNote, "")

        $toWrite = @()
        $toWrite += $header
        $toWrite += $perQ
        $toWrite += $footer

        $toWrite | Out-File -FilePath $LogPath -Encoding UTF8 -Append
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Could not write log file : $LogPath`nError : $_", "Logging Error") | Out-Null
    }
})

$btnReveal.Add_Click({
    if (-not $btnReveal.Enabled) { return }
    $plainKey = Get-DecodedAnswers -Blob $ObfuscatedAnswers -Key $AnswerKeyXor
    $b64 = To-Base64 $plainKey
    $binary = To-BinaryString $plainKey
    [System.Windows.Forms.MessageBox]::Show("Plain key: $plainKey`nBase64: $b64`nBinary: $binary", "Answer Key") | Out-Null
})

# Show the form
[void]$form.ShowDialog()

# ---------------------------
# Usage examples (commented)
# . .\Quiz-Engine.ps1 -QuestionSetPath ".\questions-easy.ps1" -RetryCooldownSeconds 10
# . .\Quiz-Engine.ps1 -QuestionSetPath ".\questions-medium.ps1" -RetryCooldownSeconds 15
# ---------------------------
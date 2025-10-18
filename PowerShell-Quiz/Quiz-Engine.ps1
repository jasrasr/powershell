# Revision : 1.8
# Description : Quiz-Engine.ps1 — PS7+ compatibility hotfix, shuffle-by-default, cooldown + logging (Rev 1.8)
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-10-17
# Modified Date : 2025-10-17

<#
  File     : Quiz-Engine.ps1
  Purpose  : Reusable PowerShell Quiz Engine (WinForms) with automatic question shuffling per attempt.
  Notes    : - Loads question set via -QuestionSetPath (dot-sourced)
             - Automatically shuffles question order at load and on every reset
             - Answers remain XOR-obfuscated in the question set files
             - Reveals plaintext answers ONLY when score == 100%
             - If <100%, offers Restart with forced cooldown and logs attempts
#>

param(
    [Parameter(Mandatory)]
    [string] $QuestionSetPath,                 # path to a question set file (dot-source)
    [int] $RetryCooldownSeconds = 10           # forced cooldown before retry (seconds)
)

# ---------------------------
# Load Question Set (dot-source)
# ---------------------------
if (-not (Test-Path -LiteralPath $QuestionSetPath)) {
    throw "Question set not found at path: $QuestionSetPath"
}
. $QuestionSetPath

# Validate required variables
if (-not $Questions -or -not $ObfuscatedAnswers -or -not $AnswerKeyXor) {
    throw "Question set must define `$Questions (array), `$ObfuscatedAnswers ([byte[]]) and `$AnswerKeyXor."
}

# ---------------------------
# Helpers: decode / encoders / hash (PS7-safe)
# ---------------------------
function Get-DecodedAnswers {
    param([byte[]] $Blob, [byte] $Key)
    ($Blob | ForEach-Object { [char]($_ -bxor $Key) }) -join ''
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
# Shuffle helper (always used)
# ---------------------------
function Invoke-QuestionShuffle {
    param(
        [Parameter(Mandatory=$true)][object[]] $Qs,
        [Parameter(Mandatory=$true)][byte[]] $Obf
    )

    $indices = 0..($Qs.Count - 1)
    $perm = Get-Random -InputObject $indices -Count $indices.Count

    $newQs = @()
    $newObf = New-Object byte[] ($Obf.Length)
    for ($i = 0; $i -lt $perm.Count; $i++) {
        $srcIndex = $perm[$i]
        $newQs += $Qs[$srcIndex]
        $newObf[$i] = $Obf[$srcIndex]
    }
    return ,($newQs, $newObf)
}

# Always shuffle at initial load so the first attempt is randomized
$shRes = Invoke-QuestionShuffle -Qs $Questions -Obf $ObfuscatedAnswers
$Questions = $shRes[0]
$ObfuscatedAnswers = $shRes[1]

# ---------------------------
# Imports / UI types
# ---------------------------
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Security

# ---------------------------
# Logging / Session variables
# ---------------------------
$LogRoot = 'C:\temp\powershell-exports'
if (-not (Test-Path $LogRoot)) { New-Item -Path $LogRoot -ItemType Directory -Force | Out-Null }
$SessionStamp = (Get-Date -Format 'yyyyMMdd-HHmmss')
$LogPath = Join-Path $LogRoot "powershell-quiz-$SessionStamp.log"

$AttemptNumber = 0

# ---------------------------
# Timing / Tracking arrays (init sized to questions count)
# * PS7 fix: use [datetime] instead of Nullable[datetime]
# ---------------------------
$Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$QuizStartTime = $null
$QuizEndTime = $null

$QuestionEnterAt      = New-Object 'System.Collections.Generic.List[datetime]'
$QuestionTimeSpent    = New-Object 'System.Collections.Generic.List[TimeSpan]'
$AnswerFirstAt        = New-Object 'System.Collections.Generic.List[datetime]'  # PS7-safe
$AnswerChangeCount    = New-Object 'System.Collections.Generic.List[int]'
1..$Questions.Count | ForEach-Object {
    [void]$QuestionEnterAt.Add([datetime]::MinValue)
    [void]$QuestionTimeSpent.Add([TimeSpan]::Zero)
    [void]$AnswerFirstAt.Add([datetime]::MinValue)
    [void]$AnswerChangeCount.Add(0)
}

# ---------------------------
# UI Build (PS7-safe ::new() constructors)
# ---------------------------
$form = New-Object System.Windows.Forms.Form
$form.Text = "PowerShell Quiz"
$form.Size = [System.Drawing.Size]::new(720, 560)
$form.StartPosition = "CenterScreen"

$lblQuestionNum = New-Object System.Windows.Forms.Label
$lblQuestionNum.Location = [System.Drawing.Point]::new(20, 15)
$lblQuestionNum.Size = [System.Drawing.Size]::new(300, 20)
$form.Controls.Add($lblQuestionNum)

$txtQuestion = New-Object System.Windows.Forms.Label
$txtQuestion.Location = [System.Drawing.Point]::new(20, 45)
$txtQuestion.Size = [System.Drawing.Size]::new(660, 40)
$txtQuestion.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($txtQuestion)

$grpAnswers = New-Object System.Windows.Forms.GroupBox
$grpAnswers.Location = [System.Drawing.Point]::new(20, 95)
$grpAnswers.Size = [System.Drawing.Size]::new(660, 200)
$grpAnswers.Text = "Choose one:"
$form.Controls.Add($grpAnswers)

$radioButtons = @()
for ($i = 0; $i -lt 4; $i++) {
    $rb = New-Object System.Windows.Forms.RadioButton
    $rb.Location = [System.Drawing.Point]::new(15, (30 + ($i * 35)))
    $rb.Size = [System.Drawing.Size]::new(620, 30)
    $grpAnswers.Controls.Add($rb)
    $radioButtons += $rb
}

$btnPrev = New-Object System.Windows.Forms.Button
$btnPrev.Location = [System.Drawing.Point]::new(20, 310)
$btnPrev.Size = [System.Drawing.Size]::new(90, 35)
$btnPrev.Text = "Previous"
$form.Controls.Add($btnPrev)

$btnNext = New-Object System.Windows.Forms.Button
$btnNext.Location = [System.Drawing.Point]::new(120, 310)
$btnNext.Size = [System.Drawing.Size]::new(90, 35)
$btnNext.Text = "Next"
$form.Controls.Add($btnNext)

$btnSubmit = New-Object System.Windows.Forms.Button
$btnSubmit.Location = [System.Drawing.Point]::new(230, 310)
$btnSubmit.Size = [System.Drawing.Size]::new(90, 35)
$btnSubmit.Text = "Submit"
$form.Controls.Add($btnSubmit)

$btnReveal = New-Object System.Windows.Forms.Button
$btnReveal.Location = [System.Drawing.Point]::new(330, 310)
$btnReveal.Size = [System.Drawing.Size]::new(120, 35)
$btnReveal.Text = "Reveal Answers"
$btnReveal.Enabled = $false
$form.Controls.Add($btnReveal)

$lblStatus = New-Object System.Windows.Forms.Label
$lblStatus.Location = [System.Drawing.Point]::new(20, 360)
$lblStatus.Size = [System.Drawing.Size]::new(660, 40)
$lblStatus.Text = "Answer all questions, then click Submit."
$form.Controls.Add($lblStatus)

$lblLegend = New-Object System.Windows.Forms.Label
$lblLegend.Location = [System.Drawing.Point]::new(20, 405)
$lblLegend.Size = [System.Drawing.Size]::new(660, 35)
$lblLegend.Text = "Perfect score reveals answers. Otherwise, retry after cooldown."
$lblLegend.ForeColor = [System.Drawing.Color]::Gray
$form.Controls.Add($lblLegend)

$lblCooldown = New-Object System.Windows.Forms.Label
$lblCooldown.Location = [System.Drawing.Point]::new(20, 445)
$lblCooldown.Size = [System.Drawing.Size]::new(660, 35)
$lblCooldown.Text = ""
$lblCooldown.ForeColor = [System.Drawing.Color]::Tomato
$form.Controls.Add($lblCooldown)

# ---------------------------
# State
# ---------------------------
$script:currentIndex = 0
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
    $btnPrev.Enabled = ($script:currentIndex -gt 0)
    $btnNext.Enabled = ($script:currentIndex -lt ($Questions.Count - 1))
    $btnSubmit.Enabled = $true
    foreach ($rb in $radioButtons) { $rb.Enabled = $true }
}

function Reset-TrackingArrays {
    $QuestionEnterAt.Clear()
    $QuestionTimeSpent.Clear()
    $AnswerFirstAt.Clear()
    $AnswerChangeCount.Clear()
    1..$Questions.Count | ForEach-Object {
        [void]$QuestionEnterAt.Add([datetime]::MinValue)
        [void]$QuestionTimeSpent.Add([TimeSpan]::Zero)
        [void]$AnswerFirstAt.Add([datetime]::MinValue)   # PS7-safe
        [void]$AnswerChangeCount.Add(0)
    }
}

function Reset-Quiz {
    # Always reshuffle on restart so each attempt is randomized
    $reshuf = Invoke-QuestionShuffle -Qs $Questions -Obf $ObfuscatedAnswers
    $Questions = $reshuf[0]
    $ObfuscatedAnswers = $reshuf[1]

    0..($Questions.Count - 1) | ForEach-Object {
        if ($userSelections.Count -le $_) { $userSelections.Add($null) } else { $userSelections[$_] = $null }
    }

    Reset-TrackingArrays

    $script:currentIndex = 0
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

    $prior = $userSelections[$script:currentIndex]
    if ($selected -and $AnswerFirstAt[$script:currentIndex] -eq [datetime]::MinValue) {
        $AnswerFirstAt[$script:currentIndex] = Get-Date
    }
    if ($prior -ne $selected -and $prior -ne $null -and $selected -ne $null) {
        $AnswerChangeCount[$script:currentIndex] = $AnswerChangeCount[$script:currentIndex] + 1
    }
    $userSelections[$script:currentIndex] = $selected
}

foreach ($rb in $radioButtons) { $rb.Add_CheckedChanged({ Capture-Selection }) }

$btnPrev.Add_Click({
    Capture-Selection
    if ($script:currentIndex -gt 0) { $script:currentIndex--; Load-Question -index $script:currentIndex }
})
$btnNext.Add_Click({
    Capture-Selection
    if ($script:currentIndex -lt ($Questions.Count - 1)) { $script:currentIndex++; Load-Question -index $script:currentIndex }
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
    if ($QuestionEnterAt[$script:currentIndex] -ne [datetime]::MinValue) {
        $QuestionTimeSpent[$script:currentIndex] = $QuestionTimeSpent[$script:currentIndex] + ($now - $QuestionEnterAt[$script:currentIndex])
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
            $firstAns = if ($AnswerFirstAt[$i] -ne [datetime]::MinValue) { $AnswerFirstAt[$i] } else { "<none>" }
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

# Show form
[void]$form.ShowDialog()

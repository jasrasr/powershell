# Revision : 1.9
# Description : Undo functionality fixed using ArrayList. Board redraws correctly. Cleaned logic.
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-07-09
# Modified Date : 2025-07-09

Clear-Host

# --- Initialize Board ---
function Initialize-Board {
    $global:Board = @{}
    $global:BigWinners = @{}
    $global:MoveHistory = [System.Collections.ArrayList]::new()
    $global:currentPlayerSymbol = "X"
    $global:FinalGameOver = $false
    $global:AutoPlay = $false

    for ($i = 1; $i -le 9; $i++) {
        $Board[$i] = @{}
        $BigWinners[$i] = " "
        for ($j = 1; $j -le 9; $j++) {
            $Board[$i][$j] = " "
        }
    }
}

Initialize-Board

# --- Win Conditions ---
$winningCombinations = @(
    @(1,2,3), @(4,5,6), @(7,8,9),
    @(1,4,7), @(2,5,8), @(3,6,9),
    @(1,5,9), @(3,5,7)
)

# --- Player Setup ---
$symbols = @("X", "O")
$players = @{}
foreach ($s in $symbols) {
    $n = Read-Host "Enter name for Player '$s'"
    $players[$s] = if ($n) { $n } else { $s }
}
$global:WinCount = @{ "X" = 0; "O" = 0 }

# --- Show Board ---
function Show-Board {
    Clear-Host
    Show-BigBoardWinners
    Write-Host "`nSUPER TIC TAC TOE ($($players.X) vs $($players.O)) (q=Quit r=Reset u=Undo)" -ForegroundColor Cyan

    $scoreboardLines = @(
        "Scoreboard",
        "$($players.X) (X) Wins: $($WinCount.X)",
        "$($players.O) (O) Wins: $($WinCount.O)"
    )

    $scoreboardLineIndex = 0
    $rowCounter = 0

    for ($bigRow = 0; $bigRow -lt 3; $bigRow++) {
        for ($smallRow = 0; $smallRow -lt 3; $smallRow++) {
            $line = ""
            for ($bigCol = 0; $bigCol -lt 3; $bigCol++) {
                $big = $bigRow * 3 + $bigCol + 1
                for ($smallCol = 0; $smallCol -lt 3; $smallCol++) {
                    $small = $smallRow * 3 + $smallCol + 1
                    $val = if ($Board[$big][$small] -eq " ") { "." } else { $Board[$big][$small] }
                    $line += " $val "
                }
                if ($bigCol -lt 2) { $line += "|" }
            }

            $line = $line.PadRight(50)

            if ($scoreboardLineIndex -lt $scoreboardLines.Count) {
                $line += $scoreboardLines[$scoreboardLineIndex]
                $scoreboardLineIndex++
            }

            Write-Host $line
            $rowCounter++
        }
        if ($bigRow -lt 2) {
            Write-Host ("-" * 33)
        }
    }
}

# --- Show 3x3 Big Board Winner Tracker ---
function Show-BigBoardWinners {
    Write-Host "`nBIG BOARD WINNERS:`n" -ForegroundColor Green
    for ($row = 0; $row -lt 3; $row++) {
        $line = ""
        for ($col = 0; $col -lt 3; $col++) {
            $index = $row * 3 + $col + 1
            $symbol = if ($BigWinners[$index] -in @("X", "O")) { $BigWinners[$index] } else { "." }
            $line += " $symbol "
        }
        Write-Host $line
    }
}

# --- Win Check ---
function Check-SmallBoardWin($big, $symbol) {
    foreach ($combo in $winningCombinations) {
        if ($Board[$big][$combo[0]] -eq $symbol -and $Board[$big][$combo[1]] -eq $symbol -and $Board[$big][$combo[2]] -eq $symbol) {
            return $true
        }
    }
    return $false
}

function Check-FullGameWin($symbol) {
    foreach ($combo in $winningCombinations) {
        if ($BigWinners[$combo[0]] -eq $symbol -and $BigWinners[$combo[1]] -eq $symbol -and $BigWinners[$combo[2]] -eq $symbol) {
            return $true
        }
    }
    return $false
}

# --- Get Random Open Move ---
function Get-RandomMove {
    param($bigRequired = $false)
    $bigList = @(1..9 | Where-Object { -not ($BigWinners[$_] -match '[XO]') })
    if ($bigRequired -and $bigList.Count -eq 0) { return $null }
    $bigMove = Get-Random -InputObject $bigList
    $smallList = @(1..9 | Where-Object { $Board[$bigMove][$_] -eq " " })
    if ($smallList.Count -eq 0) { return $null }
    $smallMove = Get-Random -InputObject $smallList
    return @{ Big = $bigMove; Small = $smallMove }
}

# --- Game Loop ---
while ($true) {
    Show-BigBoardWinners
    Show-Board
    $playerName = $players[$currentPlayerSymbol]
    Write-Host "`n$playerName's Turn ($currentPlayerSymbol) (q=Quit r=Reset u=Undo)" -ForegroundColor Yellow

    if (-not $AutoPlay) {
        do {
            $bigMove = Read-Host "Choose BIG square (1-9) or type 'test'"
            if ($bigMove -eq "q") { exit }
            if ($bigMove -eq "r") { Initialize-Board; continue }
            if ($bigMove -eq "u" -and $MoveHistory.Count -gt 0) {
                $last = $MoveHistory[$MoveHistory.Count - 1]
                $Board[$last.Big][$last.Small] = " "
                $BigWinners[$last.Big] = " "
                $MoveHistory.RemoveAt($MoveHistory.Count - 1)
                $currentPlayerSymbol = $last.Symbol
                Show-BigBoardWinners; Show-Board
                continue
            }
            if ($bigMove -eq "test") { $AutoPlay = $true; break }
        } until ($bigMove -match '^[1-9]$')
        if (-not $AutoPlay) { $bigMove = [int]$bigMove }
    }

    if ($AutoPlay) {
        $move = Get-RandomMove -bigRequired:$false
        if ($null -eq $move) { break }
        $bigMove = $move.Big
        $smallMove = $move.Small
        Start-Sleep -Milliseconds 300
    } else {
        do {
            $smallMove = Read-Host "Choose SMALL square (1-9)"
            if ($smallMove -eq "q") { exit }
            if ($smallMove -eq "r") { Initialize-Board; continue }
            if ($smallMove -eq "u" -and $MoveHistory.Count -gt 0) {
                $last = $MoveHistory[$MoveHistory.Count - 1]
                $Board[$last.Big][$last.Small] = " "
                $BigWinners[$last.Big] = " "
                $MoveHistory.RemoveAt($MoveHistory.Count - 1)
                $currentPlayerSymbol = $last.Symbol
                Show-BigBoardWinners; Show-Board
                continue
            }
        } until ($smallMove -match '^[1-9]$')
        $smallMove = [int]$smallMove
    }

    if ($Board[$bigMove][$smallMove] -ne " ") {
        if (-not $AutoPlay) {
            Write-Host "Spot already taken!" -ForegroundColor Red
            Start-Sleep -Milliseconds 1000
        }
        continue
    }

    $Board[$bigMove][$smallMove] = $currentPlayerSymbol
    $null = $MoveHistory.Add([pscustomobject]@{
        Big = $bigMove
        Small = $smallMove
        Symbol = $currentPlayerSymbol
    })

    if ($BigWinners[$bigMove] -eq " " -and (Check-SmallBoardWin $bigMove $currentPlayerSymbol)) {
        $BigWinners[$bigMove] = $currentPlayerSymbol
        if (Check-FullGameWin $currentPlayerSymbol) {
            $FinalGameOver = $true
            Write-Host "`n🎉🎉🎉 $($players[$currentPlayerSymbol]) wins the GAME! 🎉🎉🎉" -ForegroundColor Magenta
            $WinCount[$currentPlayerSymbol]++
            $playAgain = Read-Host "`nPlay again? (y/n)"
            if ($playAgain -match '^(y|Y)$') {
                Initialize-Board
                continue
            } else {
                break
            }
        }
    }

    $currentPlayerSymbol = if ($currentPlayerSymbol -eq "X") { "O" } else { "X" }
}

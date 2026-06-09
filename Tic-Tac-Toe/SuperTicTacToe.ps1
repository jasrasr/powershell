# test winning combo
<#
1,1
2,1
1,2
2,2
1,3
2,3s
4,1
5,1
4,2
5,2
4,3
5,3
7,1
8,1
7,2
8,2
7,3
#>

# Revision : 2.3
# Description : Undo functionality fixed using ArrayList. Board redraws correctly. Cleaned logic.
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-07-09
# Modified Date : 2025-11-15

# rev 1.9.1 - fix powershell 5 compatibility on win detection of major version
# rev 1.9.2 - added AutoPlay stop on key press and draw detection
# rev 1.9.3 - fixed error when no moves left in AutoPlay mode
# rev 1.9.4 - fix u and r commands to work correctly
# rev 1.9.5 - added confirmation prompt for reset commands
# rev 2.0 - add play log
# rev 2.0.1 - update play log to last 10 moves instead of 5
# rev 2.0.2 - update log from B1 S1 to (B,S) and Last moves header
# rev 2.1 - add guide next to big board winner display
# rev 2.1.1 - fixes play again
# rev 2.1.2 - fixes auto after play again yes
# rev 2.2 - add rev to top of game play
# rev 2.3 - fixed variable scope bug: $FinalGameOver, $AutoPlay, $TestMode needed $global: prefix



# --- CONFIG ---
$ShowRevision = $true  # Set to $false to hide revision info
$GameRevision = "2.3"

Clear-Host

# --- Initialize Board ---
function Initialize-Board {
    $global:Board = @{}
    $global:BigWinners = @{}
    $global:MoveHistory = [System.Collections.ArrayList]::new()
    $global:currentPlayerSymbol = "X"
    $global:FinalGameOver = $false
    $global:AutoPlay = $false
    $global:TestMode = $false
    $global:TestMoves = @()
    $global:TestMoveIndex = 0

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
    if ($ShowRevision) {
        Write-Host "`nSUPER TIC TAC TOE ($($players.X) vs $($players.O)) (q=Quit r=Reset u=Undo) [v$GameRevision]" -ForegroundColor Cyan
    } else {
        Write-Host "`nSUPER TIC TAC TOE ($($players.X) vs $($players.O)) (q=Quit r=Reset u=Undo)" -ForegroundColor Cyan
    }

    $scoreboardLines = @(
        "Scoreboard",
        "$($players.X) (X) Wins: $($WinCount.X)",
        "$($players.O) (O) Wins: $($WinCount.O)",
        "",
        "Last Moves: (Big,Small)"
    )
    
    # Add last 10 moves to scoreboard
    $recentMoves = $MoveHistory | Select-Object -Last 10
    foreach ($move in $recentMoves) {
        $playerName = $players[$move.Symbol]
        $scoreboardLines += "$playerName ($($move.Symbol)): ($($move.Big),$($move.Small))"
    }

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
            Write-Host ("-" * 33).PadRight(50) -NoNewline
            if ($scoreboardLineIndex -lt $scoreboardLines.Count) {
                Write-Host $scoreboardLines[$scoreboardLineIndex]
                $scoreboardLineIndex++
            } else {
                Write-Host ""
            }
        }
    }
    
    # Print remaining scoreboard lines after the board
    while ($scoreboardLineIndex -lt $scoreboardLines.Count) {
        Write-Host (" " * 50) -NoNewline
        Write-Host $scoreboardLines[$scoreboardLineIndex]
        $scoreboardLineIndex++
    }
}

# --- Show 3x3 Big Board Winner Tracker ---
function Show-BigBoardWinners {
    Write-Host "`nBIG BOARD WINNERS:`n" -ForegroundColor Green
    
    $guideLines = @(
        "+---+---+---+",
        "| 1 | 2 | 3 |",
        "+---+---+---+",
        "| 4 | 5 | 6 |",
        "+---+---+---+",
        "| 7 | 8 | 9 |",
        "+---+---+---+"
    )
    
    for ($row = 0; $row -lt 3; $row++) {
        $line = ""
        for ($col = 0; $col -lt 3; $col++) {
            $index = $row * 3 + $col + 1
            $symbol = if ($BigWinners[$index] -in @("X", "O")) { $BigWinners[$index] } else { "." }
            $line += " $symbol "
        }
        
        # Pad and add guide on the right
        $line = $line.PadRight(20)
        if ($row -eq 0) {
            $line += "Grid Guide:  " + $guideLines[0]
        } elseif ($row -eq 1) {
            $line += "             " + $guideLines[1]
        } elseif ($row -eq 2) {
            $line += "             " + $guideLines[2]
        }
        Write-Host $line
    }
    
    # Print remaining guide lines
    Write-Host (" " * 20) -NoNewline
    Write-Host "             $($guideLines[3])"
    Write-Host (" " * 20) -NoNewline
    Write-Host "             $($guideLines[4])"
    Write-Host (" " * 20) -NoNewline
    Write-Host "             $($guideLines[5])"
    Write-Host (" " * 20) -NoNewline
    Write-Host "             $($guideLines[6])"
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
    if ($bigList.Count -eq 0) { return $null }
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
    if ($AutoPlay) {
        Write-Host "(Press any key to stop AutoPlay)" -ForegroundColor DarkGray
    }
    if ($TestMode) {
        Write-Host "(Running test sequence...)" -ForegroundColor DarkGray
    }

    if (-not $AutoPlay -and -not $TestMode) {
        do {
            $bigMove = Read-Host "Choose BIG square (1-9) or type 'auto' or 'test'"
            if ($bigMove -eq "q") { exit }
            if ($bigMove -eq "r") { 
                $confirm = Read-Host "Reset game? All progress will be lost. (y/n)"
                if ($confirm -match '^(y|Y)$') {
                    Initialize-Board
                    Show-BigBoardWinners
                    Show-Board
                }
                continue 
            }
            if ($bigMove -eq "u" -and $MoveHistory.Count -gt 0) {
                $last = $MoveHistory[$MoveHistory.Count - 1]
                $Board[$last.Big][$last.Small] = " "
                $BigWinners[$last.Big] = " "
                $MoveHistory.RemoveAt($MoveHistory.Count - 1)
                $currentPlayerSymbol = $last.Symbol
                Show-BigBoardWinners
                Show-Board
                continue
            }
            if ($bigMove -eq "auto") { 
                $global:AutoPlay = $true
                break 
            }
            if ($bigMove -eq "test") { 
                $global:TestMode = $true
                $TestMoves = @(
                    @{Big=1;Small=1}, @{Big=2;Small=1}, @{Big=1;Small=2}, @{Big=2;Small=2},
                    @{Big=1;Small=3}, @{Big=2;Small=3}, @{Big=4;Small=1}, @{Big=5;Small=1},
                    @{Big=4;Small=2}, @{Big=5;Small=2}, @{Big=4;Small=3}, @{Big=5;Small=3},
                    @{Big=7;Small=1}, @{Big=8;Small=1}, @{Big=7;Small=2}, @{Big=8;Small=2},
                    @{Big=7;Small=3}
                )
                $TestMoveIndex = 0
                break 
            }
        } until ($bigMove -match '^[1-9]$')
        if ($AutoPlay -or $TestMode) { 
            continue 
        }
        if (-not $AutoPlay -and -not $TestMode) { $bigMove = [int]$bigMove }
    }

    if ($TestMode) {
        # Use predefined test moves
        if ($TestMoveIndex -lt $TestMoves.Count) {
            $move = $TestMoves[$TestMoveIndex]
            $bigMove = $move.Big
            $smallMove = $move.Small
            $TestMoveIndex++
            Start-Sleep -Milliseconds 300
        } else {
            # Test sequence complete - switch back to manual mode
            $global:TestMode = $false
            continue
        }
    } elseif ($AutoPlay) {
        # Check if user pressed a key to stop AutoPlay
        if ([Console]::KeyAvailable) {
            $key = [Console]::ReadKey($true)
            $global:AutoPlay = $false
            Write-Host "`nAutoPlay stopped by user. Continue playing manually..." -ForegroundColor Yellow
            Start-Sleep -Milliseconds 1000
            continue
        }
        
        # Check if game is already won
        if ($FinalGameOver) { 
            $global:AutoPlay = $false
            continue
        }
        
        $move = Get-RandomMove -bigRequired:$false
        if ($null -eq $move) { 
            Write-Host "`nNo more moves available. Game ends in a draw!" -ForegroundColor Yellow
            Start-Sleep -Seconds 2
            $global:AutoPlay = $false
            $playAgain = Read-Host "`nPlay again? (y/n)"
            if ($playAgain -match '^(y|Y)$') {
                Initialize-Board
                Show-BigBoardWinners
                Show-Board
                continue
            } else {
                Write-Host "`nThanks for playing!" -ForegroundColor Cyan
                exit
            }
        }
        $bigMove = $move.Big
        $smallMove = $move.Small
        Start-Sleep -Milliseconds 300
    } else {
        do {
            $smallMove = Read-Host "Choose SMALL square (1-9)"
            if ($smallMove -eq "q") { exit }
            if ($smallMove -eq "r") { 
                $confirm = Read-Host "Reset game? All progress will be lost. (y/n)"
                if ($confirm -match '^(y|Y)$') {
                    Initialize-Board
                    Show-BigBoardWinners
                    Show-Board
                }
                continue 
            }
            if ($smallMove -eq "u" -and $MoveHistory.Count -gt 0) {
                $last = $MoveHistory[$MoveHistory.Count - 1]
                $Board[$last.Big][$last.Small] = " "
                $BigWinners[$last.Big] = " "
                $MoveHistory.RemoveAt($MoveHistory.Count - 1)
                $currentPlayerSymbol = $last.Symbol
                Show-BigBoardWinners
                Show-Board
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
            $global:FinalGameOver = $true
            Show-BigBoardWinners
            Show-Board
            if ($PSVersionTable.PSVersion.Major -ge 7) {
                Write-Host "`n🎉🎉🎉 $($players[$currentPlayerSymbol]) wins the GAME! 🎉🎉🎉" -ForegroundColor Magenta
            } else {
                Write-Host "`n*** $($players[$currentPlayerSymbol]) wins the GAME! ***" -ForegroundColor Magenta
            }
            $WinCount[$currentPlayerSymbol]++
            $playAgain = Read-Host "`nPlay again? (y/n)"
            if ($playAgain -match '^(y|Y)$') {
                Initialize-Board
                Show-BigBoardWinners
                Show-Board
                continue
            } else {
                Write-Host "`nThanks for playing!" -ForegroundColor Cyan
                exit
            }
        }
    }

    $currentPlayerSymbol = if ($currentPlayerSymbol -eq "X") { "O" } else { "X" }
}

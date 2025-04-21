 <#
Super Tic Tac Toe (Ultimate Tic Tac Toe) - PowerShell Edition
Version: Rev4.1
By: ChatGPT + User collaboration
Features:
- 9x9 Board
- X and O take turns
- Win detection on small boards
- Lockout of won small boards
- Full game win detection (3 Big Squares in a row)
- Quit (q), Reset (r), Undo Last Move (u)
- Stable input handling
"u" is not working, need troubleshooting, moving to new rev file
#>

Clear-Host

# --- Initialize Board Function ---
function Initialize-Board {
    $global:Board = @{}
    $global:BigWinners = @{}
    $global:MoveHistory = @()

    for ($big = 1; $big -le 9; $big++) {
        $Board[$big] = @{}
        $BigWinners[$big] = " "
        for ($small = 1; $small -le 9; $small++) {
            $Board[$big][$small] = " "
        }
    }
    $global:currentPlayer = 0
}

Initialize-Board

# --- Winning Combinations ---
$winningCombinations = @(
    @(1, 2, 3),
    @(4, 5, 6),
    @(7, 8, 9),
    @(1, 4, 7),
    @(2, 5, 8),
    @(3, 6, 9),
    @(1, 5, 9),
    @(3, 5, 7)
)

# --- Player Setup ---
$players = @("X", "O")

# --- Function: Show Board ---
function Show-Board {
    Clear-Host
    Write-Host "`nSUPER TIC TAC TOE (X vs O)   (q=Quit  r=Reset  u=Undo)" -ForegroundColor Cyan
    for ($bigRow = 0; $bigRow -lt 3; $bigRow++) {
        for ($smallRow = 0; $smallRow -lt 3; $smallRow++) {
            $line = ""
            for ($bigCol = 0; $bigCol -lt 3; $bigCol++) {
                $bigIndex = ($bigRow * 3) + $bigCol + 1
                for ($smallCol = 0; $smallCol -lt 3; $smallCol++) {
                    $smallIndex = ($smallRow * 3) + $smallCol + 1
                    $value = $Board[$bigIndex][$smallIndex]
                    if ($value -eq " ") { $value = "." }
                    $line += " $value "
                }
                $line += " | "
            }
            Write-Host $line
        }
        Write-Host ("-" * 36)
    }

    Write-Host "`nBig Board Wins:"
    for ($i = 1; $i -le 9; $i++) {
        $status = if ($BigWinners[$i] -ne " ") { $BigWinners[$i] } else { "." }
        Write-Host -NoNewline " $status "
        if ($i % 3 -eq 0) { Write-Host "" }
    }
}

# --- Function: Check Small Board Win ---
function Check-SmallBoardWin {
    param (
        [int]$bigSquare,
        [string]$player
    )

    foreach ($combo in $winningCombinations) {
        if (
            $Board[$bigSquare][$combo[0]] -eq $player -and
            $Board[$bigSquare][$combo[1]] -eq $player -and
            $Board[$bigSquare][$combo[2]] -eq $player
        ) {
            return $true
        }
    }
    return $false
}

# --- Function: Check Full Game Win ---
function Check-FullGameWin {
    param (
        [string]$player
    )

    foreach ($combo in $winningCombinations) {
        if (
            $BigWinners[$combo[0]] -eq $player -and
            $BigWinners[$combo[1]] -eq $player -and
            $BigWinners[$combo[2]] -eq $player
        ) {
            return $true
        }
    }
    return $false
}

# --- Function: Get Move Input (Handles q, r, u) ---
function Get-MoveInput {
    param(
        [string]$prompt
    )

    while ($true) {
        $input = Read-Host $prompt

        switch ($input.ToLower()) {
            "q" { 
                Write-Host "`nQuitting the game. Goodbye!" -ForegroundColor Magenta
                exit
            }
            "r" {
                Write-Host "`nResetting the board..." -ForegroundColor Green
                Start-Sleep -Milliseconds 800
                Initialize-Board
                Show-Board
                continue
            }
"u" {
    if ($MoveHistory.Count -eq 0) {
        Write-Host "`nNo moves to undo!" -ForegroundColor Red
        Start-Sleep -Milliseconds 1000
        Show-Board
        continue
    }
    $lastIndex = $MoveHistory.Count - 1
    $lastMove = $MoveHistory[$lastIndex]
    
    # Clear the last move spot
    $Board[$lastMove.Big][$lastMove.Small] = " "
    
    # Clear big winner if needed
    if ($BigWinners[$lastMove.Big] -eq $players[$lastMove.PlayerIndex]) {
        $BigWinners[$lastMove.Big] = " "
    }
    
    # Remove last move cleanly
    $MoveHistory.RemoveAt($lastIndex)
    
    # Set player back
    $global:currentPlayer = $lastMove.PlayerIndex
    
    Write-Host "`nLast move undone." -ForegroundColor Green
    Start-Sleep -Milliseconds 800
    Show-Board
    continue
}    

            {$_ -match '^[1-9]$'} {
                return [int]$input
            }
            default {
                Write-Host "Invalid input. Enter 1-9, or 'q', 'r', or 'u'." -ForegroundColor Red
            }
        }
    }
}

# --- Main Game Loop ---
while ($true) {
    Show-Board

    $player = $players[$currentPlayer]
    Write-Host "`n$player's Turn (q=Quit r=Reset u=Undo)" -ForegroundColor Yellow

    $bigMove = Get-MoveInput -prompt "Choose BIG square (1-9)"
    $smallMove = Get-MoveInput -prompt "Choose SMALL square (1-9)"

    # Check if Big Square already won
    if ($BigWinners[$bigMove] -ne " ") {
        Write-Host "`nBIG Square $bigMove already won by $($BigWinners[$bigMove])! Choose another big square." -ForegroundColor Red
        Read-Host "Press Enter to try again"
        continue
    }

    # Check if Small Square already taken
    if ($Board[$bigMove][$smallMove] -ne " ") {
        Write-Host "`nSpot already taken! Press Enter to try again." -ForegroundColor Red
        Read-Host
        continue
    }

    # Place the move
    $Board[$bigMove][$smallMove] = $player

    # Record move for undo
    $MoveHistory += [pscustomobject]@{
        Big = $bigMove
        Small = $smallMove
        PlayerIndex = $currentPlayer
    }

    # Check if small board is won
    if ($BigWinners[$bigMove] -eq " ") {
        if (Check-SmallBoardWin -bigSquare $bigMove -player $player) {
            $BigWinners[$bigMove] = $player
            Write-Host "`n$player wins BIG square $bigMove!" -ForegroundColor Green
            Start-Sleep -Seconds 2

            # Check for full game win
            if (Check-FullGameWin -player $player) {
                Show-Board
                Write-Host "`n🎉🎉 $player wins the WHOLE GAME! 🎉🎉" -ForegroundColor Magenta
                break
            }
        }
    }

    # Switch player
    $currentPlayer = ($currentPlayer + 1) % 2
}

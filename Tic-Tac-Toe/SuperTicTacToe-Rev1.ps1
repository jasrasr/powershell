<#
Super Tic Tac Toe (Ultimate Tic Tac Toe) - PowerShell Edition
Version: Rev3
By: ChatGPT + User collaboration
Features:
- 9x9 Board
- X and O take turns
- Win detection on small boards
- Lockout of won small boards
- Full game win detection (3 Big Squares in a row)
- Simple Console UI
#>

Clear-Host

# --- Initialize Board ---
$Board = @{}
$BigWinners = @{}  # Track who wins each big square

for ($big = 1; $big -le 9; $big++) {
    $Board[$big] = @{}
    $BigWinners[$big] = " "  # Initialize as empty (no winner)
    for ($small = 1; $small -le 9; $small++) {
        $Board[$big][$small] = " "  # Initialize small squares
    }
}

# --- Winning Combinations (Rows, Columns, Diagonals) ---
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
$currentPlayer = 0

# --- Function: Show Board ---
function Show-Board {
    Clear-Host
    Write-Host "`nSUPER TIC TAC TOE (X vs O)" -ForegroundColor Cyan
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

# --- Main Game Loop ---
while ($true) {
    Show-Board

    $player = $players[$currentPlayer]
    Write-Host "`n$player's Turn" -ForegroundColor Yellow

    # Get move input
    do {
        $bigMoveRaw = Read-Host "Choose BIG square (1-9)"
    } until ($bigMoveRaw -match '^[1-9]$')

    do {
        $smallMoveRaw = Read-Host "Choose SMALL square (1-9)"
    } until ($smallMoveRaw -match '^[1-9]$')

    $bigMove = [int]$bigMoveRaw
    $smallMove = [int]$smallMoveRaw

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

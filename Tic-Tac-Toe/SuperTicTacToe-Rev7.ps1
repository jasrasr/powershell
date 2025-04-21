<#

Rev 7
need to update winning calculation

#>
Clear-Host

# --- Initialize Board ---
function Initialize-Board {
    $global:Board = @{}
    $global:BigWinners = @{}
    $global:MoveHistory = @()
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
$global:WinCount = @{ "X"=0; "O"=0 }

# --- Show Board with Side Scoreboard ---
function Show-Board {
    Clear-Host
    Write-Host "`nSUPER TIC TAC TOE ($($players.X) vs $($players.O)) (q=Quit r=Reset u=Undo)" -ForegroundColor Cyan

    if ($FinalGameOver) {
        $scoreboardLines = @(
            "FINAL SCOREBOARD",
            "$($players.X) (X) Wins: $($WinCount.X)",
            "$($players.O) (O) Wins: $($WinCount.O)"
        )
    }
    else {
        $scoreboardLines = @(
            "Scoreboard",
            "$($players.X) (X) Wins: $($WinCount.X)",
            "$($players.O) (O) Wins: $($WinCount.O)"
        )
    }

    $scoreboardLineIndex = 0
    $scoreboardStartRow = 1
    $rowCounter = 0

    for ($bigRow=0; $bigRow -lt 3; $bigRow++) {
        for ($smallRow=0; $smallRow -lt 3; $smallRow++) {
            $line = ""
            for ($bigCol=0; $bigCol -lt 3; $bigCol++) {
                $big = $bigRow*3 + $bigCol + 1
                for ($smallCol=0; $smallCol -lt 3; $smallCol++) {
                    $small = $smallRow*3 + $smallCol + 1
                    $val = if ($Board[$big][$small] -eq " ") { "." } else { $Board[$big][$small] }
                    $line += " $val "
                }
                if ($bigCol -lt 2) { $line += "|" }
            }

            $line = $line.PadRight(50)

            if ($rowCounter -ge $scoreboardStartRow -and $scoreboardLineIndex -lt $scoreboardLines.Count) {
                $line += $scoreboardLines[$scoreboardLineIndex]
                $scoreboardLineIndex++
            }

            Write-Host $line
            $rowCounter++
        }

        if ($bigRow -lt 2) {
            Write-Host ("-"*33)
            $rowCounter++
        }
    }
}

# --- Animate Expanding WINNER ---
function Animate-ExpandingWinner {
    param([string]$text = "WINNNNNNER!", [int]$delay = 200)
    for ($i = 1; $i -le $text.Length; $i++) {
        Clear-Host
        Write-Host "`n" -NoNewline
        Write-Host ($text.Substring(0, $i) -replace '(.)', '$1 ') -ForegroundColor Yellow
        Start-Sleep -Milliseconds $delay
    }
}

# --- Animate Scrolling WINNER ---
function Animate-ScrollingWinner {
    param([string]$text = "🎉 WINNNNNNER 🎉", [int]$spaces = 40, [int]$delay = 75)
    for ($i = 0; $i -le $spaces; $i++) {
        Clear-Host
        Write-Host (" " * $i) -NoNewline
        Write-Host $text -ForegroundColor Yellow
        Start-Sleep -Milliseconds $delay
    }
}

# --- Show Winner Board (Big Flashing Banner) ---
function Show-WinnerBoard {
    Clear-Host

    $bannerLines = @(
        "██╗    ██╗██╗███╗   ██╗███╗   ██╗███████╗██████╗ ",
        "██║    ██║██║████╗  ██║████╗  ██║██╔════╝██╔══██╗",
        "██║ █╗ ██║██║██╔██╗ ██║██╔██╗ ██║█████╗  ██████╔╝",
        "██║███╗██║██║██║╚██╗██║██║╚██╗██║██╔══╝  ██╔══██╗",
        "╚███╔███╔╝██║██║ ╚████║██║ ╚████║███████╗██║  ██║",
        " ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝"
    )

    $colors = @("Yellow", "Magenta", "Cyan")

    for ($flash = 0; $flash -lt 6; $flash++) {
        Clear-Host
        Write-Host "`n🎉🎉🎉 SUPER TIC TAC TOE WINNER! 🎉🎉🎉`n" -ForegroundColor Cyan

        $color = $colors[$flash % $colors.Count]
        foreach ($line in $bannerLines) {
            $chars = $line.ToCharArray() -join ' '
            $paddedLine = $chars.PadLeft( (([console]::WindowWidth / 2) + ($chars.Length / 2)) )
            Write-Host $paddedLine -ForegroundColor $color
        }

        Start-Sleep -Milliseconds 250
    }

    Write-Host "`n🎉🎉🎉 W I N N E R 🎉🎉🎉`n" -ForegroundColor Magenta
}

# --- Check for Wins ---
function Check-SmallBoardWin($big, $symbol) {
    $winningCombinations | ForEach-Object {
        if ($Board[$big][$_[0]] -eq $symbol -and $Board[$big][$_[1]] -eq $symbol -and $Board[$big][$_[2]] -eq $symbol) { return $true }
    }
    return $false
}

function Check-FullGameWin($symbol) {
    $winningCombinations | ForEach-Object {
        if ($BigWinners[$_[0]] -eq $symbol -and $BigWinners[$_[1]] -eq $symbol -and $BigWinners[$_[2]] -eq $symbol) { return $true }
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
    return @{ Big=$bigMove; Small=$smallMove }
}

# --- Main Game Loop ---
while ($true) {
    Show-Board
    $playerName = $players[$currentPlayerSymbol]
    Write-Host "`n$playerName's Turn ($currentPlayerSymbol) (q=Quit r=Reset u=Undo)" -ForegroundColor Yellow

    if (-not $AutoPlay) {
        # BIG square input
        do {
            $bigMove = Read-Host "Choose BIG square (1-9) or type 'test'"
            if ($bigMove -eq "q") { exit }
            if ($bigMove -eq "r") { Initialize-Board; continue 2 }
            if ($bigMove -eq "u" -and $MoveHistory.Count -gt 0) { 
                $last=$MoveHistory[-1]; 
                $Board[$last.Big][$last.Small]=" "; 
                $MoveHistory.RemoveAt($MoveHistory.Count-1); 
                $currentPlayerSymbol=$last.Symbol; 
                continue 2 
            }
            if ($bigMove -eq "test") {
                $AutoPlay = $true
                break
            }
        } until ($bigMove -match '^[1-9]$')
        if (-not $AutoPlay) { $bigMove = [int]$bigMove }
    }

    if ($AutoPlay) {
        $move = Get-RandomMove -bigRequired:$false
        if ($null -eq $move) { break }
        $bigMove = $move.Big
        $smallMove = $move.Small
        Start-Sleep -Milliseconds 300
    }
    else {
        # SMALL square input
        do {
            $smallMove = Read-Host "Choose SMALL square (1-9)"
            if ($smallMove -eq "q") { exit }
            if ($smallMove -eq "r") { Initialize-Board; continue 2 }
            if ($smallMove -eq "u" -and $MoveHistory.Count -gt 0) { 
                $last=$MoveHistory[-1]; 
                $Board[$last.Big][$last.Small]=" "; 
                $MoveHistory.RemoveAt($MoveHistory.Count-1); 
                $currentPlayerSymbol=$last.Symbol; 
                continue 2 
            }
        } until ($smallMove -match '^[1-9]$')
        $smallMove = [int]$smallMove
    }

    # Place move
    if ($Board[$bigMove][$smallMove] -ne " ") {
        if (-not $AutoPlay) {
            Write-Host "Spot already taken!" -ForegroundColor Red
            Start-Sleep -Milliseconds 1000
        }
        continue
    }

    $Board[$bigMove][$smallMove] = $currentPlayerSymbol
    $MoveHistory += [pscustomobject]@{Big=$bigMove; Small=$smallMove; Symbol=$currentPlayerSymbol}

    if (Check-SmallBoardWin($bigMove, $currentPlayerSymbol)) {
        $BigWinners[$bigMove] = $currentPlayerSymbol
    }

    if (Check-FullGameWin($currentPlayerSymbol)) {
        $FinalGameOver = $true
        Animate-ExpandingWinner
        Animate-ScrollingWinner
        Show-WinnerBoard
        Read-Host "`nPress Enter to continue..."
        $WinCount[$currentPlayerSymbol]++

        do {
            $playAgain = Read-Host "`nPlay again? (y/n)"
        } until ($playAgain -match '^(y|Y|n|N)$')

        if ($playAgain -match '^(y|Y)$') {
            Initialize-Board
            continue
        }
        else {
            break
        }
    }

    $currentPlayerSymbol = if ($currentPlayerSymbol -eq "X") { "O" } else { "X" }
}

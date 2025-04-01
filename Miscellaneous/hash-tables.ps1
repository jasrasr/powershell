# Create a hash table of computers
$Computers = @(
    @{ ComputerName = "CLEW10BGZ32G2"; Model = "5510"; Location = "Home" }
    @{ ComputerName = "CLEW103LMHFH2"; Model = "5520"; Location = "Office" }
    @{ ComputerName = "CLEW11DZ93HW3"; Model = "7320"; Location = "Office" }
    @{ ComputerName = "CLEW1067LLFH2"; Model = "5285"; Location = "Office" }
)

# Get current computer name
$CurrentComputer = $env:COMPUTERNAME

# Output the results
$Computers | ForEach-Object {
    $Color = if ($_.ComputerName -eq $CurrentComputer) { "Green" } else { "White" }
    Write-Host ("ComputerName: {0} | Model: {1} | Location: {2}" -f $_.ComputerName, $_.Model, $_.Location) -ForegroundColor $Color
}


$Index = $Computers.IndexOf($Computers) | Where-Object { $_.ComputerName -eq "CLEW10BGZ32G2" }
Write-Host "Index of CLEW10BGZ32G2: $Index"


$Index = $Computers.IndexOf(($Computers | Where-Object { $_.ComputerName -eq "CLEW10BGZ32G2" }))
Write-Host $Index


$Index = 0
foreach ($Computer in $Computers) {
    if ($Computer.ComputerName -eq "CLEW10BGZ32G2") {
        Write-Host "Index of CLEW10BGZ32G2: $Index"
        break
    }
    $Index++
}

$Index = $Computers | ForEach-Object -Begin {} `
    -Process { if ($_.ComputerName -eq "CLEW10BGZ32G2") { $i; break } $i++ }

Write-Host "$Index"
###


$TargetComputer = $Computers | Where-Object { $_.ComputerName -eq "CLEW10BGZ32G2" }

if ($TargetComputer) {
    Write-Host "Location: $($TargetComputer.Location)"
} else {
    Write-Host "Computer not found."
}


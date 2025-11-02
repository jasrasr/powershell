# Revision : 1.1
# Description : Get Department from AD by matching full email address (mail attribute)
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-10-31
# Modified Date : 2025-10-31

$users = @(
    "robert.bordon@middough.com",
    "donavynn.hayes@middough.com",
    "joseph.kalic@middough.com",
    "joseph.khater@middough.com",
    "niko.santarelli@middough.com",
    "mark.custer@middough.com",
    "kyle.cussen@middough.com",
    "brian.molnar@middough.com",
    "jason.thompson@middough.com",
    "chip.hoppel@middough.com",
    "thomas.popp@middough.com",
    "richard.genser@middough.com",
    "richard.johnson@middough.com",
    "jeffery.kuzma@middough.com",
    "david.mayares@middough.com",
    "nathan.schuerman@middough.com",
    "benjamin.thompson@middough.com",
    "michael.roberts@middough.com",
    "christopher.ryan@middough.com",
    "michael.smith@middough.com",
    "ian.sarata@middough.com",
    "nicholas.scibetta@middough.com",
    "brad.malone@middough.com",
    "harold.kropp@middough.com",
    "james.carns@middough.com",
    "james.weinheimer@middough.com",
    "william.winter@middough.com",
    "jimmy.wood@middough.com",
    "rodney.roth@middough.com",
    "james.weinheimer@middough.com",
    "tim.thole@middough.com",
    "kauveh.aynafshar@middough.com",
    "matthew.hammond@middough.com",
    "barbara.palmer@middough.com",
    "austin.lackritz@middough.com",
    "drew.zimmerman@middough.com",
    "haley.mason@middough.com",
    "george.rowe@middough.com",
    "jim.johnson@middough.com"
)


$userInfos = @()

foreach ($user in $users) {
    Write-Host "Processing : $user"

    # Query AD by full email address using -Filter
    $adUser = Get-ADUser -Filter { mail -eq $user } -Properties mail, Department, SamAccountName -ErrorAction SilentlyContinue

    if ($adUser) {
        $userInfo = [PSCustomObject]@{
            Username   = $adUser.SamAccountName
            Email      = $adUser.mail
            Department = $adUser.Department
        }
    }
    else {
        $userInfo = [PSCustomObject]@{
            Username   = "Not Found"
            Email      = $user
            Department = "N/A"
        }
    }

    $userInfos += $userInfo
}

# Output neatly
$userInfos | Format-Table -AutoSize


<#

Username           Email                           Department
--------           -----                           ----------
robert.bordon      robert.bordon@middough.com      425.02 CHI Piping
donavynn.hayes     donavynn.hayes@middough.com     425.03 TOL Piping
joseph.kalic       joseph.kalic@middough.com       425.01 CLE Piping
joseph.khater      joseph.khater@middough.com      425.01 CLE Piping
nikolas.santarelli nikolas.santarelli@middough.com 425.01 CLE Piping
mark.custer        mark.custer@middough.com        650.08 NWI Instrumental & Controls
kyle.cussen        kyle.cussen@middough.com        650.08 NWI Instrumental & Controls
brian.molnar       brian.molnar@middough.com       475.01 CLE Automation
jason.thompson     jason.thompson@middough.com     100.08 NWI Structural
chip.hoppel        chip.hoppel@middough.com        100.08 NWI Structural
thomas.popp        thomas.popp@middough.com        600.02 CHI Electrical
richard.genser     richard.genser@middough.com     100.27 PIT Structural
richard.johnson    richard.johnson@middough.com    100.27 PIT Structural
jeffery.kuzma      jeffery.kuzma@middough.com      100.27 PIT Structural
david.mayares      david.mayares@middough.com      100.27 PIT Structural
nathan.schuerman   nathan.schuerman@middough.com   600.27 PIT Electrical
benjamin.thompson  benjamin.thompson@middough.com  600.27 PIT Electrical
michael.roberts    michael.roberts@middough.com    600.27 PIT Electrical
christopher.ryan   christopher.ryan@middough.com   600.27 PIT Electrical
michael.smith      michael.smith@middough.com      600.27 PIT Electrical
ian.sarata         ian.sarata@middough.com         100.06 BUF Structural
nicholas.scibetta  nicholas.scibetta@middough.com  425.06 BUF Piping
brad.malone        brad.malone@middough.com        425.27 PIT Piping
harold.kropp       harold.kropp@middough.com       400.06 BUF Mechanical
james.carns        james.carns@middough.com        400.06 BUF Mechanical
james.weinheimer   james.weinheimer@middough.com   400.06 BUF Mechanical
william.winter     william.winter@middough.com     400.06 BUF Mechanical
jimmy.wood         jimmy.wood@middough.com         425.02 CHI Piping
rodney.roth        rodney.roth@middough.com        425.02 CHI Piping
james.weinheimer   james.weinheimer@middough.com   425.02 CHI Piping
tim.thole          tim.thole@middough.com          425.02 CHI Piping
kauveh.aynafshar   kauveh.aynafshar@middough.com   650.03 TOL Instrumental & Controls
matthew.hammond    matthew.hammond@middough.com    650.03 TOL Instrumental & Controls
barbara.palmer     barbara.palmer@middough.com     650.03 TOL Instrumental & Controls
austin.lackritz    austin.lackritz@middough.com    425.01 CLE Piping
drew.zimmerman     drew.zimmerman@middough.com     200.02 CHI Civil
haley.mason        haley.mason@middough.com        350.02 CHI Process
george.rowe        george.rowe@middough.com        350.02 CHI Process
jim.johnson        jim.johnson@middough.com        350.02 CHI Process
#>
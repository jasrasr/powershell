$TimeStamp = Get-Date -Format "yyyy-MM-dd-HH-mm-ss"

#$SourceFolder = "C:\Temp\test\bbstamps"
#Remove-Item C:\temp\test\bbstamps\* -Recurse
Remove-Item C:\temp\test\bbstamps\* -Recurse
#$SourceFolder1 = "c:\users\$env:USERNAME\${domain}\Quality - MAPP\6.0 - DESIGN EXECUTION\6.0 - QUALITY ASSURANCE AND CONTROL\6.0.6 Document Control\MAPP 6.0.6.1 Electronic Package and Stamping\Engineering Stamps" #matt
#$SourceFolder2 = "c:\users\$env:USERNAME\onedrive - ${domain}\MAPP\6.0 - DESIGN EXECUTION\6.0 - QUALITY ASSURANCE AND CONTROL\6.0.6 Document Control\MAPP 6.0.6.1 Electronic Package and Stamping\Engineering Stamps" #jason
$SourceFolder1 = "c:\users\matt.bedee\${domain}\Quality - MAPP\6.0 - DESIGN EXECUTION\6.0 - QUALITY ASSURANCE AND CONTROL\6.0.6 Document Control\MAPP 6.0.6.1 Electronic Package and Stamping\Engineering Stamps" #matt
$SourceFolder2 = "c:\users\jason.lamb\onedrive - ${domain}\MAPP\6.0 - DESIGN EXECUTION\6.0 - QUALITY ASSURANCE AND CONTROL\6.0.6 Document Control\MAPP 6.0.6.1 Electronic Package and Stamping\Engineering Stamps" #jason
$SourceFolder3 = "C:\Users\justin.walters\OneDrive - ${domain}\Documents - Quality\MAPP\6.0 - DESIGN EXECUTION\6.0 - QUALITY ASSURANCE AND CONTROL\6.0.6 Document Control\MAPP 6.0.6.1 Electronic Package and Stamping\Engineering Stamps" #justin
$BBDestinationFolder = "C:\ProgramData\Bluebeam Software\Bluebeam Revu\21\Stamps\test"
Remove-Item $BBDestinationFolder\* -Recurse
$RunLogPath = "$BBDestinationFolder\! $timestamp.txt"
New-Item -Path $RunLogPath -ItemType File -Force

if (Test-Path $BBDestinationFolder) {
    Write-Host "destination folder found"
}
else {
    Write-Host "No destination folder found"
}

if (Test-Path $SourceFolder1) {
        copy-Item -Path "$SourceFolder1\*" -Destination $BBDestinationFolder -Recurse -Force
        write-host "Copied from sourcefolder1 - $sourcefolder1"
    }
else {
        Write-Host "No sourcefolder1 folder found"
}

if (Test-Path $SourceFolder2) { 
        Copy-Item -Path "$SourceFolder2\*" -Destination $BBDestinationFolder -Recurse -Force
        write-host "Copied from sourcefolder2 - $sourcefolder2"
    }
else {
        Write-Host "No sourcefolder2 folder found"
}

if (Test-Path $SourceFolder3) { 
    Copy-Item -Path "$SourceFolder3\*" -Destination $BBDestinationFolder -Recurse -Force
    write-host "Copied from sourcefolder3 - $sourcefolder3"
}
else {
    Write-Host "No sourcefolder3 folder found"
}



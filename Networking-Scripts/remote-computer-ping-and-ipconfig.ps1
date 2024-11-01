$remoteComputer = "chiw113jvd814"  # Replace with the name or IP of the remote computer

ping $remotecomputer

# Invoke ipconfig on the remote computer and display the output
Invoke-Command -ComputerName $remoteComputer -ScriptBlock {

### used for troubleshooting ###
#Enable-PSRemoting -Force
#Get-Service WinRM
#Start-Service WinRM


    ipconfig /all
}


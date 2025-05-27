#run as admin
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
install-module powershellget -force -allowclobber
import-module powershellget
Install-Module -Name PSWindowsUpdate -Force -allowclobber
import-module pswindowsupdate
get-windowsupdate

vmhostname WinDev2407Eval
### TRANSFER FILE TO HYPER-V VM
$vmName = "YourVMName"

Copy-VMFile $vmname -SourcePath "c:\temp\Dell_IAX.zip" -DestinationPath "c:\temp\Dell_IAX.zip" -CreateFullPath -FileSource Host

Invoke-Command -VMName $vmName -ScriptBlock {
	Expand-Archive -Path "c:\temp\Dell_IAX.zip" -DestinationPath "c:\temp\Dell_IAX"
	#New-Item -Path "C:\temp1" -ItemType Directory
}



### INSTALL WINGET
$progressPreference = 'silentlyContinue'
Write-Host "Installing WinGet PowerShell module from PSGallery..."
Install-PackageProvider -Name NuGet -Force | Out-Null
Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery | Out-Null
Write-Host "Using Repair-WinGetPackageManager cmdlet to bootstrap WinGet..."
Repair-WinGetPackageManager
Write-Host "Done."

<#

# $profile file locations
# VSC aka Visual Studio Code or VS Code, PS5 = PowerShell v5+ and PS7 = PowerShell v7+
VSC = "C:\Users\$env:username\Documents\PowerShell\Microsoft.VSCode_profile.ps1" 
PS5 = "C:\Users\$env:username\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
PS7 = "C:\Users\$env:username\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
# same for different admin user on the same computer, replace $env:username with admin username

MOST IMPORTANT - add dot reference to the common profile file for common variables
. $commonProfilePath
$commonProfilePath = "C:\Users\$env:username\Documents\!PowerShellCommonProfile.ps1"

#>

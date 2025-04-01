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
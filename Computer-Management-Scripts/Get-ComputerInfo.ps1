# Filename: Get-ComputerInfo.ps1
# Revision : 1.4.2
# Description : Collects computer name, serial, manufacturer, model, Windows version, current user
#               (username + display name), last logged-on user, domain/workgroup, IP, MAC,
#               disk, CPU, GPU, RAM, BitLocker status, OS install date, last boot time,
#               last Windows update date, and pending reboot status.
#               Runs without admin rights and is compatible with PowerShell 5. Exports to CSV with
#               a computer name and datetime suffix. Optionally reports to a web API.
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-05-05
# Modified Date : 2026-05-06
# Changelog :
# 1.0.0 initial release
# 1.1.0 added GPU, BitLocker status via Shell.Application (no admin required), and current user display name
# 1.2.0 added Windows version, manufacturer, model, domain/workgroup, IP, MAC, OS install date,
#        last boot time, last Windows update date, and pending reboot status
# 1.3.0 added optional API reporting to jasr.me/computers via -Upload switch
# 1.4.0 upload now on by default; replaced -Upload with -NoUpload to opt out
# 1.4.1 update example usage with irm "jasr.me/al-comp" | iex
# 1.4.2 fix OSInstallDate/LastBootTime being blank when run via irm | iex
#        (deserialized WMI objects lack ConvertToDateTime method — use static converter instead)

param(
    [string]$ExportPath = ".",
    [switch]$NoUpload
)

# ── API Config ────────────────────────────────────────────────────────────────
$ApiUri    = "https://jasr.me/github/computers/save_log.php"
$ApiSecret = "H4wkR1dg3-2025-Heartbeat"

# ── Computer Name ─────────────────────────────────────────────────────────────
$computerName = $env:COMPUTERNAME

# ── Current User (username + display name) ────────────────────────────────────
$currentUsername = $env:USERNAME
try {
    Add-Type -AssemblyName System.DirectoryServices.AccountManagement -ErrorAction Stop
    $currentDisplayName = ([System.DirectoryServices.AccountManagement.UserPrincipal]::Current).DisplayName
    if (-not $currentDisplayName) { $currentDisplayName = $currentUsername }
} catch {
    $currentDisplayName = $currentUsername
}

# ── Last Logged-On User ───────────────────────────────────────────────────────
# Registry key is readable without admin rights on most domain-joined machines
try {
    $lastUser = (Get-ItemProperty `
        -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" `
        -Name "LastLoggedOnUser" `
        -ErrorAction Stop).LastLoggedOnUser
} catch {
    # Fall back to current session user if registry key is unavailable
    $lastUser = (Get-WmiObject -Class Win32_ComputerSystem).UserName
}
if (-not $lastUser) { $lastUser = $currentUsername }

# ── CPU ───────────────────────────────────────────────────────────────────────
$cpu     = Get-WmiObject -Class Win32_Processor | Select-Object -First 1
$cpuName = $cpu.Name.Trim()

# ── GPU ───────────────────────────────────────────────────────────────────────
try {
    $gpus    = Get-WmiObject -Class Win32_VideoController -ErrorAction Stop
    $gpuName = ($gpus | Select-Object -ExpandProperty Name) -join " / "
} catch {
    $gpuName = "N/A"
}

# ── Manufacturer / Model / Domain / RAM ───────────────────────────────────────
$csInfo          = Get-WmiObject -Class Win32_ComputerSystem
$manufacturer    = $csInfo.Manufacturer.Trim()
$model           = $csInfo.Model.Trim()
$domainOrWorkgroup = if ($csInfo.PartOfDomain) { $csInfo.Domain } else { "WORKGROUP: $($csInfo.Workgroup)" }
$totalRAM_GB     = [math]::Round($csInfo.TotalPhysicalMemory / 1GB, 2)

# ── OS / Windows Version ──────────────────────────────────────────────────────
$osInfo        = Get-WmiObject -Class Win32_OperatingSystem
$displayVersion = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" `
                    -Name "DisplayVersion" -ErrorAction SilentlyContinue).DisplayVersion
$isW11         = $osInfo.Caption -match "Windows 11"
$winVersion    = if ($displayVersion) {
                     if ($isW11) { "W11 $displayVersion" } else { "W10 $displayVersion" }
                 } else { $osInfo.Caption }
# Use static converter so this works even when WMI objects come back deserialized
# (e.g. when the script is run via `irm | iex`, which strips instance methods).
try {
    $osInstallDate = [Management.ManagementDateTimeConverter]::ToDateTime($osInfo.InstallDate).ToString("yyyy-MM-dd")
} catch {
    $osInstallDate = "N/A"
}
try {
    $lastBootTime  = [Management.ManagementDateTimeConverter]::ToDateTime($osInfo.LastBootUpTime).ToString("yyyy-MM-dd HH:mm:ss")
} catch {
    $lastBootTime  = "N/A"
}

# ── Network (primary NIC with default gateway) ────────────────────────────────
try {
    $nic        = Get-WmiObject Win32_NetworkAdapterConfiguration |
                  Where-Object { $_.IPEnabled -and $_.DefaultIPGateway } |
                  Select-Object -First 1
    $ipAddress  = ($nic.IPAddress  | Where-Object { $_ -match '^\d+\.\d+\.\d+\.\d+$' }) | Select-Object -First 1
    $macAddress = $nic.MACAddress
    if (-not $ipAddress)  { $ipAddress  = "N/A" }
    if (-not $macAddress) { $macAddress = "N/A" }
} catch {
    $ipAddress  = "N/A"
    $macAddress = "N/A"
}

# ── Last Windows Update ───────────────────────────────────────────────────────
try {
    $updateSession  = New-Object -ComObject Microsoft.Update.Session
    $updateSearcher = $updateSession.CreateUpdateSearcher()
    $historyCount   = $updateSearcher.GetTotalHistoryCount()
    if ($historyCount -gt 0) {
        $lastUpdateDate = ($updateSearcher.QueryHistory(0, 1) | Select-Object -First 1).Date.ToString("yyyy-MM-dd")
    } else {
        $lastUpdateDate = "Unknown"
    }
} catch {
    $lastUpdateDate = "Unavailable"
}

# ── Pending Reboot ────────────────────────────────────────────────────────────
try {
    $pendingReboot = $false
    if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending") {
        $pendingReboot = $true
    }
    if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired") {
        $pendingReboot = $true
    }
    $pfro = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" `
             -Name "PendingFileRenameOperations" -ErrorAction SilentlyContinue).PendingFileRenameOperations
    if ($pfro) { $pendingReboot = $true }
} catch {
    $pendingReboot = "Unknown"
}

# ── Disk (all local fixed drives combined) ────────────────────────────────────
$disks        = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3"
$totalDisk_GB = [math]::Round(($disks | Measure-Object -Property Size      -Sum).Sum / 1GB, 2)
$freeDisk_GB  = [math]::Round(($disks | Measure-Object -Property FreeSpace -Sum).Sum / 1GB, 2)

# ── BitLocker Status ──────────────────────────────────────────────────────────
# Shell.Application ExtendedProperty works without admin rights
try {
    $blvProp = (New-Object -ComObject Shell.Application).NameSpace($env:SystemDrive + "\").Self.ExtendedProperty("System.Volume.BitLockerProtection")
    $bitlockerStatus = switch ($blvProp) {
        0 { "Off" }
        1 { "On" }
        2 { "Suspended" }
        3 { "Encrypting" }
        4 { "Decrypting" }
        5 { "Suspended" }
        6 { "Locked" }
        default { "Unknown ($blvProp)" }
    }
} catch {
    $bitlockerStatus = "Unavailable"
}

# ── Serial Number ─────────────────────────────────────────────────────────────
try {
    $serial = (Get-WmiObject -Class Win32_BIOS).SerialNumber.Trim()
} catch {
    $serial = "N/A"
}

# ── Build Result ──────────────────────────────────────────────────────────────
$result = [PSCustomObject]@{
    ComputerName        = $computerName
    SerialNumber        = $serial
    Manufacturer        = $manufacturer
    Model               = $model
    WindowsVersion      = $winVersion
    CurrentUsername     = $currentUsername
    CurrentDisplayName  = $currentDisplayName
    LastUser            = $lastUser
    DomainOrWorkgroup   = $domainOrWorkgroup
    IPAddress           = $ipAddress
    MACAddress          = $macAddress
    TotalDisk_GB        = $totalDisk_GB
    FreeDisk_GB         = $freeDisk_GB
    CPU                 = $cpuName
    GPU                 = $gpuName
    TotalRAM_GB         = $totalRAM_GB
    BitLockerStatus     = $bitlockerStatus
    OSInstallDate       = $osInstallDate
    LastBootTime        = $lastBootTime
    LastUpdateDate      = $lastUpdateDate
    PendingReboot       = $pendingReboot
    CollectedAt         = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
}

# ── Display ───────────────────────────────────────────────────────────────────
$result | Format-List

# ── Export ────────────────────────────────────────────────────────────────────
$dateStamp = Get-Date -Format "yyyyMMdd_HHmmss"
$fileName  = "${computerName}_${dateStamp}.csv"
$filePath  = Join-Path -Path $ExportPath -ChildPath $fileName

if (-not (Test-Path $ExportPath)) {
    New-Item -ItemType Directory -Path $ExportPath -Force | Out-Null
}

$result | Export-Csv -Path $filePath -NoTypeInformation
Write-Host "Exported to: $filePath" -ForegroundColor Green

# ── Upload to API ─────────────────────────────────────────────────────────────
if (-not $NoUpload) {
    Write-Host "Uploading to API..." -ForegroundColor Cyan
    try {
        $postBody = @{ Secret = $ApiSecret }
        $result.PSObject.Properties | ForEach-Object { $postBody[$_.Name] = "$($_.Value)" }

        $headers  = @{ "User-Agent" = "ComputerInventory/1.0" }
        $response = Invoke-RestMethod -Uri $ApiUri -Method POST -Headers $headers -Body $postBody -TimeoutSec 15
        Write-Host "Upload OK — entries on server: $($response.entries)" -ForegroundColor Green
    } catch {
        Write-Warning "Upload failed: $_"
    }
}

# Example Usage:
#   irm "jasr.me/al-comp" | iex
#   .\Get-ComputerInfo.ps1
#   .\Get-ComputerInfo.ps1 -ExportPath "C:\Exports"
#   .\Get-ComputerInfo.ps1 -ExportPath "\\server\share\inventory"
#   .\Get-ComputerInfo.ps1 -NoUpload
#   .\Get-ComputerInfo.ps1 -ExportPath "C:\Exports" -NoUpload

# Filename: Get-ComputerInfo.ps1
# Revision : 1.0.0
# Description : Collects computer name, last user, disk size/free space, CPU, RAM, and serial number.
#               Runs without admin rights and is compatible with PowerShell 5. Exports to CSV with
#               a computer name and datetime suffix.
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-05-05
# Modified Date : 2026-05-05
# Changelog :
# 1.0.0 initial release

param(
    [string]$ExportPath = "."
)

# ── Computer Name ─────────────────────────────────────────────────────────────
$computerName = $env:COMPUTERNAME

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
if (-not $lastUser) { $lastUser = $env:USERNAME }

# ── CPU ───────────────────────────────────────────────────────────────────────
$cpu     = Get-WmiObject -Class Win32_Processor | Select-Object -First 1
$cpuName = $cpu.Name.Trim()

# ── RAM ───────────────────────────────────────────────────────────────────────
$ramInfo     = Get-WmiObject -Class Win32_ComputerSystem
$totalRAM_GB = [math]::Round($ramInfo.TotalPhysicalMemory / 1GB, 2)

# ── Disk (all local fixed drives combined) ────────────────────────────────────
$disks        = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3"
$totalDisk_GB = [math]::Round(($disks | Measure-Object -Property Size      -Sum).Sum / 1GB, 2)
$freeDisk_GB  = [math]::Round(($disks | Measure-Object -Property FreeSpace -Sum).Sum / 1GB, 2)

# ── Serial Number ─────────────────────────────────────────────────────────────
try {
    $serial = (Get-WmiObject -Class Win32_BIOS).SerialNumber.Trim()
} catch {
    $serial = "N/A"
}

# ── Build Result ──────────────────────────────────────────────────────────────
$result = [PSCustomObject]@{
    ComputerName  = $computerName
    LastUser      = $lastUser
    TotalDisk_GB  = $totalDisk_GB
    FreeDisk_GB   = $freeDisk_GB
    CPU           = $cpuName
    TotalRAM_GB   = $totalRAM_GB
    SerialNumber  = $serial
    CollectedAt   = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
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

# Example Usage:
#   .\Get-ComputerInfo.ps1
#   .\Get-ComputerInfo.ps1 -ExportPath "C:\Exports"
#   .\Get-ComputerInfo.ps1 -ExportPath "\\server\share\inventory"

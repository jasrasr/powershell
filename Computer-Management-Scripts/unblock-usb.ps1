# Author: Dave Upton

# Set Deny_Write to 0 (unlock) on CD/DVD class
$cdKeyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b}"

if (Test-Path $cdKeyPath) {
    Set-ItemProperty -Path $cdKeyPath -Name "Deny_Write" -Value 0 -Type DWord
    Write-Host "Unlocked (Deny_Write=0): $cdKeyPath"
} else {
    Write-Host "Key not found: $cdKeyPath"
}

Write-Host "`n--- Auditing RemovableStorageDevices policy tree ---"

# Enumerate whatever device class subkeys actually exist rather than assuming GUIDs
$rootPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices"

if (Test-Path $rootPath) {
    # Top-level Deny_All applies to all removable storage classes at once
    $rootProps = Get-ItemProperty -Path $rootPath -ErrorAction SilentlyContinue
    if ($rootProps.Deny_All) {
        Write-Host "Root Deny_All = $($rootProps.Deny_All)  <- blocks ALL removable storage classes regardless of per-class settings"
    }

    Get-ChildItem -Path $rootPath -ErrorAction SilentlyContinue | ForEach-Object {
        $props = Get-ItemProperty -Path $_.PSPath
        Write-Host "$($_.PSChildName): Deny_Read=$($props.Deny_Read) Deny_Write=$($props.Deny_Write) Deny_Execute=$($props.Deny_Execute)"
    }
} else {
    Write-Host "No RemovableStorageDevices policy key present."
}

Write-Host "`n--- Checking other common USB lockdown mechanisms ---"

# USBSTOR service disable (3 = enabled/manual start, 4 = disabled)
$usbstorPath = "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR"
$usbstor = Get-ItemProperty -Path $usbstorPath -ErrorAction SilentlyContinue
if ($usbstor) {
    Write-Host "USBSTOR Start = $($usbstor.Start)  (3=enabled, 4=disabled)"
}

# StorageDevicePolicies write protect - separate legacy mechanism, applies broadly to disks
$storPolPath = "HKLM:\SYSTEM\CurrentControlSet\Control\StorageDevicePolicies"
$storPol = Get-ItemProperty -Path $storPolPath -ErrorAction SilentlyContinue
if ($storPol) {
    Write-Host "StorageDevicePolicies WriteProtect = $($storPol.WriteProtect)  (1=all write blocked)"
} else {
    Write-Host "StorageDevicePolicies key not present."
}

# Device installation restrictions - a completely separate lockdown path (blocks by device class/ID at install time, not read/write)
$devRestrictPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DeviceInstall\Restrictions"
if (Test-Path $devRestrictPath) {
    Write-Host "`nDevice Installation Restrictions policy present at $devRestrictPath - check DenyDeviceClasses / DenyDeviceIDs values, this blocks USB at the driver install level, separate from read/write deny."
}

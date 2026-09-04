# Revision : 1.0
# Description : Ping every host address in a CIDR block in parallel and report which respond
# Author : Jason Lamb (with help from Claude)
# Created Date : 2026-09-03
# Modified Date : 2026-09-03

# Example: .\Ping-Subnet.ps1 -Cidr "98.102.65.0/24"
# Only /16 through /30 blocks are supported (keeps host counts sane).

param(
    [string]$Cidr = "98.102.65.0/24",
    [int]$TimeoutSeconds = 1,
    [int]$ThrottleLimit = 32,
    [switch]$IncludeNetworkAndBroadcast
)

function Get-CidrHosts {
    param(
        [string]$Cidr,
        [switch]$IncludeNetworkAndBroadcast
    )

    $parts = $Cidr -split '/'
    if ($parts.Count -ne 2) {
        throw "Cidr must be in the form 'a.b.c.d/prefix', e.g. 98.102.65.0/24"
    }

    $baseIp = [System.Net.IPAddress]::Parse($parts[0])
    $prefixLength = [int]$parts[1]

    if ($prefixLength -lt 16 -or $prefixLength -gt 30) {
        throw "Prefix length $prefixLength is out of the supported range (/16 - /30)."
    }

    $baseBytes = $baseIp.GetAddressBytes()
    if ([BitConverter]::IsLittleEndian) { [Array]::Reverse($baseBytes) }
    $baseULong = [uint64][BitConverter]::ToUInt32($baseBytes, 0)

    $hostBits = 32 - $prefixLength
    $hostMask = (1UL -shl $hostBits) - 1
    $maskULong = 0xFFFFFFFFUL -bxor $hostMask
    $networkULong = $baseULong -band $maskULong
    $broadcastULong = $networkULong -bor $hostMask

    $firstULong = if ($IncludeNetworkAndBroadcast) { $networkULong } else { $networkULong + 1 }
    $lastULong = if ($IncludeNetworkAndBroadcast) { $broadcastULong } else { $broadcastULong - 1 }

    for ($current = $firstULong; $current -le $lastULong; $current++) {
        $bytes = [BitConverter]::GetBytes([uint32]$current)
        if ([BitConverter]::IsLittleEndian) { [Array]::Reverse($bytes) }
        [System.Net.IPAddress]::new($bytes).ToString()
    }
}

$targets = Get-CidrHosts -Cidr $Cidr -IncludeNetworkAndBroadcast:$IncludeNetworkAndBroadcast

Write-Host ""
Write-Host "Pinging $($targets.Count) addresses in $Cidr ..."
Write-Host "---------------------------------------------"

$results = $targets | ForEach-Object -ThrottleLimit $ThrottleLimit -Parallel {
    $ip = $_
    $alive = Test-Connection -TargetName $ip -Count 1 -TimeoutSeconds $using:TimeoutSeconds -Quiet
    [PSCustomObject]@{
        IPAddress = $ip
        Online    = $alive
    }
}

$online = $results | Where-Object Online | Sort-Object { [version]($_.IPAddress) }

$online | ForEach-Object { Write-Host "ONLINE  $($_.IPAddress)" -ForegroundColor Green }

Write-Host "---------------------------------------------"
Write-Host "$($online.Count) of $($targets.Count) addresses responded"

$logFolder = "C:\temp\powershell-exports"
if (-not (Test-Path $logFolder)) {
    New-Item -Path $logFolder -ItemType Directory -Force | Out-Null
}

$datetime = Get-Date -Format "yyyyMMdd-HHmmss"
$cidrLabel = $Cidr -replace '[/\\:]', '-'
$logFile = "$logFolder\ping-subnet-$cidrLabel-$datetime.csv"

$results | Sort-Object { [version]($_.IPAddress) } | Export-Csv -Path $logFile -NoTypeInformation

Write-Host "Full results saved to $logFile"

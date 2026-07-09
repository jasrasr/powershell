<#!
.SYNOPSIS
    Performs a lightweight network diagnostic test against one or more hosts.
.DESCRIPTION
    Test-NetworkConnectivity validates DNS resolution, ICMP reachability, and TCP port checks for
    each host that you specify. The cmdlet produces a summary object with pass/fail indicators.
.PARAMETER ComputerName
    One or more hostnames or IP addresses to test.
.PARAMETER TcpPort
    Optional list of TCP ports (per host) to validate via Test-NetConnection.
.PARAMETER ThrottleLimit
    Controls how many hosts are tested concurrently.
.EXAMPLE
    .\\Test-NetworkConnectivity.ps1 -ComputerName fileserver,print01
.EXAMPLE
    .\\Test-NetworkConnectivity.ps1 -ComputerName contoso.com -TcpPort 80,443
.NOTES
    Author: ChatGPT Automation
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string[]]$ComputerName,

    [Parameter()]
    [ValidateRange(1,65535)]
    [int[]]$TcpPort,

    [Parameter()]
    [ValidateRange(1,32)]
    [int]$ThrottleLimit = 4
)

$scriptBlock = {
    param($HostName, $Ports)
    $result = [pscustomobject]@{
        ComputerName = $HostName
        DnsResolved  = $false
        PingSucceeded= $false
        TcpResults   = @()
        ErrorMessage = $null
    }

    try {
        $null = Resolve-DnsName -Name $HostName -ErrorAction Stop
        $result.DnsResolved = $true

        $ping = Test-Connection -ComputerName $HostName -Count 2 -Quiet -ErrorAction Stop
        $result.PingSucceeded = [bool]$ping

        if ($Ports) {
            $tcpTests = foreach ($port in $Ports) {
                $tcpResult = Test-NetConnection -ComputerName $HostName -Port $port -WarningAction SilentlyContinue
                [pscustomobject]@{
                    Port        = $port
                    TcpSucceeded= [bool]$tcpResult.TcpTestSucceeded
                    LatencyMS   = $tcpResult.PingReplyDetails.RoundtripTime
                }
            }
            $result.TcpResults = $tcpTests
        }
    } catch {
        $result.ErrorMessage = $_.Exception.Message
    }

    return $result
}

$ComputerName |
    ForEach-Object -Parallel $scriptBlock -ThrottleLimit $ThrottleLimit -ArgumentList $TcpPort

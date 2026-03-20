<#!
.SYNOPSIS
    Generates a point-in-time report that summarizes CPU, memory, process, and disk usage.
.DESCRIPTION
    Get-SystemHealthReport gathers system metrics that are typically reviewed during health checks.
    The script can optionally persist the results to disk in JSON format for later analysis.
.PARAMETER TopProcessCount
    Indicates how many of the busiest processes (based on CPU time) to include in the report.
.PARAMETER OutputPath
    When provided, saves the health report as a JSON file to the specified path.
.EXAMPLE
    .\\Get-SystemHealthReport.ps1 -TopProcessCount 10
.EXAMPLE
    .\\Get-SystemHealthReport.ps1 -OutputPath C:\\Temp\\system-health.json
.NOTES
    Author: ChatGPT Automation
#>
[CmdletBinding()]
param(
    [Parameter()]
    [ValidateRange(1,50)]
    [int]$TopProcessCount = 5,

    [Parameter()]
    [string]$OutputPath
)

function Get-DiskUsage {
    [CmdletBinding()]
    param()
    Get-PSDrive -PSProvider 'FileSystem' |
        Where-Object { $_.Free -ne $null } |
        Select-Object Name, @{n='UsedGB';e={[math]::Round(($_.Used/1GB),2)}}, @{n='FreeGB';e={[math]::Round(($_.Free/1GB),2)}},
                      @{n='FreePercent';e={[math]::Round(($_.Free/($_.Used+$_.Free))*100,2)}}
}

function Get-TopProcesses {
    [CmdletBinding()]
    param(
        [int]$Count
    )
    Get-Process |
        Sort-Object -Property CPU -Descending |
        Select-Object -First $Count -Property ProcessName, CPU, Id, PM, WS
}

$report = [pscustomobject]@{
    GeneratedOn    = Get-Date
    ComputerName   = $env:COMPUTERNAME
    Uptime         = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
    CpuLoadPercent = (Get-Counter '\\Processor(_Total)\\% Processor Time').CounterSamples.CookedValue
    MemoryStatus   = Get-CimInstance -ClassName Win32_OperatingSystem |
                        Select-Object @{n='TotalVisibleMemoryGB';e={[math]::Round($_.TotalVisibleMemorySize/1MB,2)}},
                                      @{n='FreePhysicalMemoryGB';e={[math]::Round($_.FreePhysicalMemory/1MB,2)}}
    TopProcesses   = Get-TopProcesses -Count $TopProcessCount
    DiskUsage      = Get-DiskUsage
}

if ($OutputPath) {
    $OutputDirectory = Split-Path -Path $OutputPath -Parent
    if ($OutputDirectory -and -not (Test-Path -Path $OutputDirectory)) {
        New-Item -Path $OutputDirectory -ItemType Directory -Force | Out-Null
    }
    $report | ConvertTo-Json -Depth 4 | Set-Content -Path $OutputPath
    Write-Verbose "Health report saved to $OutputPath"
} else {
    $report
}

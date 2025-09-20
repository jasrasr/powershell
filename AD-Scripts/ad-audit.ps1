<#
.SYNOPSIS
  Audit AD "reactivations" (Event ID 4722) on a single DC (configurable).

.DESCRIPTION
  Queries the Security log on the chosen Domain Controller for Event ID 4722
  (A user account was enabled) and reports who enabled it and when.
  Optionally also grabs nearby disables (4725) for timeline context.

.REFERENCES
  4722 event details & fields (Target/Subject): Microsoft Docs
  Advanced Audit Policy → User Account Management: Microsoft Docs
#>

param(
  [Parameter(Mandatory = $true)]
  [string] $UserSamAccountName,

  [datetime] $StartTime = (Get-Date).AddDays(-30),
  [datetime] $EndTime   = (Get-Date)
)

# === CONFIGURABLE ===
# Only this DC will be queried. Change when needed.
$DomainController = 'CLEDC1'

# Output location
$OutDir  = 'C:\temp\powershell-exports'
if (-not (Test-Path $OutDir)) { New-Item -Path $OutDir -ItemType Directory | Out-Null }
$Stamp   = Get-Date -Format 'yyyyMMdd-HHmmss'
$OutFile = Join-Path $OutDir "ad-reactivation-audit-$($DomainController)-$Stamp.csv"

Write-Host "Target DC     : $DomainController"
Write-Host "Target user   : $UserSamAccountName"
Write-Host "Time window   : $StartTime -> $EndTime"
Write-Host "Output file   : $OutFile"

function Convert-EventToRecord {
  param([System.Diagnostics.Eventing.Reader.EventRecord] $Event)

  # Parse XML safely instead of regexing strings
  $xml = [xml]$Event.ToXml()

  # Helper to read <Data Name="...">value</Data>
  $kv = @{}
  foreach ($d in $xml.Event.EventData.Data) {
    if ($d.Name) { $kv[$d.Name] = $d.'#text' }
  }

  [pscustomobject]@{
    TimeCreated        = $Event.TimeCreated
    DC                 = $Event.MachineName
    RecordId           = $Event.RecordId
    EventId            = $Event.Id
    TargetUserName     = $kv['TargetUserName']
    TargetDomainName   = $kv['TargetDomainName']
    SubjectUserName    = $kv['SubjectUserName']
    SubjectDomainName  = $kv['SubjectDomainName']
    SubjectUserSid     = $kv['SubjectUserSid']
    SubjectLogonId     = $kv['SubjectLogonId']
  }
}

# Query function for a single event ID and target user
function Get-UserEvents {
  param(
    [int] $EventId,
    [string] $UserName,
    [datetime] $From,
    [datetime] $To
  )

  $filter = @{
    LogName   = 'Security'
    Id        = $EventId
    StartTime = $From
    EndTime   = $To
  }

  try {
    Get-WinEvent -ComputerName $DomainController -FilterHashtable $filter -ErrorAction Stop |
      Where-Object {
        # Fast pre-filter by XML node value
        $x = [xml]$_.ToXml()
        $n = $x.SelectSingleNode("//EventData/Data[@Name='TargetUserName']")
        ($n -and $n.'#text' -eq $UserName)
      } |
      ForEach-Object { Convert-EventToRecord $_ }
  }
  catch {
    Write-Host "Error on $DomainController : $_"
  }
}

# 4722 = A user account was enabled (reactivated)
# 4725 = A user account was disabled (context)
$reactivations = Get-UserEvents -EventId 4722 -UserName $UserSamAccountName -From $StartTime -To $EndTime
$disablesNear  = Get-UserEvents -EventId 4725 -UserName $UserSamAccountName -From $StartTime.AddDays(-5) -To $EndTime.AddDays(1)

$all = @()
if ($reactivations) { $all += $reactivations }
if ($disablesNear)  { $all += $disablesNear }

if ($all.Count -gt 0) {
  $all | Sort-Object TimeCreated, EventId | Export-Csv -NoTypeInformation -Encoding UTF8 -Path $OutFile
  Write-Host "`nFound $($reactivations.Count) reactivation event(s) and $($disablesNear.Count) nearby disable event(s)."
  $reactivations | Select-Object -First 5 TimeCreated,DC,TargetUserName,SubjectDomainName,SubjectUserName | Format-Table -AutoSize
  Write-Host "`nSaved CSV : $OutFile"
} else {
  Write-Host "`nNo matching events found for '$UserSamAccountName' on $DomainController in the specified window."
  Write-Host "If you expect results, verify Advanced Audit Policy 'User Account Management' is enabled."
}

invoke-item -path $OutFile
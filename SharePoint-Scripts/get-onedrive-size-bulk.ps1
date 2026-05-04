# Filename: get-onedrive-size-bulk.ps1
# Revision : 1.0.4
# Description : Get OneDrive storage usage for a list of users from a CSV via Microsoft Graph REST API
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-05-04
# Modified Date : 2026-05-04
# Changelog :
# 1.0.0 initial release (Microsoft Graph SDK Get-MgUserDrive)
# 1.0.1 fix 403 error - switch to Sites.Read.All scope, check existing scopes before skipping connect
# 1.0.2 fix admin URL derivation; switch to SharePoint Online PowerShell; fix PnP auth and assembly conflicts
# 1.0.3 fix OutFile requirement for report cmdlet; fix CSV column names
# 1.0.4 rewrite auth to pure REST device code flow - eliminates all module assembly conflicts

param(
    [string]$CsvPath,
    [string]$ExportPath,
    [string]$EmailColumn = 'EmailAddress'
)

$dateStamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$defaultExport = "C:\temp\onedrive-report-$dateStamp.csv"

if (-not $CsvPath) {
    $inputCsvPath = Read-Host "Source CSV path (press Enter for C:\temp\user-emails.csv)"
    $CsvPath = if ($inputCsvPath.Trim()) { $inputCsvPath.Trim() } else { 'C:\temp\user-emails.csv' }
}

if (-not $ExportPath) {
    $inputExportPath = Read-Host "Export path (press Enter for $defaultExport)"
    $ExportPath = if ($inputExportPath.Trim()) { $inputExportPath.Trim() } else { $defaultExport }
}

# Load CSV early so we fail fast if the path is wrong
if (-not (Test-Path $CsvPath)) {
    Write-Host "CSV file not found: $CsvPath" -ForegroundColor Red
    exit 1
}

$users = Import-Csv -Path $CsvPath

if (-not ($users | Get-Member -Name $EmailColumn -MemberType NoteProperty -ErrorAction SilentlyContinue)) {
    Write-Host "Column '$EmailColumn' not found in CSV. Available columns: $(($users[0].PSObject.Properties.Name) -join ', ')" -ForegroundColor Red
    exit 1
}

# Authenticate via device code (no modules required)
# Uses the well-known Microsoft Graph PowerShell public client ID
$clientId = '14d82eec-204b-4c2f-b7e8-296a70dab67e'
$scope    = 'https://graph.microsoft.com/Reports.Read.All offline_access'

Write-Host "Requesting device code from Microsoft..." -ForegroundColor Cyan
$deviceCodeRequest = Invoke-RestMethod -Method POST `
    -Uri "https://login.microsoftonline.com/common/oauth2/v2.0/devicecode" `
    -ContentType 'application/x-www-form-urlencoded' `
    -Body "client_id=$clientId&scope=$([Uri]::EscapeDataString($scope))"

Write-Host ""
Write-Host $deviceCodeRequest.message -ForegroundColor Yellow
Write-Host ""

# Poll for token
$tokenUri  = "https://login.microsoftonline.com/common/oauth2/v2.0/token"
$pollBody  = "grant_type=urn:ietf:params:oauth:grant-type:device_code&client_id=$clientId&device_code=$($deviceCodeRequest.device_code)"
$interval  = [int]$deviceCodeRequest.interval
$expiresIn = [int]$deviceCodeRequest.expires_in
$elapsed   = 0
$token     = $null

while ($elapsed -lt $expiresIn) {
    Start-Sleep -Seconds $interval
    $elapsed += $interval
    try {
        $token = Invoke-RestMethod -Method POST -Uri $tokenUri -ContentType 'application/x-www-form-urlencoded' -Body $pollBody -ErrorAction Stop
        break
    } catch {
        $errBody = $_.ErrorDetails.Message | ConvertFrom-Json -ErrorAction SilentlyContinue
        if ($errBody.error -eq 'authorization_pending') { continue }
        Write-Host "Authentication error: $($errBody.error_description)" -ForegroundColor Red
        exit 1
    }
}

if (-not $token) {
    Write-Host "Authentication timed out." -ForegroundColor Red
    exit 1
}

Write-Host "Authenticated successfully." -ForegroundColor Green

$headers = @{ Authorization = "Bearer $($token.access_token)" }

# Fetch OneDrive usage report — returns CSV content
Write-Host "Fetching OneDrive usage report..." -ForegroundColor Cyan
$tempFile = [System.IO.Path]::GetTempFileName()
try {
    Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/reports/getOneDriveUsageAccountDetail(period='D7')" `
        -Headers $headers -OutFile $tempFile -ErrorAction Stop
} catch {
    Write-Host "Failed to retrieve report: $_" -ForegroundColor Red
    Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
    exit 1
}

$reportData = Import-Csv -Path $tempFile
Remove-Item $tempFile -Force -ErrorAction SilentlyContinue

# Build lookup by UPN
$reportLookup = @{}
foreach ($entry in $reportData) {
    $upn = $entry.'User Principal Name'
    if ($upn) { $reportLookup[$upn.ToLower()] = $entry }
}

$results = @()

foreach ($user in $users) {
    $email = $user.$EmailColumn.Trim()
    Write-Host "`nProcessing: $email" -ForegroundColor Cyan

    $row = [PSCustomObject]@{
        EmailAddress  = $email
        Used_MB       = $null
        Used_GB       = $null
        Quota_GB      = $null
        Remaining_GB  = $null
        PercentUsed   = $null
        LastActivity  = $null
        Error         = $null
    }

    $entry = $reportLookup[$email.ToLower()]
    if ($entry) {
        $usedBytes  = [int64]$entry.'Storage Used (Byte)'
        $quotaBytes = [int64]$entry.'Storage Allocated (Byte)'

        $row.Used_MB      = [math]::Round($usedBytes / 1MB, 2)
        $row.Used_GB      = [math]::Round($usedBytes / 1GB, 2)
        $row.Quota_GB     = [math]::Round($quotaBytes / 1GB, 2)
        $row.Remaining_GB = [math]::Round(($quotaBytes - $usedBytes) / 1GB, 2)
        $row.LastActivity = $entry.'Last Activity Date'

        if ($quotaBytes -gt 0) {
            $row.PercentUsed = [math]::Round(($usedBytes / $quotaBytes) * 100, 1)
        }

        Write-Host "  Used      : $($row.Used_GB) GB ($($row.PercentUsed)%)" -ForegroundColor Yellow
        Write-Host "  Quota     : $($row.Quota_GB) GB" -ForegroundColor Gray
        Write-Host "  Remaining : $($row.Remaining_GB) GB" -ForegroundColor Gray
        Write-Host "  Last Activity : $($row.LastActivity)" -ForegroundColor Gray
    } else {
        $row.Error = "Not found in report - OneDrive may not be provisioned or user not in this tenant"
        Write-Host "  Not found in usage report" -ForegroundColor DarkYellow
    }

    $results += $row
}

Write-Host "`n--- Summary ---" -ForegroundColor Cyan
$results | Format-Table -AutoSize

if ($ExportPath) {
    $exportDir = Split-Path $ExportPath -Parent
    if (-not (Test-Path $exportDir)) { New-Item -ItemType Directory -Path $exportDir -Force | Out-Null }
    $results | Export-Csv -Path $ExportPath -NoTypeInformation
    Write-Host "Exported to: $ExportPath" -ForegroundColor Green
}

# Example Usage:
#   .\get-onedrive-size-bulk.ps1
#   .\get-onedrive-size-bulk.ps1 -CsvPath "C:\temp\users.csv"
#   .\get-onedrive-size-bulk.ps1 -CsvPath "C:\temp\users.csv" -ExportPath "C:\temp\onedrive-report.csv"
#   .\get-onedrive-size-bulk.ps1 -CsvPath "C:\temp\users.csv" -ExportPath "C:\temp\onedrive-report.csv" -EmailColumn "Email"

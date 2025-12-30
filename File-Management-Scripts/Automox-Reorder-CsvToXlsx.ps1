# Revision : 1.0
# Description : Reorder Automox CSV columns, export to XLSX, and convert to Excel table. Rev 1.0
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-12-30
# Modified Date : 2025-12-30

# PURPOSE : If you use Automox and you want to export a list of devices it always gives an export with the columns in the wrong order, or what I would consider the wrong order. This PowerShell script will fix the order, convert to xlsx, and convert the data to a table - which is something I ALWAYS do for an excel data spreadsheet.

param(
    [string] $InputCsv,
    [string] $OutputXlsx
)

# Prompt if not provided
if (-not $InputCsv) {
    $InputCsv = Read-Host "Enter full path to input CSV"
}

if (-not (Test-Path $InputCsv)) {
    Write-Error "Input file not found : $InputCsv"
    return
}

if (-not $OutputXlsx) {
    $OutputXlsx = [System.IO.Path]::ChangeExtension($InputCsv, ".xlsx")
}

# Ensure ImportExcel module exists
if (-not (Get-Module -ListAvailable ImportExcel)) {
    Write-Host "ImportExcel module not found. Installing..."
    Install-Module ImportExcel -Scope CurrentUser -Force
}

$preferredOrder = @(
    'name','display_name','custom_name','last_logged_in_user','last_disconnect_time',
    'agent_version','commands','compatibility_checks','compliant','connected',
    'create_time','deleted','detail','exception','id','instance_id',
    'ip_addrs','ip_addrs_private','is_compatible','is_delayed_by_notification',
    'is_delayed_by_user','last_process_time','last_refresh_time','last_scan_failed',
    'last_update_time','mdm','needs_attention','needs_reboot','next_patch_time',
    'notes','notification_count','organization_id','organizational_unit',
    'os_family','os_name','os_version','os_version_id','patch_deferral_count',
    'patches','pending','pending_patches','policy_status','reboot_deferral_count',
    'reboot_is_delayed_by_notification','reboot_is_delayed_by_user',
    'reboot_notification_count','refresh_interval','serial_number',
    'server_group_id','server_policies','status','tags','timezone',
    'total_count','uptime','uuid'
)

$data = Import-Csv $InputCsv | Select-Object $preferredOrder

$data | Export-Excel `
    -Path $OutputXlsx `
    -WorksheetName "Data" `
    -TableName "DeviceData" `
    -TableStyle Medium2 `
    -AutoSize `
    -FreezeTopRow `
    -BoldTopRow

Write-Host "Excel file created : $OutputXlsx"

# Example Usage: 
# Prompt mode
# .\Reorder-CsvToXlsx.ps1
# Parameter mode
# .\Reorder-CsvToXlsx.ps1 -InputCsv "C:\temp\automox-export.csv" -OutputXlsx "C:\temp\automox-clean.xlsx"

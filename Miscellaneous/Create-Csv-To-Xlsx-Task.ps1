# CreateCsvToXlsxTask.ps1

# Need to define $onedrivepath variable if not already defined
if (-not $onedrivepath) {
    $onedrivepath = 'C:\users\jason.lamb\OneDrive - middough'
}

# Define the path to the PowerShell script
$scriptPath = "$onedrivepath\Documents\GitHub\PowerShell\Miscellaneous\ConvertCsvToXlsx.ps1"

# Define the action to execute the PowerShell script
$action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""

# Define the trigger to run at system startup
$trigger = New-ScheduledTaskTrigger -AtStartup

# Define the principal to run the task with highest privileges
$principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest

# Define task settings
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

# Register the scheduled task
Register-ScheduledTask -TaskName 'CsvToXlsxConverter' -Action $action -Trigger $trigger -Principal $principal -Settings $settings

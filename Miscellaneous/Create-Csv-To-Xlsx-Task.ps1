# CreateCsvToXlsxTask.ps1

# Define the path to the PowerShell script
$scriptPath = 'C:\Users\jason.lamb\OneDrive - middough\Documents\GitHub\PowerShell\Miscellaneous\ConvertCsvToXlsx.ps1'

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

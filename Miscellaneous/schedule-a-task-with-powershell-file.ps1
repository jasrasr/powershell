# Variables
$taskName = "Auto-Update-Panzura-Disk-Space-Usage-Log"
$scriptPath = "C:\Users\jason.lamb\OneDrive - middough\Documents\GitHub\PowerShell\File-Management-Scripts\panzura disk space.ps1"
$triggerTimeAM = "8:01AM"  # First time to run the task
$triggerTimePM = "8:01PM"  # Second time to run the task

# Create two daily triggers, one for AM and one for PM
$triggerAM = New-ScheduledTaskTrigger -Daily -At $triggerTimeAM
$triggerPM = New-ScheduledTaskTrigger -Daily -At $triggerTimePM

# Create the action to run PowerShell with your script
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$scriptPath`""

# Register the scheduled task with two triggers
Register-ScheduledTask -Action $action -Trigger $triggerAM, $triggerPM -TaskName $taskName -Description "update txt file C:\Temp\Automox-Exportspanzura-space.txt with current panzura space" -User "$env:USERNAME" -RunLevel Highest

# Optionally, start the scheduled task immediately to test it
#Start-ScheduledTask -TaskName $taskname

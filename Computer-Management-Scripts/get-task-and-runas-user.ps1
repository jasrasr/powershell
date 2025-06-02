# Revision # 9
# Description : Retrieves all scheduled tasks on the local system and extracts the Task Name, Task Folder, and the user the task runs as. If the RunAsUser field is empty, it is resolved based on the LogonType. Results are sorted and displayed in a formatted table.
# Author      : Jason Lamb (help from ChatGPT 4o)
# Date        : 2025-06-02


$tasks = Get-ScheduledTask

$results = foreach ($task in $tasks) {
    $userId = $task.Principal.UserId

    if ([string]::IsNullOrWhiteSpace($userId)) {
        switch ($task.Principal.LogonType) {
            'Interactive'     { $userId = 'INTERACTIVE' }
            'Group'           { $userId = 'GROUP' }
            'ServiceAccount'  { $userId = 'SERVICE ACCOUNT' }
            default           { $userId = 'UNKNOWN' }
        }
    }

    [PSCustomObject]@{
        TaskName  = $task.TaskName
        Folder    = $task.TaskPath
        RunAsUser = $userId
    }
}

$results | Sort-Object Folder, TaskName | Format-Table -AutoSize

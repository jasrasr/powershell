# Revision # 14
# Description : Retrieves scheduled tasks from multiple remote servers, normalizes missing RunAsUser values, removes RunspaceId noise, displays results in the console, and exports to CSV.
# Author      : Jason Lamb (help from ChatGPT 4o)
# Date        : 2025-06-02

$servers = @('CLEDC1', 'TOLDC1', 'CHIDC1')  # Replace with your server names
$cred = Get-Credential
$allResults = @()

foreach ($server in $servers) {
    Write-Host "`n===== $server =====" -ForegroundColor Cyan

    try {
        $results = Invoke-Command -ComputerName $server -Credential $cred -ScriptBlock {
            $tasks = Get-ScheduledTask

            foreach ($task in $tasks) {
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
                    TaskName   = $task.TaskName
                    Folder     = $task.TaskPath
                    RunAsUser  = $userId
                }
            }
        }

        # Tag results with server name and remove RunspaceId
        foreach ($r in $results) {
            $r.PSObject.Properties.Remove('RunspaceId')
            $r | Add-Member -NotePropertyName Server -NotePropertyValue $server
        }

        $allResults += $results
    } catch {
        Write-Host "Error connecting to $server : $_" -ForegroundColor Red
    }
}

# Output to screen
$allResults | Select-Object Server, TaskName, Folder, RunAsUser | Format-Table -AutoSize

# Export to CSV
$exportPath = 'C:\temp\powershell-exports\server-tasks.csv'
$allResults | Select-Object Server, TaskName, Folder, RunAsUser |
Export-Csv -Path $exportPath -NoTypeInformation

Write-Host "`nExport complete : $exportPath" -ForegroundColor Green
notepad $exportpath

# Revision : 1.1
# Description : Remotely enables RemoteRegistry service and key firewall rules, with interactive computer name prompt
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-07-08
# Modified Date : 2025-07-08

param (
    [string]$ComputerName
)

# Prompt for computer name if not supplied
if (-not $ComputerName) {
    $ComputerName = Read-Host "Enter the target computer name"
}

# Check if the computer is online
if (-not (Test-Connection -ComputerName $ComputerName -Count 2 -Quiet)) {
    Write-Host "❌ $ComputerName is not reachable over the network." -ForegroundColor Red
    return
}

Write-Host "✅ $ComputerName is reachable. Attempting remote configuration..." -ForegroundColor Green

Invoke-Command -ComputerName $ComputerName -ScriptBlock {
    try {
        # Enable and start Remote Registry service
        Set-Service -Name "RemoteRegistry" -StartupType Automatic
        Start-Service -Name "RemoteRegistry"
        Write-Host "✅ RemoteRegistry service started and set to automatic."

        # Enable specific firewall rules instead of DisplayGroup
        $rules = @(
            'Remote Registry (RPC)',
            'Remote Administration (RPC)',
            'Remote Administration (RPC-EPMAP)',
            'Windows Management Instrumentation (WMI-In)',
            'Windows Remote Management (HTTP-In)'
        )

        foreach ($rule in $rules) {
            try {
                Enable-NetFirewallRule -DisplayName $rule -ErrorAction SilentlyContinue
                Write-Host "✅ Enabled firewall rule : $rule"
            } catch {
                Write-Host "⚠️ Could not enable firewall rule : $rule — $_"
            }
        }

        # Confirm service status
        $svc = Get-Service -Name "RemoteRegistry"
        Write-Host "🔍 RemoteRegistry status : $($svc.Status), StartType : $($svc.StartType)"

    } catch {
        Write-Host "❌ Failed to configure remote settings : $_" -ForegroundColor Red
    }
} -ErrorAction Stop -Credential (Get-Credential -Message "Enter admin credentials for $ComputerName")

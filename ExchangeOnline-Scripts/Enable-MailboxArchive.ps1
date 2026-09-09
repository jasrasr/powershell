<#
Filename:    Enable-MailboxArchive.ps1
Revision:    1.1.0
Description: Enables the online archive mailbox (and optionally auto-expanding
             archive) for one or more Exchange Online mailboxes. Auto-expanding
             archive is EXO-PowerShell-only -- there is no EAC toggle for it.
Author:      Jason Lamb with help from Claude Code
Created:     2026-09-09
Modified:    2026-09-09
Changelog:
  1.0.0 - Initial version
  1.1.0 - Auto install/import ExchangeOnlineManagement and connect if needed
          (does not disconnect on completion)
#>

[CmdletBinding()]
param(
    # One or more UPNs/SMTP addresses. If omitted, run with -All to target
    # every mailbox that doesn't already have an archive enabled.
    [string[]]$Identity,

    # Target every mailbox org-wide (or filtered by -DomainFilter) that has
    # ArchiveStatus -eq "None".
    [switch]$All,

    # Restrict -All to a specific SMTP domain, e.g. domain.com
    [string]$DomainFilter,

    # Also enable auto-expanding archive (grows 100 GB -> 1.5 TB over time).
    # Cannot be disabled once turned on -- confirm before using in bulk.
    [switch]$AutoExpanding,

    [switch]$WhatIf
)

$logPath = Join-Path $PSExports "Enable-MailboxArchive_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

function Write-Log {
    param([string]$Message)
    $line = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $Message"
    Write-Host $line
    Add-Content -Path $logPath -Value $line
}

# Module check and import
foreach ($module in @("ExchangeOnlineManagement")) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Log "Installing $module..."
        Install-Module $module -Scope CurrentUser -Force
    }
    if (-not (Get-Module -Name $module)) {
        Write-Log "Importing $module..."
        Import-Module $module
    }
}

# Connect to Exchange Online only if not already connected
$exoConnection = Get-ConnectionInformation -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $exoConnection) {
    Write-Log "NOTE: Authenticate with your Exchange Online admin account."
    Connect-ExchangeOnline -Device -ShowBanner:$false
    $exoConnection = Get-ConnectionInformation -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $exoConnection) {
        Write-Log "ERROR: Failed to connect to Exchange Online."
        return
    }
}
Write-Log "Connected as: $($exoConnection.UserPrincipalName)"

# Build target mailbox list
if ($All) {
    $filter = { ArchiveStatus -eq "None" -and RecipientTypeDetails -eq "UserMailbox" }
    $mailboxes = Get-Mailbox -ResultSize Unlimited -Filter $filter
    if ($DomainFilter) {
        $mailboxes = $mailboxes | Where-Object { $_.PrimarySmtpAddress -like "*@$DomainFilter" }
    }
} elseif ($Identity) {
    $mailboxes = $Identity | ForEach-Object { Get-Mailbox -Identity $_ -ErrorAction SilentlyContinue }
} else {
    Write-Log "ERROR: Provide -Identity <one or more addresses> or -All."
    return
}

if (-not $mailboxes) {
    Write-Log "No matching mailboxes found. Nothing to do."
    return
}

Write-Log "Targeting $($mailboxes.Count) mailbox(es)."

foreach ($mbx in $mailboxes) {
    $upn = $mbx.PrimarySmtpAddress

    if ($mbx.ArchiveStatus -ne "None") {
        Write-Log "SKIP  ${upn}: archive already enabled (status: $($mbx.ArchiveStatus))."
        continue
    }

    if ($WhatIf) {
        Write-Log "WHATIF: would enable archive for ${upn}."
        continue
    }

    try {
        Enable-Mailbox -Identity $mbx.Identity -Archive -ErrorAction Stop
        Write-Log "OK    ${upn}: archive enabled."
    } catch {
        Write-Log "FAIL  ${upn}: $($_.Exception.Message)"
        continue
    }

    if ($AutoExpanding) {
        try {
            Enable-Mailbox -Identity $mbx.Identity -AutoExpandingArchive -ErrorAction Stop
            Write-Log "OK    ${upn}: auto-expanding archive enabled (cannot be reversed)."
        } catch {
            Write-Log "FAIL  ${upn}: auto-expanding archive failed -- $($_.Exception.Message)"
        }
    }
}

Write-Log "Done. Log written to $logPath"
Write-Log "NOTE: Auto-expanding archive provisioning can take up to 30 days to complete."

<#
Example usage:

  # Single user, archive only
  .\Enable-MailboxArchive.ps1 -Identity user@domain.com

  # Single user, archive + auto-expanding
  .\Enable-MailboxArchive.ps1 -Identity user@domain.com -AutoExpanding

  # Every domain.com mailbox without an archive, dry run first
  .\Enable-MailboxArchive.ps1 -All -DomainFilter domain.com -WhatIf
  .\Enable-MailboxArchive.ps1 -All -DomainFilter domain.com -AutoExpanding
#>

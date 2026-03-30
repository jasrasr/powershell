# Revision    : 2.3
# Description : Create shared mailboxes in Exchange Online from a CSV file.
# Author      : Jason Lamb
# Created Date: 2026-03-26
# Modified Date: 2026-03-26
#
# Changelog:
#   1.0 - Initial release
#   1.1 - Adjusted for CSV format: Name, Email, GAL?, Customer Facing?, Members
#         Alias derived from email; Members resolved by display name; GAL visibility applied
#   1.2 - Customer Facing? now sets RequireSenderAuthenticationEnabled:
#         Y = allow external senders, N = require authenticated (internal) senders only
#   1.3 - Default delimiter changed to comma (Excel CSV default)
#   1.4 - Added EXO connection check; connects if not already connected, no disconnect on exit
#   1.5 - Added logging to $psexports with datetime-stamped log file; console output preserved with colors
#   1.6 - Member resolution restricted to UserMailbox only; MailUser/MailContact skipped with error
#   1.7 - Added missing -Name parameter to New-Mailbox call
#   1.8 - Set EmailAddresses explicitly after creation to remove auto-added tenant domain aliases (EXO only, no EmailAddressPolicyEnabled)
#   1.9 - Change MicrosoftOnlineServicesID (WindowsLiveId/UPN) to desired address before stripping aliases
#   2.0 - On proxy address conflict, automatically retry creation using a temp address
#         (temp-XXXXXX-alias@domain) then reassign real address as primary and remove temp
#   2.1 - Check existing permissions before adding; skip with friendly message instead of EXO SID warning
#   2.2 - Fix temp address workaround: set UPN to real address before stripping aliases so temp is fully removed
#   2.3 - Member lookup falls back to last-name wildcard search if exact display name finds no UserMailbox
#
# CSV Format (comma-delimited, Excel default, headers required):
#   Name             - Display name of the shared mailbox (required)
#   Email            - Primary SMTP address (required); alias derived from local part
#   GAL?             - Y = visible in GAL, N = hidden from GAL (required)
#   Customer Facing? - Y = allow external senders; N = require sender authentication (internal only)
#   Members          - Semicolon-separated display names to grant FullAccess + SendAs (optional)
#
# Example CSV:
#   Name,Email,GAL?,Customer Facing?,Members
#   Support Team,support@domain.com,Y,Y,John Smith;Jane Doe
#   HR Team,hr@domain.com,N,N,
#
# Usage:
#   .\create-shared-mailboxes-from-csv.ps1 -CsvPath "C:\path\to\mailboxes.csv"
#   .\create-shared-mailboxes-from-csv.ps1 -CsvPath "C:\path\to\mailboxes.csv" -WhatIf

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [ValidateScript({ Test-Path $_ -PathType Leaf })]
    [string]$CsvPath,

    [string]$Delimiter = ","
)

#region Logging setup

$datetime = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'
$logDir   = if ($psexports) { $psexports } else { $env:TEMP }
$logPath  = Join-Path $logDir "create-shared-mailboxes_$datetime.log"

function Write-Log {
    param([string]$Message)
    $Message | Add-Content -Path $logPath -Encoding UTF8
}

#endregion

#region Helpers

function Write-Status {
    param([string]$Message, [string]$Color = 'Cyan')
    Write-Host $Message -ForegroundColor $Color
    Write-Log $Message
}

function Write-Success {
    param([string]$Message)
    Write-Host "  [OK]  $Message" -ForegroundColor Green
    Write-Log "  [OK]  $Message"
}

function Write-Failure {
    param([string]$Message)
    Write-Host "  [ERR] $Message" -ForegroundColor Red
    Write-Log "  [ERR] $Message"
}

function Write-Skip {
    param([string]$Message)
    Write-Host "  [SKIP] $Message" -ForegroundColor DarkYellow
    Write-Log "  [SKIP] $Message"
}

#endregion

Write-Log "=== create-shared-mailboxes-from-csv.ps1 ==="
Write-Log "Run started : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Write-Log "CSV         : $CsvPath"
Write-Log "Log file    : $logPath"
Write-Log ""

#region Exchange Online connection

if (-not (Get-ConnectionInformation -ErrorAction SilentlyContinue)) {
    Write-Status "Not connected to Exchange Online — connecting..."
    Connect-ExchangeOnline -ShowBanner:$false
}
else {
    Write-Status "Already connected to Exchange Online."
}

#endregion

#region Validate CSV

$rows = Import-Csv -Path $CsvPath -Delimiter $Delimiter

$requiredHeaders = @('Name', 'Email', 'GAL?', 'Customer Facing?')
$actualHeaders   = $rows[0].PSObject.Properties.Name

foreach ($header in $requiredHeaders) {
    if ($header -notin $actualHeaders) {
        Write-Error "CSV is missing required column: $header"
        exit 1
    }
}

Write-Status "Loaded $($rows.Count) row(s) from $CsvPath"

#endregion

#region Summary table

$summary = [System.Collections.Generic.List[PSCustomObject]]::new()

#endregion

#region Process each row

foreach ($row in $rows) {
    $displayName     = $row.Name.Trim()
    $smtp            = $row.Email.Trim()
    $galFlag         = $row.'GAL?'.Trim().ToUpper()
    $customerFacing  = $row.'Customer Facing?'.Trim().ToUpper()
    $membersRaw      = if ($row.PSObject.Properties['Members']) { $row.Members } else { '' }
    $memberNames     = @($membersRaw -split ';' | Where-Object { $_ -ne '' } | ForEach-Object { $_.Trim() })

    # Derive alias from the local part of the email address, strip invalid chars
    $alias = ($smtp -split '@')[0] -replace '[^a-zA-Z0-9.\-_]', ''

    $hideFromGal        = ($galFlag -ne 'Y')
    # Customer Facing? Y = allow external senders (RequireSenderAuth = false)
    # Customer Facing? N = internal/authenticated senders only (RequireSenderAuth = true)
    $requireSenderAuth  = ($customerFacing -ne 'Y')

    Write-Status "`nProcessing: $displayName <$smtp>"

    $result = [PSCustomObject]@{
        Name             = $displayName
        Email            = $smtp
        GAL              = $galFlag
        CustomerFacing   = $customerFacing
        MailboxCreated   = $false
        GALUpdated       = $false
        SenderAuthSet    = $false
        MembersAdded     = 0
        MembersFailed    = 0
        Error            = ''
    }

    # --- Create mailbox ---
    try {
        $existing = Get-Mailbox -Identity $smtp -ErrorAction SilentlyContinue
        if ($existing) {
            Write-Skip "Mailbox already exists — skipping creation."
            $result.Error = 'Already exists'
        }
        else {
            if ($PSCmdlet.ShouldProcess($smtp, 'New-Mailbox (Shared)')) {
                $localPart  = ($smtp -split '@')[0]
                $domain     = ($smtp -split '@')[1]
                $createSmtp = $smtp
                $createAlias = $alias
                $usedTemp   = $false

                try {
                    New-Mailbox `
                        -Shared `
                        -Name $displayName `
                        -DisplayName $displayName `
                        -Alias $createAlias `
                        -PrimarySmtpAddress $createSmtp `
                        -ErrorAction Stop | Out-Null
                }
                catch {
                    if ($_ -match 'proxy address') {
                        # Proxy conflict — retry with a temp address to bypass the auto-alias collision
                        $randomStr   = -join ((48..57) + (97..122) | Get-Random -Count 6 | ForEach-Object { [char]$_ })
                        $createSmtp  = "temp-$randomStr-$localPart@$domain"
                        $createAlias = "temp$randomStr$alias"
                        $usedTemp    = $true

                        Write-Skip "Proxy conflict — retrying with temp address: $createSmtp"

                        New-Mailbox `
                            -Shared `
                            -Name $displayName `
                            -DisplayName $displayName `
                            -Alias $createAlias `
                            -PrimarySmtpAddress $createSmtp `
                            -ErrorAction Stop | Out-Null
                    }
                    else {
                        throw
                    }
                }

                # Change the WindowsLiveId/UPN to the real address so the temp can be removed
                Set-Mailbox -Identity $createSmtp -MicrosoftOnlineServicesID $smtp -ErrorAction Stop
                # Set only the desired real address, removing temp and any auto-added tenant domain aliases
                Set-Mailbox -Identity $smtp -EmailAddresses "SMTP:$smtp" -ErrorAction Stop

                if ($usedTemp) {
                    Write-Success "Created shared mailbox via temp address — real address assigned: $smtp"
                }
                else {
                    Write-Success "Created shared mailbox: $smtp"
                }
                $result.MailboxCreated = $true
            }
        }
    }
    catch {
        Write-Failure "Failed to create mailbox: $_"
        $result.Error = $_.Exception.Message
        $summary.Add($result)
        continue
    }

    # --- Apply GAL visibility ---
    try {
        if ($PSCmdlet.ShouldProcess($smtp, "Set-Mailbox HiddenFromAddressListsEnabled=$hideFromGal")) {
            Set-Mailbox -Identity $smtp -HiddenFromAddressListsEnabled $hideFromGal -ErrorAction Stop
            $label = if ($hideFromGal) { 'Hidden from GAL' } else { 'Visible in GAL' }
            Write-Success $label
            $result.GALUpdated = $true
        }
    }
    catch {
        Write-Failure "Failed to set GAL visibility: $_"
        $result.Error += " | GAL: $($_.Exception.Message)"
    }

    # --- Apply sender authentication requirement ---
    try {
        if ($PSCmdlet.ShouldProcess($smtp, "Set-Mailbox RequireSenderAuthenticationEnabled=$requireSenderAuth")) {
            Set-Mailbox -Identity $smtp -RequireSenderAuthenticationEnabled $requireSenderAuth -ErrorAction Stop
            $label = if ($requireSenderAuth) { 'Sender auth required (internal only)' } else { 'External senders allowed' }
            Write-Success $label
            $result.SenderAuthSet = $true
        }
    }
    catch {
        Write-Failure "Failed to set sender authentication: $_"
        $result.Error += " | SenderAuth: $($_.Exception.Message)"
    }

    # --- Resolve members by display name and grant permissions ---
    foreach ($memberName in $memberNames) {
        try {
            $recipient = Get-Recipient -Filter "DisplayName -eq '$memberName'" -ErrorAction Stop |
                         Where-Object { $_.RecipientType -eq 'UserMailbox' } |
                         Select-Object -First 1

            if (-not $recipient) {
                # Fallback: search by exact last name match in case of nickname mismatch (e.g. "Dave" vs "David")
                # Uses wildcard to find candidates, then filters to exact last-name match to avoid substring collisions
                $lastName  = $memberName.Split(' ')[-1]
                $fallback  = Get-Recipient -Filter "DisplayName -like '*$lastName*'" -ErrorAction Stop |
                             Where-Object { $_.RecipientType -eq 'UserMailbox' -and $_.DisplayName.Split(' ')[-1] -eq $lastName }
                if ($fallback.Count -eq 1) {
                    $recipient = $fallback[0]
                    Write-Skip "No exact match for '$memberName' — using '$($recipient.DisplayName)' ($($recipient.PrimarySmtpAddress)) by last name"
                }
                elseif ($fallback.Count -gt 1) {
                    Write-Failure "Ambiguous last name match for '$memberName' — multiple UserMailboxes found, skipping. Update CSV with exact display name:"
                    $fallback | ForEach-Object { Write-Failure "  -> $($_.DisplayName) ($($_.PrimarySmtpAddress))" }
                    $result.MembersFailed++
                    continue
                }
                else {
                    Write-Failure "Could not resolve '$memberName' as a UserMailbox — MailUser/MailContact skipped"
                    $result.MembersFailed++
                    continue
                }
            }

            $memberIdentity = $recipient.PrimarySmtpAddress

            $hasFullAccess = Get-MailboxPermission -Identity $smtp -User $memberIdentity -ErrorAction SilentlyContinue |
                             Where-Object { $_.AccessRights -contains 'FullAccess' -and -not $_.Deny }
            $hasSendAs     = Get-RecipientPermission -Identity $smtp -Trustee $memberIdentity -ErrorAction SilentlyContinue |
                             Where-Object { $_.AccessRights -contains 'SendAs' }

            if ($hasFullAccess -and $hasSendAs) {
                Write-Skip "Permissions already set for $memberName ($memberIdentity) — skipping"
                $result.MembersAdded++
                continue
            }

            if (-not $hasFullAccess) {
                if ($PSCmdlet.ShouldProcess($smtp, "Add-MailboxPermission FullAccess for $memberName")) {
                    Add-MailboxPermission `
                        -Identity $smtp `
                        -User $memberIdentity `
                        -AccessRights FullAccess `
                        -InheritanceType All `
                        -AutoMapping $true `
                        -ErrorAction Stop | Out-Null
                }
            }

            if (-not $hasSendAs) {
                if ($PSCmdlet.ShouldProcess($smtp, "Add-RecipientPermission SendAs for $memberName")) {
                    Add-RecipientPermission `
                        -Identity $smtp `
                        -Trustee $memberIdentity `
                        -AccessRights SendAs `
                        -Confirm:$false `
                        -ErrorAction Stop | Out-Null
                }
            }

            Write-Success "Granted FullAccess + SendAs to $memberName ($memberIdentity)"
            $result.MembersAdded++
        }
        catch {
            Write-Failure "Failed to grant permissions to $memberName : $_"
            $result.MembersFailed++
        }
    }

    $summary.Add($result)
}

#endregion

#region Results

Write-Status "`n--- Summary ---" 'White'

$summaryText = $summary | Format-Table -AutoSize | Out-String
Write-Host $summaryText
Write-Log $summaryText

$csvSummaryPath = Join-Path $logDir "create-shared-mailboxes_$datetime.csv"
$summary | Export-Csv -Path $csvSummaryPath -NoTypeInformation -Encoding UTF8

$created = ($summary | Where-Object { $_.MailboxCreated }).Count
$skipped = ($summary | Where-Object { $_.Error -eq 'Already exists' }).Count
$failed  = ($summary | Where-Object { $_.Error -ne '' -and $_.Error -ne 'Already exists' }).Count

Write-Status "Mailboxes created : $created" 'Green'
if ($skipped -gt 0) { Write-Status "Mailboxes skipped : $skipped (already existed)" 'DarkYellow' }
if ($failed  -gt 0) { Write-Status "Mailboxes failed  : $failed" 'Red' }

Write-Log ""
Write-Log "Run completed : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Write-Status "`nLog file : $logPath" 'Gray'
Write-Status "CSV summary : $csvSummaryPath" 'Gray'

#endregion

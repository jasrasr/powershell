# Revision : 1.4
# Description : Get Deleted Items size for a mailbox (Primary + Archive), robust against EXO deserialization. Rev 1.4
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-10-08
# Modified Date : 2025-10-08

param(
    [string]$MailboxIdentity = 'paula.stoneman@middough.com'
)

function Convert-ToBytes {
    param([Parameter(Mandatory)][object]$BQSize)
    try {
        if ($BQSize.Value -and ($BQSize.Value | Get-Member -Name ToBytes -MemberType Method)) {
            return [int64]$BQSize.Value.ToBytes()
        }
    } catch { }

    $txt = $BQSize.ToString()
    $m = [regex]::Match($txt, '\((?<bytes>[0-9,]+)\s+bytes\)')
    if ($m.Success) { return [int64]($m.Groups['bytes'].Value -replace ',','') }

    $mu = [regex]::Match($txt, '^(?<val>\d+(\.\d+)?)\s*(?<unit>KB|MB|GB|TB)', 'IgnoreCase')
    if (-not $mu.Success) { throw "Unable to parse size from '$txt'" }
    $val  = [double]$mu.Groups['val'].Value
    switch ($mu.Groups['unit'].Value.ToUpperInvariant()) {
        'KB' { return [int64]($val * 1KB) }
        'MB' { return [int64]($val * 1MB) }
        'GB' { return [int64]($val * 1GB) }
        'TB' { return [int64]($val * 1TB) }
    }
}

# NOTE: You said you're already connected to EXO. We won't Import-Module or Connect-ExchangeOnline here.

try {
    # Keep each pipeline on ONE line to avoid accidental word-wrap issues like 'erAndSubfolderSize'
    $deletedPrimary = Get-MailboxFolderStatistics -Identity $MailboxIdentity | Where-Object { $_.FolderType -eq 'DeletedItems' } | Select-Object FolderPath, FolderType, ItemsInFolderAndSubfolders, FolderAndSubfolderSize

    if ($deletedPrimary) {
        $bytes = Convert-ToBytes $deletedPrimary.FolderAndSubfolderSize
        $mb = [math]::Round($bytes / 1MB, 2)
        $gb = [math]::Round($bytes / 1GB, 2)
        Write-Host "Mailbox : $MailboxIdentity" -ForegroundColor Cyan
        Write-Host "Deleted Items (Primary) path : $($deletedPrimary.FolderPath)" -ForegroundColor Gray
        Write-Host "Deleted Items (Primary) size : $($deletedPrimary.FolderAndSubfolderSize)  [$mb MB | $gb GB]" -ForegroundColor Yellow
        Write-Host "Deleted Items (Primary) items : $($deletedPrimary.ItemsInFolderAndSubfolders)" -ForegroundColor Gray
    }
    else {
        Write-Host "Deleted Items (Primary) not found for $MailboxIdentity : checking Archive mailbox ..." -ForegroundColor DarkYellow
        $deletedArchive = Get-MailboxFolderStatistics -Identity $MailboxIdentity -Archive | Where-Object { $_.FolderType -eq 'DeletedItems' } | Select-Object FolderPath, FolderType, ItemsInFolderAndSubfolders, FolderAndSubfolderSize

        if ($deletedArchive) {
            $bytes = Convert-ToBytes $deletedArchive.FolderAndSubfolderSize
            $mb = [math]::Round($bytes / 1MB, 2)
            $gb = [math]::Round($bytes / 1GB, 2)
            Write-Host "Mailbox : $MailboxIdentity" -ForegroundColor Cyan
            Write-Host "Deleted Items (Archive) path : $($deletedArchive.FolderPath)" -ForegroundColor Gray
            Write-Host "Deleted Items (Archive) size : $($deletedArchive.FolderAndSubfolderSize)  [$mb MB | $gb GB]" -ForegroundColor Yellow
            Write-Host "Deleted Items (Archive) items : $($deletedArchive.ItemsInFolderAndSubfolders)" -ForegroundColor Gray
        }
        else {
            Write-Host "No Deleted Items folder found in Primary or Archive for $MailboxIdentity" -ForegroundColor Red
        }
    }
}
catch {
    Write-Host "Error while retrieving Deleted Items for $MailboxIdentity : $_" -ForegroundColor Red
}

# Optional: Uncomment to also show Recoverable Items (dumpster) sizes
# $recov = Get-MailboxFolderStatistics -Identity $MailboxIdentity -FolderScope RecoverableItems | Where-Object { $_.FolderPath -match '^\\Recoverable Items\\(Deletions|Purges|DiscoveryHolds)$' } | Select-Object FolderPath, ItemsInFolderAndSubfolders, FolderAndSubfolderSize
# foreach ($r in $recov) {
#     $b = Convert-ToBytes $r.FolderAndSubfolderSize
#     $g = [math]::Round($b / 1GB, 2)
#     Write-Host "Recoverable Items $($r.FolderPath) size : $($r.FolderAndSubfolderSize)  [$g GB]" -ForegroundColor DarkCyan
# }

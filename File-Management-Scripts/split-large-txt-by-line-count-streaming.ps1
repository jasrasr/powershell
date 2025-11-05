# Revision : 1.5
# Description : Stream-split a large TXT by line count with robust LOCAL STAGING for network paths (Egnyte/Panzura), retries, and heartbeats. Rev 1.5
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-09-25
# Modified Date : 2025-11-04

param(
    [Parameter(Mandatory = $true)]
    [string] $InputTxt,
    [Parameter(Mandatory = $true)]
    [string] $OutputFolder,
    [Parameter(Mandatory = $true)]
    [int] $LinesPerFile,
    [ValidateSet('Auto','Always','Never')]
    [string] $StageMode = 'Auto',           # Auto = stage if path is UNC or mapped drive; Always = always stage; Never = never stage
    [int] $Retries = 5,
    [int] $RetryDelaySec = 3
)

function Resolve-FullPath {
    param([string] $Path)
    try {
        return (Resolve-Path -LiteralPath $Path -ErrorAction Stop).Path
    } catch {
        $candidate = Join-Path -Path (Get-Location) -ChildPath $Path
        if (Test-Path -LiteralPath $candidate) {
            return (Resolve-Path -LiteralPath $candidate).Path
        } else {
            throw "Cannot resolve path $Path"
        }
    }
}

function Test-IsNetworkPath {
    param([string] $FullPath)
    if ($FullPath.StartsWith('\\')) { return $true }
    $qual = Split-Path -Path $FullPath -Qualifier
    if ($qual -and $qual -match '^[A-Za-z]:$') {
        $drive = Get-PSDrive -Name $qual.TrimEnd(':') -ErrorAction SilentlyContinue
        if ($drive -and $drive.DisplayRoot -and $drive.DisplayRoot.StartsWith('\\')) { return $true }
    }
    return $false
}

function Copy-WithRobocopy {
    param(
        [string] $SourceFile,
        [string] $DestFile
    )
    $srcDir  = Split-Path -Path $SourceFile -Parent
    $srcName = Split-Path -Path $SourceFile -Leaf
    $dstDir  = Split-Path -Path $DestFile -Parent

    if (-not (Test-Path -LiteralPath $dstDir)) {
        New-Item -ItemType Directory -Path $dstDir | Out-Null
    }

    $args = @(
        "`"$srcDir`"", "`"$dstDir`"", "`"$srcName`"",
        '/NFL','/NDL','/NJH','/NJS','/NP',
        '/R:3','/W:2','/Z','/J','/COPY:DAT'
    )
    $process = Start-Process -FilePath robocopy.exe -ArgumentList $args -NoNewWindow -PassThru -Wait

    return ($process.ExitCode -le 3)
}

function Copy-WithStream {
    param(
        [string] $SourceFile,
        [string] $DestFile
    )
    $dstDir = Split-Path -Path $DestFile -Parent
    if (-not (Test-Path -LiteralPath $dstDir)) {
        New-Item -ItemType Directory -Path $dstDir | Out-Null
    }

    try {
        $src = [System.IO.File]::Open($SourceFile,
            [System.IO.FileMode]::Open,
            [System.IO.FileAccess]::Read,
            [System.IO.FileShare]::ReadWrite)
        $dst = [System.IO.File]::Open($DestFile,
            [System.IO.FileMode]::Create,
            [System.IO.FileAccess]::Write,
            [System.IO.FileShare]::None)

        $buffer = New-Object byte[] 1048576
        while ($true) {
            $read = $src.Read($buffer, 0, $buffer.Length)
            if ($read -le 0) { break }
            $dst.Write($buffer, 0, $read)
        }
        return $true
    } catch {
        return $false
    } finally {
        if ($src) { $src.Close() }
        if ($dst) { $dst.Close() }
    }
}

function Open-TxtReader {
    param(
        [string] $Path,
        [int] $MaxRetries,
        [int] $DelaySec
    )
    $attempt = 0
    do {
        try {
            $fs = [System.IO.File]::Open($Path,
                [System.IO.FileMode]::Open,
                [System.IO.FileAccess]::Read,
                [System.IO.FileShare]::ReadWrite)
            $reader = [System.IO.StreamReader]::new($fs, [System.Text.Encoding]::UTF8, $true, 4096, $false)
            return $reader
        } catch {
            $attempt++
            if ($attempt -ge $MaxRetries) { throw }
            Write-Host "Open attempt $attempt failed for $Path : $($_.Exception.Message) ... retrying in $DelaySec sec" -ForegroundColor Yellow
            Start-Sleep -Seconds $DelaySec
        }
    } while ($true)
}

# --- Resolve and prepare paths ---
try { $InputTxtFull = Resolve-FullPath -Path $InputTxt } catch { Write-Host "Error resolving input $InputTxt : $($_.Exception.Message)" -ForegroundColor Red; exit 1 }
if (-not (Test-Path -LiteralPath $OutputFolder)) { New-Item -Path $OutputFolder -ItemType Directory | Out-Null }
$OutputFolderFull = (Resolve-Path -LiteralPath $OutputFolder).Path

if ($LinesPerFile -lt 1) { Write-Host "Invalid -LinesPerFile $LinesPerFile : must be >= 1" -ForegroundColor Red; exit 1 }

# --- Decide if staging needed ---
$needStage = $false
if ($StageMode -eq 'Always') { $needStage = $true }
elseif ($StageMode -eq 'Auto') {
    if (Test-IsNetworkPath -FullPath $InputTxtFull) { $needStage = $true }
}

$stageFile = $InputTxtFull
if ($needStage) {
    $stageDir = Join-Path $env:TEMP 'txt-split-staging'
    if (-not (Test-Path -LiteralPath $stageDir)) { New-Item -ItemType Directory -Path $stageDir | Out-Null }
    $stageFile = Join-Path $stageDir ([IO.Path]::GetFileName($InputTxtFull))

    Write-Host "Staging source to local temp $stageFile" -ForegroundColor DarkYellow
    $ok = Copy-WithRobocopy -SourceFile $InputTxtFull -DestFile $stageFile
    if (-not $ok) {
        Write-Host "Robocopy staging failed, attempting stream copy fallback..." -ForegroundColor Yellow
        $ok = Copy-WithStream -SourceFile $InputTxtFull -DestFile $stageFile
    }
    if (-not $ok) {
        Write-Host "Failed to stage local copy from $InputTxtFull : aborting" -ForegroundColor Red
        exit 1
    }
}

Write-Host "Input TXT        : $InputTxtFull" -ForegroundColor Cyan
if ($needStage) { Write-Host "Reading staged   : $stageFile" -ForegroundColor Cyan }
Write-Host "Output folder    : $OutputFolderFull" -ForegroundColor Cyan
Write-Host "Lines per file   : $LinesPerFile" -ForegroundColor Cyan

# --- Stream split process ---
$reader = $null
$outFile = $null
try {
    $reader = Open-TxtReader -Path $stageFile -MaxRetries $Retries -DelaySec $RetryDelaySec
    $chunkIndex = 1
    $lineCount = 0
    $totalLines = 0
    $sw = [System.Diagnostics.Stopwatch]::StartNew()

    while (($line = $reader.ReadLine()) -ne $null) {
        if ($lineCount -eq 0) {
            if ($outFile) { $outFile.Close() }
            $chunkFile = Join-Path $OutputFolderFull ("chunk_{0:D4}.txt" -f $chunkIndex)
            $outFile = [System.IO.StreamWriter]::new($chunkFile, $false, [System.Text.Encoding]::UTF8)
            Write-Host "Started $chunkFile" -ForegroundColor Yellow
            $chunkIndex++
        }

        $outFile.WriteLine($line)
        $lineCount++
        $totalLines++

        if ($lineCount -ge $LinesPerFile) {
            $outFile.Close()
            Write-Host "Completed chunk with $lineCount lines" -ForegroundColor Green
            $lineCount = 0
        }

        if (($totalLines % 100000) -eq 0) {
            Write-Host "Processed $totalLines lines so far..." -ForegroundColor DarkCyan
        }
    }

    if ($outFile) {
        $outFile.Close()
        if ($lineCount -gt 0) {
            Write-Host "Final chunk completed with $lineCount lines" -ForegroundColor Green
        }
    }

    $sw.Stop()
    $filesCreated = $chunkIndex - 1
    Write-Host "Finished splitting $stageFile into $filesCreated files in $([math]::Round($sw.Elapsed.TotalSeconds,2)) seconds" -ForegroundColor Cyan
    Write-Host "Total lines processed : $totalLines" -ForegroundColor Cyan
}
catch {
    Write-Host "Fatal error during split : $($_.Exception.Message)" -ForegroundColor Red
}
finally {
    if ($reader) { $reader.Close() }
}

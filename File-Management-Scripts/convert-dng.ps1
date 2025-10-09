# Revision : 1.3
# Description : Fix dcraw_emu invocation (no “--”), set working dir for output, convert DNG → 16-bit TIFF → JPG via ImageMagick. Adds single-file smoke test + bulk conversion. Rev 1.3
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-10-07
# Modified Date : 2025-10-07

# --- CONFIG ---
$DcrawPath    = 'C:\Users\jason.lamb\OneDrive - middough\Downloads\LibRaw-0.21.4-Win64\LibRaw-0.21.4\bin\dcraw_emu.exe'
$MagickCmd    = 'magick'
$InputFolder  = 'X:\Shared\Documents\CLE Office Photo Upload'
$OutputFolder = 'Converted'
$WorkDir      = 'C:\temp\dng-work'
$JpegQuality  = 92
$LogDir       = 'C:\temp\powershell-exports'
New-Item -ItemType Directory -Path $WorkDir,$LogDir -Force | Out-Null
$LogPath      = Join-Path $LogDir ("dng-convert-" + (Get-Date -Format 'yyyyMMdd-HHmmss') + ".log")

# --- SANITY ---
if (-not (Test-Path -LiteralPath $DcrawPath)) { Write-Host "dcraw_emu not found at $DcrawPath" -ForegroundColor Red; return }
if (-not (Get-Command $MagickCmd -ErrorAction SilentlyContinue)) { Write-Host "ImageMagick 'magick' not found on PATH" -ForegroundColor Red; return }
if (-not (Test-Path -LiteralPath $InputFolder)) { Write-Host "Input folder not found : $InputFolder" -ForegroundColor Red; return }

# --- SINGLE-FILE SMOKE TEST (first DNG found) ---
$testDng = Get-ChildItem -LiteralPath $InputFolder -Filter *.dng -File | Select-Object -First 1
if ($null -eq $testDng) { Write-Host "No DNG files found in $InputFolder" -ForegroundColor Yellow; return }

$baseName = [IO.Path]::GetFileNameWithoutExtension($testDng.Name)
$tif1     = Join-Path $WorkDir "$baseName.tiff"
$tif2     = Join-Path $WorkDir "$baseName.tif"

Write-Host "Smoke test on $($testDng.FullName) ..." -ForegroundColor Cyan
# IMPORTANT: No “--”. Some builds reject it. Quote the input and set WorkingDirectory for output.
Start-Process -FilePath $DcrawPath -ArgumentList @('-w','-T','-6',"`"$($testDng.FullName)`"") -WorkingDirectory $WorkDir -NoNewWindow -Wait

$outTif = if (Test-Path -LiteralPath $tif1) { $tif1 } elseif (Test-Path -LiteralPath $tif2) { $tif2 } else { $null }
if ($null -eq $outTif) { Write-Host "dcraw_emu did not produce a TIFF in $WorkDir" -ForegroundColor Red; return }

Write-Host "Created TIFF : $outTif" -ForegroundColor Green
$jpgSmoke = [IO.Path]::ChangeExtension($outTif,'jpg')
& $MagickCmd "$outTif" -quality $JpegQuality "$jpgSmoke"
if (-not (Test-Path -LiteralPath $jpgSmoke)) { Write-Host "Magick failed converting $outTif to JPG" -ForegroundColor Red; return }
Write-Host "Created JPG : $jpgSmoke" -ForegroundColor Green

# --- BULK CONVERSION (dcraw_emu -> TIFF, then Magick -> target), mirrors subfolders under OutputFolder ---
$OutRoot = Join-Path -LiteralPath $InputFolder -ChildPath $OutputFolder
New-Item -ItemType Directory -Path $OutRoot -Force | Out-Null

$allDng = Get-ChildItem -LiteralPath $InputFolder -Filter *.dng -File -Recurse
$total  = $allDng.Count
$idx    = 0
$ok     = 0
$fail   = 0

Write-Host "Found $total DNG files in $InputFolder" -ForegroundColor Cyan
Write-Host "Output folder : $OutRoot" -ForegroundColor Cyan
Write-Host "Log file      : $LogPath" -ForegroundColor Cyan

foreach ($f in $allDng) {
    $idx++
    $pct = [int](($idx/$total)*100)
    Write-Progress -Activity "Converting DNG files" -Status "$idx of $total : $($f.Name)" -PercentComplete $pct

    # Mirror subfolders under OutputFolder
    $rel     = $f.FullName.Substring($InputFolder.Length).TrimStart('\','/')
    $destDir = Join-Path -LiteralPath $OutRoot -ChildPath ([IO.Path]::GetDirectoryName($rel))
    New-Item -ItemType Directory -Path $destDir -Force | Out-Null

    $name    = [IO.Path]::GetFileNameWithoutExtension($f.Name)
    $tempTif = Join-Path $WorkDir "$name.tiff"
    if (Test-Path -LiteralPath $tempTif) { Remove-Item -LiteralPath $tempTif -Force -ErrorAction SilentlyContinue }

    $outJpg  = Join-Path -LiteralPath $destDir "$name.jpg"

    try {
        # Decode to TIFF (again: no “--”)
        Start-Process -FilePath $DcrawPath -ArgumentList @('-w','-T','-6',"`"$($f.FullName)`"") -WorkingDirectory $WorkDir -NoNewWindow -Wait

        # Some builds output .tif instead of .tiff; detect both
        $tempTif = if (Test-Path -LiteralPath (Join-Path $WorkDir "$name.tiff")) { Join-Path $WorkDir "$name.tiff" }
                   elseif (Test-Path -LiteralPath (Join-Path $WorkDir "$name.tif")) { Join-Path $WorkDir "$name.tif" }
                   else { $null }

        if ($null -eq $tempTif) { throw "Decoder did not produce TIFF in $WorkDir" }

        # Convert TIFF -> JPG
        & $MagickCmd "$tempTif" -quality $JpegQuality "$outJpg"
        if (-not (Test-Path -LiteralPath $outJpg)) { throw "Magick failed to create $outJpg" }

        Write-Host "Success : $($f.Name) → jpg" -ForegroundColor Green
        "$([DateTime]::Now) | OK | $($f.FullName) -> $outJpg" | Out-File -FilePath $LogPath -Append -Encoding UTF8
        $ok++

        # Cleanup temp
        Remove-Item -LiteralPath $tempTif -Force -ErrorAction SilentlyContinue
    }
    catch {
        Write-Host "Error on $($f.Name) : $_" -ForegroundColor Red
        "$([DateTime]::Now) | FAIL | $($f.FullName) | $_" | Out-File -FilePath $LogPath -Append -Encoding UTF8
        $fail++
    }
}

Write-Progress -Activity "Converting DNG files" -Completed
Write-Host "Done. Converted $ok of $total. Errors : $fail" -ForegroundColor Cyan
Write-Host "Output folder : $OutRoot" -ForegroundColor Cyan
Write-Host "Log file      : $LogPath" -ForegroundColor Cyan

# Filename: generate-ppt.ps1
# Revision : 1.0.1
# Description : Creates a PowerPoint slideshow from a folder of images, one image per slide, centered and scaled to fit 16:9
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-04-26
# Modified Date : 2026-04-26
# Changelog :
# 1.0.0 initial release
# 1.0.1 fix MsoTriState enum not available in PowerShell 7 — replaced with raw integer values (-1/0)

param(
    [Parameter(Mandatory)]
    [string]$PhotoFolder,

    [string]$OutputPath = "$env:USERPROFILE\Desktop\PhotoSlides.pptx"
)

$validExtensions = @(".jpg", ".jpeg", ".png", ".bmp", ".gif")

$photos = Get-ChildItem -Path $PhotoFolder -File |
    Where-Object { $validExtensions -contains $_.Extension.ToLower() } |
    Sort-Object Name

if (-not $photos) {
    Write-Error "No image files found in $PhotoFolder"
    exit
}

$powerPoint = New-Object -ComObject PowerPoint.Application
$powerPoint.Visible = -1  # msoTrue

$presentation = $powerPoint.Presentations.Add()

# 16:9 widescreen
$presentation.PageSetup.SlideWidth = 13.333 * 72
$presentation.PageSetup.SlideHeight = 7.5 * 72

$slideWidth = $presentation.PageSetup.SlideWidth
$slideHeight = $presentation.PageSetup.SlideHeight

foreach ($photo in $photos) {
    $slide = $presentation.Slides.Add($presentation.Slides.Count + 1, 12) # 12 = blank slide

    $picture = $slide.Shapes.AddPicture(
        $photo.FullName,
        0,   # msoFalse - don't link
        -1,  # msoTrue  - save with document
        0,
        0
    )

    # Scale image to fit slide while preserving aspect ratio
    $picture.LockAspectRatio = -1  # msoTrue

    $widthRatio = $slideWidth / $picture.Width
    $heightRatio = $slideHeight / $picture.Height
    $scaleRatio = [Math]::Min($widthRatio, $heightRatio)

    $picture.Width = $picture.Width * $scaleRatio
    $picture.Height = $picture.Height * $scaleRatio

    # Center image
    $picture.Left = ($slideWidth - $picture.Width) / 2
    $picture.Top = ($slideHeight - $picture.Height) / 2
}

$presentation.SaveAs($OutputPath)
$presentation.Close()
$powerPoint.Quit()

Write-Host "PowerPoint created: $OutputPath" -ForegroundColor Green

# Example Usage:
#   .\generate-ppt.ps1 -PhotoFolder "C:\Photos\Vacation"
#   .\generate-ppt.ps1 -PhotoFolder "C:\Photos\Vacation" -OutputPath "C:\Output\VacationSlides.pptx"

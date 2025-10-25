# Revision #3
# ps v7+ compatible

# Revision #3

Add-Type -AssemblyName System.Drawing

function Convert-PngToMultiResIco {
    param (
        [Parameter(Mandatory)]
        [string]$PngPath,

        [string]$IcoPath = "$(Join-Path (Split-Path $PngPath) "$([System.IO.Path]::GetFileNameWithoutExtension($PngPath)).ico")"
    )

    $iconSizes = @(16, 32, 48, 256)
    $images = @()

    try {
        if (-not (Test-Path $PngPath)) {
            Write-Host "PNG not found : $PngPath"
            return
        }

        $baseImage = [System.Drawing.Image]::FromFile($PngPath)

        foreach ($size in $iconSizes) {
            $bmp = New-Object System.Drawing.Bitmap $size, $size
            $g = [System.Drawing.Graphics]::FromImage($bmp)
            $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
            $g.DrawImage($baseImage, 0, 0, $size, $size)
            $g.Dispose()

            $ms = New-Object System.IO.MemoryStream
            $bmp.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png)
            $images += $ms.ToArray()
            $bmp.Dispose()
        }

        $icoStream = New-Object System.IO.MemoryStream
        $writer = New-Object System.IO.BinaryWriter $icoStream

        $writer.Write([UInt16]0)     # Reserved
        $writer.Write([UInt16]1)     # Type
        $writer.Write([UInt16]$images.Count)  # Count

        $offset = 6 + ($images.Count * 16)

        for ($i = 0; $i -lt $images.Count; $i++) {
            $width = $iconSizes[$i]
            $writer.Write([Byte]($width -band 0xFF))  # width
            $writer.Write([Byte]($width -band 0xFF))  # height
            $writer.Write([Byte]0)   # colors
            $writer.Write([Byte]0)   # reserved
            $writer.Write([UInt16]0) # planes
            $writer.Write([UInt16]32) # bpp
            $writer.Write([UInt32]$images[$i].Length) # size
            $writer.Write([UInt32]$offset) # offset
            $offset += $images[$i].Length
        }

        foreach ($img in $images) {
            $writer.Write($img)
        }

        # ✅ This line replaces Set-Content -Encoding Byte
        [System.IO.File]::WriteAllBytes($IcoPath, $icoStream.ToArray())

        Write-Host "ICO created : $IcoPath"

    } catch {
        Write-Host "Error converting PNG to multi-res ICO : $_"
    } finally {
        if ($baseImage) { $baseImage.Dispose() }
        if ($writer) { $writer.Dispose() }
        if ($icoStream) { $icoStream.Dispose() }
    }
}


Convert-PngToMultiResIco -PngPath "C:\Users\jason.lamb\OneDrive - ${domain}\Documents\GitHub\PowerShell\HEIC-Convert-To-JPG\icon.png"


<#
$pngPath = "C:\Users\jason.lamb\OneDrive - ${domain}\Documents\GitHub\PowerShell\HEIC-Convert-To-JPG\icon.png"

if (Test-Path $pngPath) {
    Write-Host "✅ File exists : $pngPath"
} else {
    Write-Host "❌ PNG not found : $pngPath"
}
#>
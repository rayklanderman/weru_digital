# PowerShell script to create properly sized app icons
# Run this script from the project root directory

Write-Host "Creating properly sized app icons for Android..."

# Define the required sizes for each density
$iconSizes = @{
    "mipmap-mdpi" = 48
    "mipmap-hdpi" = 72
    "mipmap-xhdpi" = 96
    "mipmap-xxhdpi" = 144
    "mipmap-xxxhdpi" = 192
}

# Source image path
$sourceImage = "assets\images\radio_logo.png"
$projectRoot = Split-Path -Parent $PSScriptRoot

# Check if source image exists
if (-not (Test-Path (Join-Path $projectRoot $sourceImage))) {
    Write-Error "Source image not found: $sourceImage"
    exit 1
}

Write-Host "Source image found: $sourceImage"

# Function to resize image using .NET
function Resize-Image {
    param(
        [string]$InputPath,
        [string]$OutputPath,
        [int]$Width,
        [int]$Height
    )
    
    try {
        Add-Type -AssemblyName System.Drawing
        
        # Load the source image
        $srcImage = [System.Drawing.Image]::FromFile($InputPath)
        
        # Create a new bitmap with the target size
        $destImage = New-Object System.Drawing.Bitmap $Width, $Height
        
        # Create graphics object for high-quality resizing
        $graphics = [System.Drawing.Graphics]::FromImage($destImage)
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
        $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
        
        # Draw the resized image
        $graphics.DrawImage($srcImage, 0, 0, $Width, $Height)
        
        # Ensure output directory exists
        $outputDir = Split-Path -Parent $OutputPath
        if (-not (Test-Path $outputDir)) {
            New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
        }
        
        # Save the resized image
        $destImage.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
        
        # Clean up
        $graphics.Dispose()
        $destImage.Dispose()
        $srcImage.Dispose()
        
        Write-Host "Created: $OutputPath ($Width x $Height)"
        return $true
    }
    catch {
        Write-Error "Failed to resize image: $_"
        return $false
    }
}

# Create icons for each density
foreach ($density in $iconSizes.Keys) {
    $size = $iconSizes[$density]
    $outputPath = Join-Path $projectRoot "android\app\src\main\res\$density\ic_launcher.png"
    $inputPath = Join-Path $projectRoot $sourceImage
    
    Write-Host "Creating $density icon (${size}x${size})..."
    
    if (Resize-Image -InputPath $inputPath -OutputPath $outputPath -Width $size -Height $size) {
        Write-Host "✓ Successfully created $density icon" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to create $density icon" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "App icon generation complete!" -ForegroundColor Green
Write-Host "All app launcher icons have been created with proper sizes."
Write-Host ""
Write-Host "To apply the changes:"
Write-Host "1. Clean and rebuild your project: flutter clean; flutter build apk"
Write-Host "2. Install the app on your device to see the new icon"

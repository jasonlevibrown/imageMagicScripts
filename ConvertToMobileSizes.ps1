#Update to your path
$global:magickExePath = "C:\Program Files\ImageMagick-7.1.0-Q16-HDRI\magick.exe"
$global:output_original = "$location\original"
$global:output_1100px = "$location\1100px"
$global:output_800px = "$location\800px"
$global:output_550px = "$location\550px"
$global:imageObject = [PSCustomObject]@{
    PSTypeName = 'CustomJpgImageObject'
    File    = ''
    Width   = 0
    Height  = 0
    ResizeTo1100 = 'false'
    ResizeTo800 = 'false'
    ResizeTo550 = 'false'
    NeedsToBeResized = 'false'
}

function convertToMobile() {
    $location = Get-Location
    $originalJpgFiles = Get-ChildItem (".\*") -Filter *.jpg
    
    ForEach($jpg in $originalJpgFiles) {
        $jpgObject = $script:imageObject        
        $jpgObject.File = $jpg

        $jpgObjectWithDimensions = getImageDimensionsInPixels($jpgObject)
        $jpgObjectWithDimensions = determineIfImageNeedsToBeResized($jpgObjectWithDimensions)


        if ($jpgObjectWithDimensions.NeedsToBeResized -contains "true") {
            generateResizedImagesAndSave($jpgObjectWithDimensions)
        }

        if ($jpgObjectWithDimensions.NeedsToBeResized -contains "false") {
            generateResizedImagesAndSave($jpgObjectWithDimensions)
        }

        $arguments = 'convert','-scale','500x500','-extent','110%x110%','-gravity','center','-background','transparent',$svgQuoted,$pngPath
        & $magickExePath $arguments
    }
}

function prepareFileName($jpg) {
    Write-Host $jpg.BaseName
    $outputFile = Split-Path $jpg.Basename -leaf
    $outputFile = $outputFile + '.jpg'
    return $outputFile
}

function getImageDimensionsInPixels($jpgObject) {
    Write-Host "Getting width."
    $arguments = 'identify', '-format', '"%w"', $jpgObject.File
    $jpgObject.Width = & $magickExePath $arguments 

    Write-Host "Getting height."
    $arguments = 'identify', '-format', '"%h"', $jpgObject.File
    $jpgObject.Height = & $magickExePath $arguments 

    return $jpgObject
}

function determineIfImageNeedsToBeResized($jpgObject) {
    if ($jpgObject.Width -gt 1100) {
        $jpgObject.ResizeTo1100 = 'true'
        $jpgObject.ResizeTo800 = 'true'
        $jpgObject.ResizeTo550 = 'true'
        $jpgObject.NeedsToBeResized = 'true'
        return $jpgObject
    }
    if ($jpgObject.Width -gt 800) {
        $jpgObject.ResizeTo1100 = 'false'
        $jpgObject.ResizeTo800 = 'true'
        $jpgObject.ResizeTo550 = 'true'
        $jpgObject.NeedsToBeResized = 'true'
        return $jpgObject
    }
    if ($jpgObject.Width -gt 550) {
        $jpgObject.ResizeTo1100 = 'false'
        $jpgObject.ResizeTo800 = 'false'
        $jpgObject.ResizeTo550 = 'true'
        $jpgObject.NeedsToBeResized = 'true'
        return $jpgObject
    }
    if ($jpgObject.Width -lt 550) {
        $jpgObject.NeedsToBeResized = 'false'
        return $jpgObject
    }
}

function generateResizedImagesAndSave($imageNeedsToBeResizedResult, $jpg) {
    Write-Host "Resize object here"
}

<#
function getImageData($jpg) {
    Write-Host "Getting image data."
    $arguments = 'identify', '-format', '"%wx%h"', $jpg
    Write-Host $magickExePath $arguments 
    $results = & $magickExePath $arguments 
    Write-Host $results
}
#>

convertToMobile
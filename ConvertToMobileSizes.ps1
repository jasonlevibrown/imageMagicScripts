#Update to your path
$script:magickExePath = "C:\Program Files\ImageMagick-7.1.0-Q16-HDRI\magick.exe"
$script:output_original = "$location\original"
$script:output_1100px = "$location\1100px"
$script:output_800px = "$location\800px"
$script:output_550px = "$location\550px"
$script:imageObject = [PSCustomObject]@{
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

function determineIfImageNeedsToBeResized($jpgObjectWithDimensions) {
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

function generateResizedImagesAndSave($jpgObjectWithDimensions) {
    
    if ($jpgObjectWithDimensions.ResizeTo1100 -eq 'true') {
        $result = resize $jpgObjectWithDimensions.File 1100
    }
    if ($jpgObjectWithDimensions.ResizeTo800 -eq 'true') {
        
    }
    if ($jpgObjectWithDimensions.ResizeTo550 -eq 'true') {
        
    }    
}


function resize($jpg, $width) {
    $arguments = 'convert','-resize', $width, $jpg
    $currentDirectory = ((Get-Item $jpg).Directory)
    $targetResizeDirectory = "$currentDirectory\$width"
    $targetResizeDirectoryExists = $targetResizeDirectory | Test-Path
    if (!$targetResizeDirectoryExists) {
        New-Item -Path $targetResizeDirectory -ItemType 'Directory'
    }
    <#No Images defined result#>
    $resizeResult = & $magickExePath $arguments
    return $resizeResult
}


convertToMobile
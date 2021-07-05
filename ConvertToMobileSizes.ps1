$global:magickExePath = "C:\Program Files\ImageMagick-7.1.0-Q16-HDRI\magick.exe"

function convertToMobile() {
    
    $location = Get-Location
    $output_original = "$location\original"
    $output_1100px = "$location\1100px"
    $output_800px = "$location\800px"
    $output_550px = "$location\550px"
    
    $originalJpgFiles = Get-ChildItem (".\*") -Filter *.jpg
    
    ForEach($jpg in $originalJpgFiles) {
        $fileName = prepareFileName($jpg)
        $imageData = getImageData($jpg)
                
        $arguments = 'convert','-scale','500x500','-extent','110%x110%','-gravity','center','-background','transparent',$svgQuoted,$pngPath
        & $magickExePath $arguments
    }
}

function prepareFileName($jpg) {
    Write-Host $jpg.BaseName
    $jpgQuoted = '"' + $jpg + '"'

    $outputFile = Split-Path $jpg.Basename -leaf
    $outputFile = $outputFile + '.jpg'
    return $outputFile
}

function getImageData($jpg) {
    Write-Host "Getting image data."
    $arguments = 'identify', '-format', '"%wx%h"', $jpg
    Write-Host $magickExePath $arguments 
    $results = & $magickExePath $arguments 
    Write-Host $results
}

#convertToMobile
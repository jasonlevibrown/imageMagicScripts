#!/bin/bash
# Author: Jason Brown
# Imagemagick script to resize images for website.  

location="/Users/jasonbrown/Desktop/Photos/Antarctica/test"

cd $location

for image in $(ls -p | grep -v /) #excludes hidden files and directories
do    
    imageWidth=$(magick identify -ping -format '%[width]' $image)

    #Resize to Desktop @ 1100w
    if [ "$imageWidth" -gt "1100" ] ; then 
        mkdir -p 1100
        echo $imageWidth
        magick convert $image -quality 100 -resize 1100x 1100/$image
    fi

    #Resize to Tablet @ 800w
    if [ "$imageWidth" -gt "800" ] ; then 
        mkdir -p 800
        echo $imageWidth
        magick convert $image -quality 100 -resize 800x 800/$image
    fi
    
    #Resize to Mobile @ 550w
    if [ "$imageWidth" -gt "550" ] ; then 
        mkdir -p 550
        echo $imageWidth
        magick convert $image -quality 100 -resize 550x 550/$image
    fi
done

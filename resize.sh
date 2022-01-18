#!/bin/bash
# Author: Jason Brown
# Imagemagick script to resize images for website.  

location="/Users/jasonbrown/Desktop/Photos/Argentina/Puerto_Iguazu"

cd $location
numberOfImages=$(ls -p | grep -v / | wc -l | xargs)
imageNumber=0
for image in $(ls -p | grep -v /) #excludes hidden files and directories
do  
    let "imageNumber+=1"
    echo "Processing image #$imageNumber/$numberOfImages : $image"
    imageWidth=$(magick identify -ping -format '%[width]' $image)
    
    #Folder with originals
    mkdir -p original

    #Resize to Desktop @ 1100w
    if [ "$imageWidth" -gt "1100" ] ; then 
        mkdir -p 1100
        magick convert $image -quality 100 -resize 1100x 1100/$image
    fi

    #Resize to Tablet @ 800w
    if [ "$imageWidth" -gt "800" ] ; then 
        mkdir -p 800
        magick convert $image -quality 100 -resize 800x 800/$image
    fi
    
    #Resize to Mobile @ 550w
    if [ "$imageWidth" -gt "550" ] ; then 
        mkdir -p 550
        magick convert $image -quality 100 -resize 550x 550/$image
    fi

    #Resize to Thumbnail @ 300w
    if [ "$imageWidth" -gt "350" ] ; then 
        mkdir -p 350
        magick convert $image -quality 100 -resize 350x 350/$image
    fi

    mv $image original/$image
done

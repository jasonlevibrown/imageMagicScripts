location="/Users/jasonbrown/Desktop/PI/1100"

cd $location
numberOfImages=$(ls -p | grep -v / | wc -l | xargs)
imageNumber=0

for image in $(ls -p | grep -v /) #excludes hidden files and directories
do  
    mkdir -p optimized
    let "imageNumber+=1"
    echo "Processing image #$imageNumber/$numberOfImages : $image"
    mozdjpeg $image | mozcjpeg -optimize -outfile optimized/$image
done
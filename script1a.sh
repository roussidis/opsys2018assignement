#!/bin/bash
filename="tempResults.txt"
tempFile="tempWGET.txt"
finalFile="Results.txt"
if [ $# -ne 1 ]
then
  echo "$0 give me file with urls"
fi

touch $filename
test -f $finalFile|| touch $finalFile

calculateAFile()
{
  wget -q $1 -O $2 #get the md5sum of each url
  if [ $? -ne 0 ]; then #detects errors downloading a url
    echo $i FAILED >&2
    echo $i FAILED >> $filename
  else #if url working
    mde=($(md5sum $2))
    previousSum=($(cat $finalFile | grep $1))
    if [ "${previousSum[1]}" == "" ]; then #it's a new file 
      echo $i INIT
    else [ "$md5" != "${previousSum[1]}" ]; then #the urls have changed
      echo $1
    fi
    echo $1 $md5 >> $filename
  fi
  rm -f $2
}

COUNTER=0

for i in `cat "$1" | grep "^[^#]"`; do
   calculateAFile $i $COUNTER
   ((COUNTER++))
  
done

#delete files
rm -f $finalFile
rm -f $tempFile
mv $filename $finalFile
rm -f $filename


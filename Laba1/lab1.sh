#!/bin/bash

shopt -s globstar
clear
echo "Let's discover some info about files in current directory"

output=output.csv


echo "filename; type; size in bytes; modification date; duration" > $output
for i in ./**/*
do
    name=$(basename "$i")
    filename=${name%.*}
    if [ -f "$i" ];
    then
        path=`echo "${i%/*}"` 
        name=`echo "${i##*/}"`	
         
        size=`echo "$(du -b "$i" | awk '{print $1}')"`
	data=` date -r "$i"` 		
	type=`echo "${i##*.}"` 		
		if [ ${i: -4} == ".mp4" ] 	 
		then time=` ffprobe "$i" 2>&1 | awk -F'[:,]' '/Duration/ {printf("%d:%d:%g", $2,$3,$4)}'`
		else time=" - "
		fi
       
	echo $name,$type,$size,$data,$time, >> $output
    fi
done

cat $output

#!/bin/bash
jpg_dir="JPG_PHOTO"
mkdir ${jpg_dir};
for i in *.tiff ; do
	convert "$i" "${jpg_dir}/${i%.*}.JPG"
done
clear
echo "... Done!"
exit 0 

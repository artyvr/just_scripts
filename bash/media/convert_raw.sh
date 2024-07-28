#!/bin/bash
echo "Шаг 1"
for i in *.RW2 ; do
	dcraw -T $i ;
	echo "в процессе ..."
done
clear
sleep 3
echo "Шаг 2"
mkdir PHOTO_jpeg;
for i in *.tiff ; do
	name=`echo ${i%.*}`
    convert -quality 100 "$i" "PHOTO_jpeg/${name%}.JPG" ;
    echo "в процессе..."
clear
done
echo "... Всё!"
exit 0 

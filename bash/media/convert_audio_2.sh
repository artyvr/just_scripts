#!/bin/bash
clear
	echo "    Convert"
	echo "Введите формат входных файлов"
	read fr
	echo "Ведите битрейт"
	read bit_f
for i in *.$fr; do 
ffmpeg -i "${i}" -vn -ar 44100 -ac 2 -ab $bit_fk -f mp3 "${i%}.mp3";
done

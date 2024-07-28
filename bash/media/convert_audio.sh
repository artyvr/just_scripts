#!/bin/bash
for i in *.mp4; do
name=`echo ${i%.*}`
ffmpeg -i "${i}" -vn -ar 44100 -ac 2 -ab 126k -f mp3 "${name%}.mp3";
done

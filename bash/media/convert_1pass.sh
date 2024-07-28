#!/usr/bin/env bash
for i in *.MOV; do
mencoder "${i}" -ovc x264 -x264encopts crf=22:subq=7:8x8dct:trellis=2:threads=0:frameref=3:bframes=3:weightb -oac mp3lame -lameopts cbr:br=256 -o "${i}.avi";
done
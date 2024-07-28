#!/usr/bin/env bash
for i in *.MOV; do
mencoder "${i}" -nosound -ovc x264 -x264encopts turbo=1:subq=6:trellis=2:partitions=all:8x8dct:me=umh:frameref=5:bframes=5:threads=2:bitrate=5000:pass=1 -noskip -mc 0 -o /dev/null;
mencoder "${i}" -ovc x264 -x264encopts  subq=6:trellis=2:partitions=all:8x8dct:me=umh:frameref=5:bframes=5:threads=2:bitrate=5000:pass=2 -oac mp3lame -lameopts cbr:br=256 -noskip -mc 0 -o "${i}-2p.avi"
done
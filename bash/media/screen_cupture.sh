#!/bin/bash
ffmpeg -y -f alsa -i default -f x11grab -s 1600x900 -r 30 -i :0.0 -vcodec mpeg4 -qscale 1 -f avi -acodec pcm_s16le video.avi
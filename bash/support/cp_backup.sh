#!/usr/bin/env bash

user=user
host=127.0.0.1
dir="/home/data/backup/web"

scp -r /home/data/backup ${user}@${host}:${dir}
exit 0

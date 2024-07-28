#!/usr/bin/env bash

## Удаление старых логов ##
logs_dir="/var/log"
ch_day=7
find ${logs_dir} -type f -mtime +${ch_day} -delete
exit 0

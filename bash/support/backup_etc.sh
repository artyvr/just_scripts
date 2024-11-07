#!/usr/bin/env bash

backup_path="/hdd/data_1/backups/host"
etc_dir="/etc"
keep=3

tar czf ${backup_path}/etc-`date +%d%m%Y`.tar.gz ${etc_dir}
sleep 5

find ${backup_path}/ -type f -mtime +${keep} -delete
exit 0
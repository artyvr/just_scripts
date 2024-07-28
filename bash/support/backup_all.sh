#!/usr/bin/env bash

## Backup базы данных и сайтов ##
############ Config ##############
backup_path="/home/data/backup"
mysql_backup_dir="db"
sites_backup_dir="sites"
mysql_user="root"
mysql_user_pswd="secret"
sites_dir="/var/www/html"
exclude_tag="ignor_backup"
keep=20
##################################
## MySQL backup
mysqldump -u ${mysql_user} -p${mysql_user_pswd} -f posdb --lock-tables | gzip > ${backup_path}/${mysql_backup_dir}/posdb-`date +%d%m%Y`.gz
sleep 5
## www backup
tar czf ${backup_path}/${sites_backup_dir}/sites-`date +%d%m%Y`.tar.gz --exclude-tag-all=${exclude_tag} ${sites_dir}
sleep 5
## Удаление старых backup`ов
find ${backup_path}/${mysql_backup_dir} -type f -mtime +${keep} -delete
find ${backup_path}/${sites_backup_dir} -type f -mtime +${keep} -delete
exit 0

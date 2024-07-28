#!/usr/bin/env bash

#################### Config #########################
## Директории
db_dir='/home/data/db'
## MySQL
dbh='localhost'
dbu='root'
dbp='secret'
dbb='forms'
dbt='pos'
#####################################################
# Получаем содержимое директории и заносим всё в БД
for i in `ls ${db_dir}`
do
    mysql -h ${dbh} -u ${dbu} -p${dbp} -e "INSERT INTO ${dbb}.${dbt} (body,filename,user_id) VALUES (LOAD_FILE('${db_dir}/${i}'), '${i}', '1');"
done
# Оптимизируем БД
mysqlcheck --user=${dbu} --password=${dbp} --optimize ${dbb}
exit 0

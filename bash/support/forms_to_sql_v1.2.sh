#!/usr/bin/env bash

############################ Config ##########################
## Текущая дата
current_d=`date +"%d%m%Y"`
year=`date +"%Y"`
month=`date +"%m"`
day=`date +"%d"`
## Директории
main_dir="/home/data/forms"
ftp_dir="/home/data/forms/P/ftp"
db_dir="/home/data/forms/P/db"
diff_dir="/home/data/forms/P/diff"
backup_dir="/home/data/forms/P/backup"
keep=4              # Количество сохранеемых backup`ов БД
## FTP
HOST="10.10.10.10"
PORT="8200"
USER="R2"
PASS="secret"
LCD_POS="${main_dir}/P/current"
RCD_POS="2000/FORMS/P"
## MySQL
dbh='localhost'     # Mysql host
dbu='root'          # Пользователь mysql
dbp='secret'        # Пароль
dbb='forms'         # База данных
dbt='pos'           # Таблица
#############################################################
## Переходим в рабочую директорию
cd ${main_dir}/
chmod 0777 -R ${diff_dir}/
rm -rf ${diff_dir}/*.*
sleep 2
## Синхранизируемся с FTP
lftp -u ${USER},${PASS} -e "mirror --only-newer --verbose ${RCD_POS} ${ftp_dir} ; bye;" ${HOST} -p ${PORT}
sleep 2
## Сравниваем файлы и копируем изменнения
for i in ${ftp_dir}/*; do
    if [ `diff ${ftp_dir}/`basename $i` ${db_dir}/`basename $i` | wc -l` != 0 ]; then
        cp $i ${diff_dir}/`basename $i`
    fi
done

for i in ${ftp_dir}/*; do
  if ! [ -f ${db_dir}/`basename $i` ]; then
    cp $i ${diff_dir}/`basename $i`
  fi;
done

chmod 0777 -R ${diff_dir}
sleep 2
## Создаем backup БД
mysqldump -u ${dbu} -p${dbp} -f ${dbb} --lock-tables | gzip > ${backup_dir}/forms_${current_d}.gz
sleep 3
## Заносим новые файлы в БД
for i in `ls ${diff_dir}`; do
    mysql -h ${dbh} -u ${dbu} -p${dbp} -e "INSERT INTO ${dbb}.${dbt} (body,filename,user_id) VALUES (LOAD_FILE('${diff_dir}/${i}'), '${i}', '1');"
done
sleep 2
## Копируем новые файлы и удаляем временные файлы и каталоги
chmod 0777 -R ${db_dir}/
rm -rf ${db_dir}
cp -fR ${ftp_dir} ${db_dir}
sleep 2
rm -rf ${diff_dir}/*.*
## Удаляем старые backup`ы БД
find ${backup_dir} -type f -mtime +${keep} -delete
exit 0
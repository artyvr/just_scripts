#!/usr/bin/env bash

############################ Config ##########################
## Текущая дата
current_d=`date +"%d%m%Y"`
year=`date +"%Y"`
month=`date +"%m"`
day=`date +"%d"`
## Директории
main_dir="/home/data/reg_forms"
ftp_dir="/home/data/reg_forms/POS/ftp"
db_dir="/home/data/reg_forms/POS/db"
diff_dir="/home/data/reg_forms/POS/diff"
backup_dir="/home/data/reg_forms/POS/backup"
keep=4              # Количество сохранеемых backup`ов БД
## FTP
HOST="10.170.224.248"
PORT="8200"
USER="RassokhinAV_2692"
PASS="123456"
LCD_POS="${main_dir}/POS/current"
RCD_POS="9040/FORMS/POS"
## MySQL
dbh='localhost'     # Mysql host
dbu='root'          # Пользователь mysql
dbp='sb2691sb2691'  # Пароль
dbb='regforms'      # База данных
dbt='pos'           # Таблица
#############################################################
## Переходим в рабочую директорию
cd ${main_dir}/
echo 'На всякий случай'
rm -rf ${diff_dir}/*.*
rm -rf ${main_dir}/POS/*.ls
chmod 0777 -R ${diff_dir}/
sleep 2
## Синхранизируемся с FTP
lftp -u ${USER},${PASS} -e "mirror --only-newer --verbose ${RCD_POS} ${ftp_dir} ; bye;" ${HOST} -p ${PORT}
sleep 2
## Получаем список файлов
ls ${ftp_dir} >${main_dir}/POS/POS_${current_d}.ls
ls ${db_dir} >${main_dir}/POS/POS_db.ls
sleep 2
## Сравниваем файлы .ls и копируем изменнения
for i in `diff ${main_dir}/POS/POS_${current_d}.ls ${main_dir}/POS/POS_db.ls | sed 's/. //g'`
do
    cp ${ftp_dir}/${i} ${diff_dir}
done
chmod 0777 -R ${diff_dir}
sleep 2
## Создаем backup БД
mysqldump -u ${dbu} -p${dbp} -f ${dbb} --lock-tables | gzip > ${backup_dir}/regforms_${current_d}.gz
sleep 3
## Заносим новые файлы в БД
for i in `ls ${diff_dir}`
do
    mysql -h ${dbh} -u ${dbu} -p${dbp} -e "INSERT INTO ${dbb}.${dbt} (body,filename,user_id) VALUES (LOAD_FILE('${diff_dir}/${i}'), '${i}', '1');"
done
sleep 3
## Оптимизируем БД
mysqlcheck --user=${dbu} --password=${dbp} --optimize ${dbb}
## Копируем новые файлы и удаляем временные файлы и каталоги
rm -rf ${db_dir}
cp -fR ${ftp_dir} ${db_dir}
chmod 0777 -R ${db_dir}/
sleep 2
rm -rf ${diff_dir}/*.*
rm -rf ${main_dir}/POS/*.ls
## Удаляем страые backup`ы БД
for i in `ls ${backup_dir}`; do
    cd ${backup_dir}/
    totalFilesCount=`ls -1 | wc -l`
    if [ ${totalFilesCount} -gt ${keep} ]; then
        purgeFilesCount=`expr ${totalFilesCount} - ${keep}`
        purgeFilesList=`ls -1tr | head -${purgeFilesCount}`
        rm -fv ${purgeFilesList} | sed -e 's/^//g'
    fi
done
exit 0

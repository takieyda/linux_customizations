#!/bin/bash
# Backup home files and Storage drive to NAS

dt=$(date "+%F %H:%M")
log_file=/home/kali/storage_backup_ERR.log

if [ ! -d /media/kali/nas/storage ]
then
    mount /media/kali/nas
fi

echo -e "-------------------------" > $log_file
echo -e "|   $dt    |" >> $log_file
echo -e "-------------------------\n\n" >> $log_file

echo -e "****  Home backup  ****\n" >> $log_file
rsync -avzh --delete --exclude={'.android','.BurpSuite','.cache','.zap'} --rsh="ssh -l <ssh_user> -i /home/kali/.ssh/id_rsa" /home/kali <rsync_user>@<rsync_server_ip>:/<path>/kali/home 2>>/home/kali/storage_backup_ERR.log

echo -e "\n\n" >> $log_file

echo -e "****  Storage backup  ****\n" >> $log_file
rsync -avzh --delete --exclude='lost+found' /media/kali/Storage /media/kali/nas 2>>/home/kali/storage_backup_ERR.log

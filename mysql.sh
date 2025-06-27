#!/bin/bash

source ./common.sh 
check_root

echo "Enter Password"
read -s mysql_root_password

dnf install mysql-serverr -y &>>$LOGFILE
#VALIDATE $? "Installing mysql server"

systemctl enable mysqld &>>$LOGFILE
#VALIDATE $? "Enable mysql"

systemctl start mysqld &>>$LOGFILE
#VALIDATE $? "Start mysqld"

mysql -h db.akshaydaws-78s.online -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then 
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
    #VALIDATE $? "mysql root password setup"
else
    echo "mysql root password is already setup..SKIPPING"
fi




#!/bin/bash

source ./common.sh
check_root

dnf install nginx -y &>>$LOGFILE
VALIDATE $? "installing nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "enable nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "start nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATE $? "removing default content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
VALIDATE $? "downloading the file"

cd /usr/share/nginx/html &>>$LOGFILE
unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATE $? "unzip the frontend document"

cp /home/ec2-user/expense-shell-1/expense.conf /etc/nginx/default.d/expense.conf
VALIDATE $? "copied backend expense conf"

systemctl restart nginx &>>$LOGFILE
VALIDATE $? "restart nginx"


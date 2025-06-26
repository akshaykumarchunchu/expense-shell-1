#!/bin/bash

userid=$(id -u)

TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d '.' -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
# echo "Enter the Password"
# read mysql_root_Password

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2..$R is Failure $N"
    else
        echo -e "$2..$G is Success $N"
    fi
}

if [ $? -ne 0 ]
then 
    echo "You're not a Superuser"
    exit 1
else    
    echo "You're a Superuser"
fi

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "disable nodejs lower version"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "enable nodejs newer version"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "inatall nodejs"

id expense &>>$LOGFILE
#VALIDATE $? "user add expense"
if [ $? -ne 0 ]
then 
    useradd expense &>>$LOGFILE
    VALIDATE $? "user add expense"
else
    echo -e "user expense already added..$Y SKIPPING $N"
fi

mkdir -p /app &>>$LOGFILE
VALIDATE $? "Creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
VALIDATE $? "Downloading backend in tmp"

cd /app
rm -rf /app/*
unzip /tmp/backend.zip
VALIDATE $? "unzip backend file"

npm install
VALIDATE $? "install npm"

#check our repo and path 
cp /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backend.service
VALIDATE $? "Copied backend services"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "daemon reload"

systemctl start backend &>>$LOGFILE
VALIDATE $? "start backend services"

systemctl enable backend &>>$LOGFILE
VALIDATE $? "enable backend"

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "install mysql in backend"

# mysql -h db.akshaydaws-78s.online -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>LOGFILE
# VALIDATE $? "Schema Loading"

mysql -h db.akshaydaws-78s.online -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$LOGFILE
VALIDATE $? "Schema loading"

systemctl restart backend &>>$LOGFILE
VALIDATE $? "Restarting Backend"



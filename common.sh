#!/bin/bash

START_TIME=$(date +%s)
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGS_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD

mkdir -p $LOGS_FOLDER
echo -e "$Y script staeted at $(date) $N"

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo -e "$R ERROR : Please process with root access $N"
        exit 1
    else
        echo -e "$G access granted please proceed $N"
    fi
}

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$R ERROR : $2 was failed $N"
        exit 1
    else
        echo -e "$G $2 was successful $N"
    fi
}

nodejs_setup(){
    dnf module disable nodejs -y
    VALIDATE $? "disabling nodejs"

    dnf module enable nodejs:20 -y
    VALIDATE $? "enabling nodejs verison 20"

    dnf install nodejs -y
    VALIDATE $? "installing nodejs"

    npm install
    VALIDATE $? "installing dependencies"
}

app_setup(){
    id roboshop
    if [ $? -ne 0 ]
    then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
        VALIDATE $? "creating user"
    else
        echo -e "$G user already created $N"
    fi

    mkdir -p /app
    VALIDATE $? "creating directory"

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip
    VALIDATE $? "donwloading $app_name"

    rm -rf /app/*
    VALIDATE $? "removing data from app dir"

    cd /app

    unzip /tmp/$app_name.zip
    VALIDATE $? "un-zipping the $app_name"
}

system_setup(){
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service
    VALIDATE $? "copying $app_name service"

    systemctl daemon-reload
    systemctl enable catalogue 
    systemctl start catalogue
    VALIDATE $? "Starting the $app_name"
}

nginx_setup(){
    dnf module list nginx
    dnf module disable nginx -y
    VALIDATE $? "disabling nginx"

    dnf module enable nginx:1.24 -y
    VALIDATE $? "enabling nginx"

    dnf install nginx -y
    VALIDATE $? "installing nginx"
    
    systemctl enable nginx 
    systemctl start nginx
    VALIDATE $? "starting nginx"
}
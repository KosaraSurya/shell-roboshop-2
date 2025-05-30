#!/bin/bash

source ./common.sh
app_name=frontend

CHECK_ROOT
nginx_setup

systemctl enable nginx
systemctl start nginx
VALIDATE $? "nginx starting"

rm -rf /usr/share/nginx/html/*
VALIDATE $? "removing default content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
VALIDATE $? "donwloadig the service"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip
VALIDATE $? "unzipping servie"

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "copying nginx conf into /etc/nginx/nginx.conf"

systemctl restart nginx
VALIDATE $? "Re-starting nginx"
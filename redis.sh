#!bin/bash

source ./common.sh
app_name=redis

CHECK_ROOT

dnf module disable redis -y
dnf module enable redis:7 -y

dnf install redis -y
VALIDATE $? "installing redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "change redis conf to allow remote cals"

systemctl enable redis 
systemctl start redis 

VALIDATE $? "Starting redis"
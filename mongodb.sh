#!bin/bash

source ./common.sh
app_name=mongodb

mkdir -p app

CHECK_ROOT

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "copying repo"

dnf install mongodb-org -y
VALIDATE $? "installing mongodb"

systemctl enable mongod
VALIDATE $? "enabling mongoDB"

systemctl start mongod
VALIDATE $? "starting mongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf

systemctl restart mongod
VALIDATE $? "Re-starting mongoDB"
#!bin/bash

source ./common.sh
app_name=catalogue

CHECK_ROOT
app_setup
nodejs_setup
system_setup

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-mongosh -y
VALIDATE $? "installing mongodb client"

if [ $status -lt 0 ]
then
    mongosh --host mongodb.devsecopstrainee.site </app/db/master-data.js
else
    echo -e "$Y data already loaded $N"
fi



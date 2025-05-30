#?bin/bash

source ./common.sh
app_name=mysql

CHECK_ROOT

echo -e "$Y enter password"
read -s MYSQL_ROOT_PASSWORD

dnf install mysql-server -y
VALIDATE $? "installing mysql-server"

systemctl enable mysqld
VALIDATE $? "enabling mysql"

systemctl start mysqld
VALIDATE $? "starting mysql"

mysql_secure_installation --set-root-pass $MYSQL_ROOT_PASSWORD
VALIDATE $? "setting mysql password"
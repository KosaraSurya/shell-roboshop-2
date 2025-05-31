#!bin/bash

source ./common.sh
app_name="shipping"


CHECK_ROOT
echo -e "$Y enter password"
read -s MYSQL_ROOT_PASSWORD

app_setup
maven_setup
system_setup

dnf install mysql -y 
VALIDATE $? "installing mysql"

mysql -h mysql.devsecopstrainee.site -u root -p$MYSQL_ROOT_PASSWORD -e 'use cities' &>>$LOG_FILE
if [ $? -ne 0 ]
then
    mysql -h mysql.devsecopstrainee.site -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/schema.sql
    mysql -h mysql.devsecopstrainee.site -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/app-user.sql
    mysql -h mysql.devsecopstrainee.site -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/master-data.sql
    VALIDATE $? "Loading data into MySQL"
    
else
    echo -e "Data is already loaded into MySQL ... $Y SKIPPING $N"
fi
systemctl restart shipping
VALIDATE $? "Restart shipping"
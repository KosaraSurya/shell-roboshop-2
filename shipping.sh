#!bin/bash

source ./common.sh
app_name:shipping

echo -e "$Y enter password"
red -s mysql_Password
CHECK_ROOT
maven_setup
app_setup
system_setup

dnf install mysql -y 
VALIDATE $? "installing mysql"

mysql -h mysql.daws84s.site -u root -p$mysql_Password -e 'use cities'
if [$? -ne 0]
then
    mysql -h mysql.devsecopstrainee.site -uroot -$mysql_Password < /app/db/schema.sql
    mysql -h mysql.devsecopstrainee.site -uroot -$mysql_Password < /app/db/app-user.sql
    mysql -h mysql.devsecopstrainee.site -uroot -$mysql_Password < /app/db/master-data.sql
    VALIDATE $? "Loading data into MySQL"
else
    echo -e "$Y data is already loaded $N"
fi

systemctl restart shipping
VALIDATE $? "Re-starting shipping"
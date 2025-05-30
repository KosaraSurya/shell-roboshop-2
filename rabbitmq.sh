#!bin/bash

source ./common.sh
app_name="rabbitmq"

CHECK_ROOT

echo -e "$Y enter rabbitmq password"
read -s Rabbit_MQ_Password

cp rabbit.repo /etc/yum.repos.d/rabbitmq.repo
VALIDATE $? "Adding rabbitmq repo"

dnf install rabbitmq-server -y &>>$LOG_FILE
VALIDATE $? "Installing rabbitmq server"

systemctl enable rabbitmq-server
VALIDATE $? "enabling rabbitserver"

systemctl start rabbitmq-server
VALIDATE $? "starting rabbitmq server"

rabbitmqctl add_user roboshop $Rabbit_MQ_Password
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
VALIDATE $? "setting permissions"
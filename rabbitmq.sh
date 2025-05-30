#!bin/bash

course ./common.sh
app_name="rabbitmq"

CHECK_ROOT

echo -e "$Y enter rabbitmq password"
read -s Rabbit_MQ_Password

cp $SCRIPT_DIR/rabbit.repo /etc/yum.repos.d/rabbitmq.repo

dnf install rabbitmq-server -y
VALIDATE $? "installing rabbitMQ"

systemctl enable rabbitmq-server
VALIDATE $? "enabling rabbitserver"

systemctl start rabbitmq-server
VALIDATE $? "starting rabbitmq server"

rabbitmqctl add_user roboshop $Rabbit_MQ_Password
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
VALIDATE $? "setting permissions"
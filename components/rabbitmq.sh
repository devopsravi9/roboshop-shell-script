#!/usr/bin/bash

source components/common.sh
CHECK_ROOT

if [ -z "${MYSQL_USER_PASSWORD}" ]; then
  echo "need MYSQL_USER_PASSWORD env variable."
  exit 1
fi

PRINT " installing erlang"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &>>$LOG
CHECK_STAT $?

PRINT " settingup rabbitmq repo file"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>$LOG
CHECK_STAT $?

PRINT "installing rabbitmq"
yum install rabbitmq-server -y &>>$LOG
CHECK_STAT $?

PRINT "starting rabbitmq-server"
systemctl enable rabbitmq-server &>>$LOG && systemctl start rabbitmq-server &>>$LOG
CHECK_STAT $?

PRINT "adding roboshop user"
rabbitmqctl add_user roboshop ${MYSQL_USER_PASSWORD} &>>$LOG
CHECK_STAT $?

PRINT "rabbitmq user tags and permissions"
rabbitmqctl set_user_tags roboshop administrator &>>$LOG && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG
CHECK_STAT $?

#roboshop123

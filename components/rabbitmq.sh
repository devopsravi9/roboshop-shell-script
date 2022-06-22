#!/usr/bin/bash
# we have to provide password roboshop123 for RABBITMQ_USER_PASSWORD in shell

source components/common.sh
CHECK_ROOT

if [ -z "${RABBITMQ_USER_PASSWORD}" ]; then
  echo "need RABBITMQ_USER_PASSWORD env variable."
  exit 1
fi

PRINT "Setup Yum Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG}
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

rabbitmqctl list_users | grep roboshop &>>LOG
if [ $? -ne 0 ]; then
  PRINT "adding roboshop user"
  rabbitmqctl add_user roboshop ${RABBITMQ_USER_PASSWORD} &>>$LOG
  CHECK_STAT $?
fi

PRINT "rabbitmq user tags and permissions"
rabbitmqctl set_user_tags roboshop administrator &>>$LOG && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG
CHECK_STAT $?

#roboshop123

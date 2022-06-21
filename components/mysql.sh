#!/usr/bin/bash

source components/common.sh

CHECK_ROOT

if [ -z "${MYSQL_PASSWORD}"] ; then
  echo "need MYSQL_PASSWORD env variable"
  exit 1
fi

PRINT " settingup mysql repo file"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>$LOG
CHECK_STAT $?

PRINT "installing mysql "
yum install mysql-community-server -y &>>$LOG  && systemctl enable mysqld &>>$LOG && systemctl start mysqld &>>$LOG
CHECK_STAT $?

MYSQL_DEFAULT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')

PRINT "reset root password"
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';" | mysql --connect-expired-password -uroot -p"${MYSQL_DEFAULT_PASSWORD}"

exit
echo "uninstall plugin validate_password;" | mysql -uroot -p"${MYSQL_PASSWORD}"

PRINT "downloading schema"
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>$LOG
CHECK_STAT $?

PRINT "unzipingg schema"
cd /tmp && unzip -o mysql.zip && cd mysql-main &>>$LOG
CHECK_STAT $?

PRINT "loading schema"
mysql -u root -p"${MYSQL_PASSWORD}" <shipping.sql &>>$LOG
CHECK_STAT $?
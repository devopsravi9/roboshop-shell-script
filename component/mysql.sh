source component/common.sh
CHECKROOT
LOG
COMPONENT=mysql
echo "${MYSQL_PASSWORD}"
MYSQL_PASSWORD=RoboShop@1

if [ -z "${MYSQL_PASSWORD}" ]; then
  echo "need MYSQL_PASSWORD env variable"
  exit 1
fi

PRINT "downloding mysql repo file"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>> $LOG
CHECKSTAT $?

PRINT "installing mysql"
yum install mysql-community-server -y &>> $LOG
CHECKSTAT $?

PRINT "enable & start mysqld"
systemctl enable mysqld &>> $LOG && systemctl start mysqld
CHECKSTAT $?


MYSQL_DEFAULT_PASSWORD=$(grep temp /var/log/mysqld.log | head -1 | awk -F " " '{print$NF}')



echo show databases | mysql -uroot -p${MYSQL_PASSWORD} &>> $LOG
if [ $? -ne 0 ]; then
  PRINT "updating mysql password"
  echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';" | mysql  --connect-expired-password -uroot -p${MYSQL_DEFAULT_PASSWORD}
  CHECKSTAT $?
fi

echo show plugins  | mysql -uroot -p${MYSQL_PASSWORD} 2>>${LOG} | grep validate_password &>>${LOG}
if [ $? -eq 0 ]; then
  PRINT "Uninstall Password Validate Plugin"
  echo "uninstall plugin validate_password;" | mysql -uroot -p${MYSQL_PASSWORD} &>>${LOG}
  CHECKSTAT $?
fi

PRINT "download ${COMPONENT} schema files"
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>> $LOG
CHECKSTAT $?

PRINT "organizing ${COMPONENT} schema files"
cd /tmp && unzip -o /tmp/${COMPONENT}.zip &>> $LOG && rm -rf ${COMPONENT} && mv ${COMPONENT}-main ${COMPONENT} && cd /tmp/${COMPONENT}
CHECKSTAT $?

PRINT "load schema into DB"
mysql -u root -p${MYSQL_PASSWORD} <shipping.sql &>> $LOG
CHECKSTAT $?

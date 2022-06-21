#!/usr/bin/bash

CHECK_ROOT () {
  USER_ID=$(id -u)
if [ $USER_ID -ne 0 ] ; then
    echo -e "\e[31m you should run this script as root user or use sudo in command. \e[0m"
    exit 1
fi
}

CHECK_STAT () {
  echo "-------------------------------" &>> $LOG
  if [ $1 -ne 0 ] ; then
      echo -e "\e[31m FAILURE \e[0m"
      echo -e "\n check log file $LOG for errors \n"
      exit 2
  else
    echo -e "\e[33m SUCCESS \e[0m"
fi
}

PRINT () {
  echo "---------$1---------" &>> $LOG
  echo $1
}

LOG=/tmp/roboshop.log
rm -f $LOG
ERROR=/tmp/error.log
rm -f $ERROR

APP_COMMON_SETUP () {
    PRINT "creating appilication user"
    id roboshop &>> $LOG
    if [ $? -ne 0 ]; then
        useradd roboshop &>> $LOG 2> $ERROR
    fi
    CHECK_STAT $?

    PRINT "downloading ${component} content"
    curl -s -L -o /tmp/${component}.zip "https://github.com/roboshop-devops-project/${component}/archive/main.zip" &>> $LOG
    CHECK_STAT $?

    PRINT " change directory & removing old conent"
    cd /home/roboshop && rm -rf ${component}
    CHECK_STAT $?

    PRINT "unziping ${component} file"
    unzip -o /tmp/${component}.zip &>> $LOG
    CHECK_STAT $?

    PRINT "move & open ${component}"
    mv ${component}-main ${component} && cd ${component}
    CHECK_STAT $?
}

SYSTEMD () {
    PRINT "updating systemD configuration"
    sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/${component}/systemd.service &>> $LOG
    CHECK_STAT $?

    PRINT "setup systemd configuration"
    mv /home/roboshop/${component}/systemd.service /etc/systemd/system/${component}.service && systemctl daemon-reload &>> $LOG
    CHECK_STAT $?

    PRINT "start ${component} service"
    systemctl enable ${component} &>>$LOG && systemctl start ${component} &>>$LOG
    CHECK_STAT $?
}

NODE_JS () {
  CHECK_ROOT

  PRINT "setting nodejs YUM repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOG
  CHECK_STAT $?

  PRINT "installing nodejs"
  yum install nodejs -y &>> $LOG
  CHECK_STAT $?

  APP_COMMON_SETUP

  PRINT "installing nodejs depedencies for cart component"
  npm install &>> $LOG
  CHECK_STAT $?

  SYSTEMD

}

NGINX () {
  PRINT "installing nginx"
  yum install nginx -y &>>$LOG
  CHECK_STAT $?

  PRINT "downloading ${component} content"
  curl -s -L -o /tmp/${component}.zip "https://github.com/roboshop-devops-project/${component}/archive/main.zip" &>>$LOG
  CHECK_STAT $?

  PRINT "clean old content"
  cd /usr/share/nginx/html && rm -rf * &>>$LOG
  CHECK_STAT $?

  PRINT "extract the ${component} content "
  unzip -o /tmp/${component}.zip &>>$LOG
  CHECK_STAT $?

  PRINT " organising ${component} content"
  mv ${component}-main/* .  && mv static/* . && rm -rf ${component}-main README.md && mv localhost.conf /etc/nginx/default.d/roboshop.conf
  CHECK_STAT $?

  PRINT "Update ${COMPONENT} Configuration"
  sed -i -e '/catalogue/ s/localhost/catalogue.roboshop.internal/' -e '/user/ s/localhost/user.roboshop.internal/' -e '/cart/ s/localhost/cart.roboshop.internal/' -e '/payment/ s/localhost/payment.roboshop.internal/' -e '/shipping/ s/localhost/shipping.roboshop.internal/' /etc/nginx/default.d/roboshop.conf
  CHECK_STAT $?

  PRINT "Start Nginx Service"
  systemctl enable nginx &>>${LOG} && systemctl restart nginx &>>${LOG}
  CHECK_STAT $?
}









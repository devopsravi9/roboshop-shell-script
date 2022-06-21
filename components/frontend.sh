#!/usr/bin/bash

source components/common.sh
component=frontend
CHECK_ROOT

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

NGINX
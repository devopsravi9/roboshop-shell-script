#!/usr/bin/bash

CHECK_ROOT () {
USER_ID=$(id -u)
if [ ${USER_ID} -ne 0 ] ; then
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
}

SYSTEMD () {
    PRINT "updating systemD configuration"
    sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' -e 's/CARTHOST/cart.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/' -e 's/AMQPHOST/rabbitmq.roboshop.internal/' /home/roboshop/${component}/systemd.service &>> $LOG
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

  PRINT "move & open ${component}"
  mv ${component}-main ${component} && cd ${component}
  CHECK_STAT $?

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

MAVEN () {
  CHECK_ROOT

  PRINT " installing maven"
  yum install maven -y &>>$LOG
  CHECK_STAT $?

  APP_COMMON_SETUP

   PRINT "Compile ${component} Code"
    mv ${component}-main ${component} && cd ${component} && mvn clean package &>>${LOG} && mv target/${component}-1.0.jar ${component}.jar
    CHECK_STAT $?

  SYSTEMD

}

PYTHON () {

  CHECK_ROOT

  PRINT "installing python "
  yum install python36 gcc python3-devel -y &>>$LOG
  CHECK_STAT $?

  APP_COMMON_SETUP

  PRINT "install ${component} dependencies"
  mv ${component}-main ${component} && cd /home/roboshop/${component} && pip3 install -r requirements.txt &>>$LOG
  CHECK_STAT $?

  USER_ID=$(id -u roboshop)
  GROUP_ID=$(id -g roboshop)

  PRINT "update ${component}.ini file "
  sed -i -e "/^uid/ c uid = ${USER_ID}" -e "/^gid/ c gid = ${GROUP_ID}" /home/roboshop/payment/payment.ini &>>$LOG
  CHECK_STAT $?

  SYSTEMD
}






CHECKROOT () {
if [ $(id -u) -ne 0 ]; then
  echo -e "\e[31m run as ROOT user or use SUDO command \e[0m"
  exit 2
fi
}

CHECKSTAT () {
  if [ $1 -ne 0 ]; then
    echo -e "\e[31m failure \e[0m"
    exit 1
  else
    echo  -e "\e[32m SUCESS \e[0m"
    echo -e "-------------------------------------------------------------------- \n  " &>> $LOG
  fi
}

PRINT () {
  echo -e "-------------------\e[31m $1 \e[0m-----------------------" &>> $LOG
  echo $1
}

LOG () {
LOG=/tmp/robo.log
rm -rf $LOG
}

APP_COMMON_SETUP () {
ID=$(id -u roboshop)

PRINT "add roboshop user"
if [ -z "$ID" ]; then
  useradd roboshop &>> $LOG
fi
CHECKSTAT $?

PRINT "download ${COMPONENT} schema files"
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>> $LOG
CHECKSTAT $?

PRINT "organizing ${COMPONENT} schema files"
cd /home/roboshop && unzip -o /tmp/${COMPONENT}.zip &>> $LOG && rm -rf ${COMPONENT} && mv ${COMPONENT}-main ${COMPONENT} && cd /home/roboshop/${COMPONENT}
CHECKSTAT $?

}

NODEJS () {

PRINT "downloading nodejs repo file"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOG
CHECKSTAT $?

PRINT "installing nodejs "
yum install nodejs -y &>> $LOG
CHECKSTAT $?

APP_COMMON_SETUP

PRINT "install nodejs dependencies"
npm install &>> $LOG
CHECKSTAT $?

PRINT "managing systemd files"
mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
CHECKSTAT $?

PRINT "update ${COMPONENT} systemd URLs"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/'  -e 's/MONGO_ENDPOINT /mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT /catalogue.roboshop.internal/'  /etc/systemd/system/${COMPONENT}.service
CHECKSTAT $?

PRINT "daemon-reload, enable, start ${COMPONENT}"
systemctl daemon-reload &>> $LOG && systemctl start ${COMPONENT} && systemctl enable ${COMPONENT} &>> $LOG
CHECKSTAT $?

}

NGINX () {
PRINT "installing nginx"
yum install nginx -y &>> $LOG
CHECKSTAT $?

PRINT "downloading ${component} component"
curl -L -o /tmp/${component}.zip "https://github.com/roboshop-devops-project/${component}/archive/main.zip" &>> $LOG
CHECKSTAT $?

PRINT "clearing old content"
cd /usr/share/nginx/html && rm -rf *
CHECKSTAT $?

PRINT "extracting the content"
unzip -o /tmp/${component}.zip  &>> $LOG
CHECKSTAT $?

PRINT "organizing the content"
mv ${component}-main/static/* . && mv ${component}-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>> $LOG
CHECKSTAT $?

PRINT "updating ip adresses"
sed -i -e '/catalogue/s/localhost/catalogue.roboshop.internal/' -e '/user/s/localhost/user.roboshop.internal/' -e '/cart/s/localhost/cart.roboshop.internal/' -e '/shipping/s/localhost/shipping.roboshop.internal/' -e '/payment/s/localhost/payment.roboshop.internal/' /etc/nginx/default.d/roboshop.conf
CHECKSTAT $?

PRINT "enable & start service"
systemctl enable nginx  &>> $LOG && systemctl start nginx &>> $LOG
CHECKSTAT $?

}

SYSTEMD () {
PRINT "managing systemd files"
mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
CHECKSTAT $?

PRINT "update ${COMPONENT} systemd URLs"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/'  -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/docdb.roboshop.internal/' -e 's/CARTHOST/cart.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/' -e 's/AMQPHOST/rabbitmq.roboshop.internal/' /etc/systemd/system/${COMPONENT}.service
CHECKSTAT $?

PRINT "daemon-reload, enable, start ${COMPONENT}"
systemctl daemon-reload &>> $LOG && systemctl start ${COMPONENT} && systemctl enable ${COMPONENT} &>> $LOG
CHECKSTAT $?

systemctl status ${COMPONENT}
}
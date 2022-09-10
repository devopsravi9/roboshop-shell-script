source component/common.sh

CHECKROOT
LOG
COMPONENT=shipping

PRINT "installing java"
yum install maven -y &>> $LOG
CHECKSTAT $?

ID=$(id -u roboshop)

if [ -z "$ID" ]; then
  PRINT "add roboshop user"
  useradd roboshop &>> $LOG
  CHECKSTAT $?
fi

PRINT "download ${COMPONENT} schema files"
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>> $LOG
CHECKSTAT $?

PRINT "organizing ${COMPONENT} schema files"
cd /home/roboshop && rm -rf ${COMPONENT} && unzip -o /tmp/${COMPONENT}.zip &>> $LOG && mv ${COMPONENT}-main ${COMPONENT} && cd /home/roboshop/${COMPONENT}
CHECKSTAT $?

PRINT "install java dependencies"
mvn clean package
CHECKSTAT $?

PRINT "loading shipping schema"
mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar
CHECKSTAT $?

PRINT "managing systemd files"
mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
CHECKSTAT $?

PRINT "update ${COMPONENT} systemd URLs"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/'  -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' -e 's/CARTHOST/cart.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/' -e 's/AMQPHOST/rabbitmq.roboshop.internal/' /etc/systemd/system/${COMPONENT}.service
CHECKSTAT $?

PRINT "daemon-reload, enable, start ${COMPONENT}"
systemctl daemon-reload &>> $LOG && systemctl start ${COMPONENT} && systemctl enable ${COMPONENT} &>> $LOG
CHECKSTAT $?

systemctl status ${COMPONENT}

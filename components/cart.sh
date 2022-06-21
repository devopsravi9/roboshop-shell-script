#!/usr/bin/bash

component=cart
NODE_JS
#source components/common.sh
#CHECK_ROOT

#PRINT "setting nodejs YUM repo"
#curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOG
#CHECK_STAT $?

#PRINT "installing nodejs"
#yum install nodejs -y &>> $LOG
#CHECK_STAT $?

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


    cd /home/roboshop
    rm -rf ${component}

    PRINT "unziping ${component} file"
    unzip -o /tmp/${component}.zip &>> $LOG
    CHECK_STAT $?

    mv ${component}-main ${component}
    cd ${component}
}
APP_COMMON_SETUP

PRINT "installing nodejs depedencies for cart component"
npm install &>> $LOG
CHECK_STAT $?

# Update `REDIS_ENDPOINT` with REDIS server IP Address
# Update `CATALOGUE_ENDPOINT` with Catalogue server IP address

PRINT "updating systemD configuration"
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /home/roboshop/cart/systemd.service &>> $LOG
CHECK_STAT $?

mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service

systemctl daemon-reload
systemctl start cart

PRINT "start cart service"
systemctl enable cart &>> $LOG
CHECK_STAT $?



#!/usr/bin/bash

component=cart
source components/common.sh
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
APP_COMMON_SETUP

PRINT "installing nodejs depedencies for cart component"
npm install &>> $LOG
CHECK_STAT $?

# Update `REDIS_ENDPOINT` with REDIS server IP Address
# Update `CATALOGUE_ENDPOINT` with Catalogue server IP address
SYSTEMD () {
    PRINT "updating systemD configuration"
    sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /home/roboshop/cart/systemd.service &>> $LOG
    CHECK_STAT $?

    PRINT "setup systemd configuration"
    mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service && systemctl daemon-reload &>> $LOG
    CHECK_STAT $?

    PRINT "start ${component} service"
    systemctl enable ${component} &>>$LOG && systemctl start ${component} &>>$LOG
    CHECK_STAT $?
}

SYSTEMD

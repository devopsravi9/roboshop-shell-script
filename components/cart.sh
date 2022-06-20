#!/usr/bin/bash

source components/common.sh
CHECK_ROOT

echo "setting nodejs YUM repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOG
CHECK_STAT $?

echo "installing nodejs"
yum install nodejs -y &>> $LOG
CHECK_STAT $?

echo "creating roboshop user"
useradd roboshop &>> $LOG
CHECK_STAT $?

echo "downloading cart content"
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" &>> $LOG
CHECK_STAT $?

cd /home/roboshop
rm -rf cart

echo "unziping cart file"
unzip -o /tmp/cart.zip &>> $LOG
CHECK_STAT $?

mv cart-main cart
cd cart

echo "installing nodejs depedencies for cart component"
npm install &>> $LOG
CHECK_STAT $?

# Update `REDIS_ENDPOINT` with REDIS server IP Address
# Update `CATALOGUE_ENDPOINT` with Catalogue server IP address

echo "updating systemD configuration"
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /home/roboshop/cart/systemd.service &>> $LOG
CHECK_STAT $?

mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service

systemctl daemon-reload
systemctl start cart

echo "start cart service"
systemctl enable cart &>> $LOG
CHECK_STAT $?



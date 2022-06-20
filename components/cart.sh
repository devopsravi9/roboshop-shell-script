#!/usr/bin/bash

source components/common.sh
CHECK_ROOT

echo "setting nodejs YUM repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOG
CHECK_STAT $?

yum install nodejs -y
useradd roboshop
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip"
cd /home/roboshop
rm -rf cart
unzip -o /tmp/cart.zip
mv cart-main cart
cd cart
npm install

# Update `REDIS_ENDPOINT` with REDIS server IP Address
# Update `CATALOGUE_ENDPOINT` with Catalogue server IP address

sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /home/roboshop/cart/systemd.service
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service
systemctl daemon-reload
systemctl start cart
systemctl enable cart

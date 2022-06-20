#!/usr/bin/bash

CHECK_ROOT () {
  USER_ID=$(id -u)
if [ $USER_ID -ne 0 ]; then
    echo you are not a root user
    echo you can run the script as root user or use sudo command
    exit 1
fi
}

CHECK_ROOT
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
useradd roboshop
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
cd /home/roboshop
rm -rf catalogue
# removing catalogue file for smooth re run code
unzip -o /tmp/catalogue.zip
# -o added for overwrite existing during re run of code
mv catalogue-main catalogue
cd /home/roboshop/catalogue
npm install


#    Update `MONGO_DNSNAME` with MongoDB Server IP
sed -ie 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/catalogue/systemd.service
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
systemctl daemon-reload
systemctl start catalogue
systemctl enable catalogue



}
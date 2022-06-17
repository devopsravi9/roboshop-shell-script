#!/usr/bin/bash


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
sed -i -e 's/MONGO_DNSNAME/mogodb.roboshop.internal/' /home/roboshop/catalogue/systemd.service
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
systemctl daemon-reload
systemctl start catalogue
systemctl enable catalogue



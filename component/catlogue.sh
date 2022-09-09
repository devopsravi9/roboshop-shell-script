source component/common.sh
CHECKROOT
LOG

PRINT "downloading nodejs repo file"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOG
CHECKSTAT $?

PRINT "installing nodejs "
yum install nodejs -y &>> $LOG
CHECKSTAT $?

PRINT "add roboshop user"
useradd roboshop &>> $LOG
CHECKSTAT $?

PRINT "download catalogue schema files"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>> $LOG
CHECKSTAT $?

PRINT "organizing catalogue schema files"
cd /home/roboshop && unzip -o /tmp/catalogue.zip &>> $LOG && mv catalogue-main catalogue && cd /home/roboshop/catalogue
CHECKSTAT $?

PRINT "install nodejs dependencies"
npm install &>> $LOG
CHECKSTAT $?

PRINT "managing systemd files"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
CHECKSTAT $?

PRINT "daemon-reload, enable, start catalogue"
systemctl daemon-reload &>> $LOG && systemctl start catalogue && systemctl enable catalogue &>> $LOG
CHECKSTAT $?

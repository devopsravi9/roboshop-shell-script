source component/common.sh


CHECKROOT
LOG

PRINT "setting mongo repo file"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>> $LOG
CHECKSTAT $?

PRINT "installing mongod"
yum install -y mongodb-org &>> $LOG
CHECKSTAT $?

PRINT "updating listen ip address"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOG
CHECKSTAT $?

PRINT "enable & start mongod"
systemctl enable mongod &>> $LOG && systemctl start mongod &>> $LOG
CHECKSTAT $?

PRINT "download mongod schema files"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>> $LOG
CHECKSTAT $?

PRINT "organizing mongod schema files"
cd /tmp && unzip -o mongodb.zip  &>> $LOG && cd mongodb-main
CHECKSTAT $?

PRINT "load catlogue & users schema file to mongod"
mongo < catalogue.js &>> $LOG &&  mongo < users.js &>> $LOG
CHECKSTAT $?






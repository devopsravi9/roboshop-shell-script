source component/common.sh


CHECKROOT
LOG

PRINT "setting mongo repo file"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>> $LOG
CHECKSTAT

PRINT "installing mongod"
yum install -y mongodb-org &>> $LOG
CHECKSTAT

PRINT "enable & start mongod"
systemctl enable mongod && systemctl start mongod &>> $LOG
CHECKSTAT



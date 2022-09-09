CHECKROOT
LOG

PRINT "setting mongo repo file"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>> $LOG
CHeCKSTAT

# yum install -y mongodb-org
# systemctl enable mongod
# systemctl start mongod

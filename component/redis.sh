source component/common.sh
CHECKROOT
LOG

PRINT "downloading redis repo file"
curl -L -o /etc/yum.repos.d/redis.repo https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo &>> $LOG
CHECKSTAT $?

PRINT "installing redis "
yum install redis-6.2.7 -y &>> $LOG
CHECKSTAT $?

PRINT "update listening ip address URLs"
sed -i -e '/^bind/s/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf && sed -i -e '/^bind/s/127.0.0.1/0.0.0.0/' /etc/redis.conf &>> $LOG
CHECKSTAT $?

PRINT " enable, start redis"
systemctl enable redis && systemctl start redis &>> $LOG
CHECKSTAT $?


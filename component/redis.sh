source component/common.sh
CHECKROOT
LOG

PRINT "downloading redis repo file"
curl -L -o /etc/yum.repos.d/redis.repo https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo
CHECKSTAT $?

PRINT "installing redis "
yum install redis-6.2.7 -y
CHECKSTAT $?
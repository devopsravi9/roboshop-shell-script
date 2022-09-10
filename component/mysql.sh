source component/common.sh
CHECKROOT
LOG

PRINT "downloding mysql repo file"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>> $log
CHECKSTAT $?

PRINT "installing mysql"
yum install mysql-community-server -y &>> $log
CHECKSTAT $?

# systemctl enable mysqld
# systemctl start mysqld

PRINT "getting temporary password"
grep temp /var/log/mysqld.log
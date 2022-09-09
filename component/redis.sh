source component/common.sh
CHECKROOT
LOG

curl -L -o /etc/yum.repos.d/redis.repo https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo
yum install redis-6.2.7 -y

sed -i -e ''
systemctl enable redis
systemctl start redis
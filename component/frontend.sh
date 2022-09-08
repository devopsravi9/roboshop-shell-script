
source component/common.sh

touch /tmp/out
yum install nginx -y &>> /tmp/out
x=$?
CHECKSTAT $x

systemctl enable nginx &>> /tmp/out
x=$?
CHECKSTAT $x

systemctl start nginx &>> /tmp/out
x=$?
CHECKSTAT $x

curl -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>> /tmp/out
x=$?
CHECKSTAT $x

cd /usr/share/nginx/html &>> /tmp/out
x=$?
CHECKSTAT $x

rm -rf * &>> /tmp/out
x=$?
CHECKSTAT $x

unzip /tmp/frontend.zip &>> /tmp/out
x=$?
CHECKSTAT $x

mv frontend-main/static/* . &>> /tmp/out
x=$?
CHECKSTAT $x

mv frontend-main/localhost.conf /etc/nginx/system.d/roboshop.conf &>> /tmp/out
x=$?
CHECKSTAT $x

systemctl restart nginx &>> /tmp/out
x=$?
CHECKSTAT $x

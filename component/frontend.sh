
source component/common.sh

yum install nginx -y
x=$?
CHECKSTAT $x

systemctl enable nginx
x=$?
CHECKSTAT $x

systemctl start nginx
x=$?
CHECKSTAT $x

curl -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
x=$?
CHECKSTAT $x

cd /usr/share/nginx/html
x=$?
CHECKSTAT $x

rm -rf *
x=$?
CHECKSTAT $x

unzip /tmp/frontend.zip
x=$?
CHECKSTAT $x

mv frontend-main/static/* .
x=$?
CHECKSTAT $x

mv frontend-main/localhost.conf /etc/nginx/system.d/roboshop.conf
x=$?
CHECKSTAT $x

systemctl restart nginx
x=$?
CHECKSTAT $x

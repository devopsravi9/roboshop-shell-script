
source component/common.sh


PRINT "installing nginx"
yum install nginx -y
CHECKSTAT $?

PRINT "downloading frontend component"
curl -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
CHECKSTAT $?

PRINT "clearing old content"
cd /usr/share/nginx/html && rm -rf *
CHECKSTAT $?

PRINT "organizing the content"
unzip /tmp/frontend.zip && mv frontend-main/static/* . && mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf
CHECKSTAT $?

PRINT "enable & start service"
systemctl enable nginx && systemctl start nginx
CHECKSTAT $?


source component/common.sh


PRINT "installing nginx"
yum install nginx -y &>> $LOG
CHECKSTAT $?

PRINT "downloading frontend component"
curl -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>> $LOG
CHECKSTAT $?

PRINT "clearing old content"
cd /usr/share/nginx/html && rm -rf *
CHECKSTAT $?

PRINT "organizing the content"
unzip /tmp/frontend.zip && mv frontend-main/static/* . && mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>> $LOG
CHECKSTAT $?

PRINT "enable & start service"
systemctl enable nginx && systemctl start nginx
CHECKSTAT $?

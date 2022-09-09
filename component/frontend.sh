
source component/common.sh

CHECKROOT
LOG

PRINT "installing nginx"
yum install nginx -y &>> $LOG
CHECKSTAT $?

PRINT "downloading frontend component"
curl -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>> $LOG
CHECKSTAT $?

PRINT "clearing old content"
cd /usr/share/nginx/html && rm -rf *
CHECKSTAT $?

PRINT "extracting the content"
unzip -o /tmp/frontend.zip  &>> $LOG
CHECKSTAT $?

PRINT "organizing the content"
mv frontend-main/static/* . && mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>> $LOG
CHECKSTAT $?

PRINT "enable & start service"
systemctl enable nginx  &>> $LOG && systemctl start nginx &>> $LOG
CHECKSTAT $?



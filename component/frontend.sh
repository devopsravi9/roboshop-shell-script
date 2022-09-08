
source component/common.sh

touch /tmp/out
echo installing nginx ------------
yum install nginx -y
x=$?
CHECKSTAT $x

echo enable nginx --------------------
systemctl enable nginx
x=$?
CHECKSTAT $x

echo start nginx ---------------------
systemctl start nginx
x=$?
CHECKSTAT $x

echo download frontend zip file -----------------
curl -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
x=$?
CHECKSTAT $x

echo cd to html ----------------------
cd /usr/share/nginx/html
x=$?
CHECKSTAT $x

echo remove old content ----------------------
rm -rf *
x=$?
CHECKSTAT $x

echo unzip frontend ------------------------------
unzip /tmp/frontend.zip
x=$?
CHECKSTAT $x

echo move frontend-----------------
mv frontend-main/static/* .
x=$?
CHECKSTAT $x

pwd
ls
echo move conf file ----------------------------
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf
x=$?
CHECKSTAT $x

echo restart nginx ----------------------------
systemctl restart nginx
x=$?
CHECKSTAT $x

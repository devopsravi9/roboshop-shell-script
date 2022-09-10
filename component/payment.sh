source component/common.sh
CHECKROOT
LOG
COMPONENT=payment

PRINT "installing python3"
yum install python36 gcc python3-devel -y &>> $LOG
CHECKSTAT $?

APP_COMMON_SETUP

PRINT "installing python dependencies"
pip3 install -r requirements.txt &>> $LOG
CHECKSTAT $?

USER=$(id -u roboshop)
GROUP=$(id -g roboshop)

sed -i -e "/uid/ s/1/${USER}/" -e "/gid/ c gid = ${GROUP}" /home/roboshop/${COMPONENT}/payment.ini

SYSTEMD
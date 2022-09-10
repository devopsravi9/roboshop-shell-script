source component/common.sh
CHECKROOT
LOG
COMPONENT=payment

PRINT "installing python3"
yum install python36 gcc python3-devel -y
CHECKSTAT $?

APP_COMMON_SETUP

PRINT "installing python dependencies"
pip3 install -r requirements.txt
CHECKSTAT $?

sed -i -e "/uid/ c /${USER}" -e "/gid/ c /${GROUP}" /${COMPONENT}/payment.ini

# Update the roboshop user and group id in payment.ini file.

SYSTEMD
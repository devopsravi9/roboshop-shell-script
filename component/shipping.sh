source component/common.sh

CHECKROOT
LOG
COMPONENT=shipping

PRINT "installing java"
yum install maven -y &>> $LOG
CHECKSTAT $?

APP_COMMON_SETUP

PRINT "install java dependencies"
mvn clean package
CHECKSTAT $?

PRINT "loading shiiping schema"
mv target/shipping-1.0.jar shipping.jar
CHECKSTAT $?

SYSTEMD

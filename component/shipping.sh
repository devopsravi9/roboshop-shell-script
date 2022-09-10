source component/common.sh

CHECKROOT
LOG
COMPONENT=shipping

PRINT "installing java"
yum install maven -y &>> $LOG
CHECKSTAT $?

APP_COMMON_SETUP

PRINT "install java dependencies"
mvn clean package &>> $LOG
CHECKSTAT $?

PRINT "loading shipping schema"
mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar
CHECKSTAT $?

SYSTEMD

source component/common.sh
CHECKROOT
LOG
COMPONENT=dispatch

PRINT "installing go lang"
yum install golang -y &>> $LOG
CHECKSTAT $?

APP_COMMON_SETUP

go mod init dispatch &>> $LOG
go get &>> $LOG
go build &>> $LOG

SYSTEMD
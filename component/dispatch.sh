source component/common.sh
CHECKROOT
LOG
COMPONENT=dispatch

PRINT "installing go land"
yum install golang -y &>> $LOG
CHECKSTAT $?

APP_COMMON_SETUP

go mod init dispatch
go get
go build

source component/common.sh
CHECKROOT
LOG

PRINT "setup rabbitmq repo file"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>> ${LOG}
CHECKSTAT $?

PRINT "downloding erlang depenencies"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &>> ${LOG}
CHECKSTAT $?

PRINT "installing rabbitmq"
yum install rabbitmq-server -y &>> ${LOG}
CHECKSTAT $?

PRINT "enable & start rabbitmq"
systemctl enable rabbitmq-server  &>> ${LOG} && systemctl start rabbitmq-server
CHECKSTAT $?

rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_user_tags roboshop administrator
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"


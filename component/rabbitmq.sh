source component/common.sh
CHECKROOT
LOG
RABBITMQ_PASSWORD=roboshop123

if [ -z ${RABBITMQ_PASSWORD} ]; then
  echo "need a RABBITMQ_PASSWORD env variable"
fi

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

sudo rabbitmqctl list_users | grep roboshop
if [ $? -ne 0 ]; then
  PRINT "adding roboshop user"
  rabbitmqctl add_user roboshop "${RABBITMQ_PASSWORD}"
  CHECKSTAT $?
fi

rabbitmqctl set_user_tags roboshop administrator
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"


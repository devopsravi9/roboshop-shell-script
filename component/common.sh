CHECKROOT () {
if [ $(id -u) -ne 0 ]; then
  echo -e "\e[31m run as ROOT user or use SUDO command \e[0m"
  exit 2
fi
}


CHECKSTAT () {
  if [ $1 -ne 0 ]; then
    echo -e "\e[31m failure \e[0m"
    exit 1
  else
    echo  -e "\e[32m SUCESS \e[0m"
    echo -e "-------------------------------------------------------------------- \n  " &>> $LOG
  fi
}

PRINT () {
  echo -e "-------------------\e[31m $1 \e[0m-----------------------" &>> $LOG
  echo $1
}

LOG () {
LOG=/tmp/robo.log
rm -rf $LOG
}
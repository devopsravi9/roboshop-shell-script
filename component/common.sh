CHECKSTAT () {
  if [ $1 -ne 0 ]; then
    echo -e "\e[31m failure \e[0m"
    exit 1
  else
    echo  -e "\e[32m SUCESS \e[0m"
    echo "-------------------------------------------------------------- \n" &>> $LOG
  fi
}

PRINT () {
  echo "--------------------------$1---------------------------------" &>> $LOG
  echo $1
}

touch /tmp/robo.log
LOG=/tmp/robo.log
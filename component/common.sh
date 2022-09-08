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

cat /tmp/robo.log &> /dev/null
if [ $? -ne 0 ]; then
  touch /tmp/robo.log
else
 rm -rf /tmp/robo.log/*
fi

LOG=/tmp/robo.log
#!/usr/bin/bash

CHECK_ROOT () {
  USER_ID=$(id -u)
if [ $USER_ID -ne 0 ] ; then
    echo -e "\e[31m you should run this script as root user or use sudo in command. \e[0m"
    exit 2
fi
}

CHECK_STAT () {
  echo "-------------------------------" &>> $LOG
  if [ $1 -ne 0 ] ; then
      echo -e "\e[31m FAILURE \e[0m"
      echo -e "\n check log file $LOG for errors \n"
      exit 2
  else
    echo -e "\e[33m SUCCESS \e[0m"
fi
}

PRINT () {
  echo "---------$1---------" &>> $LOG
  echo $1
}

LOG=/tmp/roboshop.log
rm -f $LOG









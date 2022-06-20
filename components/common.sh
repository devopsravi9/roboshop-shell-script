#!/usr/bin/bash

CHECK_ROOT () {
  USER_ID=$(id -u)
if [ $USER_ID -ne 0 ]; then
    echo -e "\e[31m you should run this script as root user or use sudo in command. \e[0m"
    exit 2
fi
}

CHECK_STAT () {
  if [ $1 -ne 0 ]; then
    echo -e "\e[31m FAILURE \e[0m"
    exit 2
  else
    echo "\e[33m SUCCESS \e[0m"
}

LOG=/tmp/roboshop
rm -f $LOG
#!/usr/bin/bash

CHECK_ROOT () {
  USER_ID=$(id -u)
if [ $USER_ID -ne 0 ]; then
    echo you are not a root user
    echo you can run the script as root user or use sudo command
    exit 2
fi
}
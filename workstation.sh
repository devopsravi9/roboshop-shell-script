#! /usr/bin/bash
sudo su
set-hostname workstation
pip3 install botocore boto3
yum install java-11-openjdk
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
#labauto sonar scanner
#yum install maven-y


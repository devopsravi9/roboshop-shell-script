#!/bin/bash

##### Change these values ###
ZONE_ID="Z04748881QTGM14CJWM7A"
SG_NAME="allow-all-to-public"
#############################


if [ -z "${1}" ]; then
  ENV= ""
else
  ENV="${1}-"
fi

COMPONENT=all
create_ec2() {
  PRIVATE_IP=$(aws ec2 run-instances \
      --image-id ${AMI_ID} \
      --instance-type t3.micro \
      --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${ENV}${COMPONENT}},{Key=monitor,Value=yes}]" \
      --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}"\
      --security-group-ids ${SGID} \
      --iam-instance-profile="${IAM_INSTANCE_PROFILE}" \
      | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')

  sed -e "s/IPADDRESS/${PRIVATE_IP}/" -e "s/COMPONENT/${ENV}${COMPONENT}/" route53.json >/tmp/record.json
  aws route53 change-resource-record-sets --hosted-zone-id ${ZONE_ID} --change-batch file:///tmp/record.json | jq
}

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-7-DevOps-Practice" | jq '.Images[].ImageId' | sed -e 's/"//g')
SGID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=${SG_NAME} | jq  '.SecurityGroups[].GroupId' | sed -e 's/"//g')

if [ "$COMPONENT" == "all" ]; then
  for component in catalogue cart user shipping payment frontend mongodb mysql rabbitmq redis ; do
    COMPONENT=$component
    create_ec2
  done
else
  create_ec2
fi



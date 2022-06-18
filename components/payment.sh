yum install python36 gcc python3-devel -y
useradd roboshop
cd /home/roboshop
curl -L -s -o /tmp/payment.zip "https://github.com/roboshop-devops-project/payment/archive/main.zip"
rm -rf payment
unzip -0 /tmp/payment.zip
mv payment-main payment
cd /home/roboshop/payment
pip3 install -r requirements.txt

sed -i -e 's/CARTHOST/cart.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/' -e 's/AMQPHOST/rabbitmq.roboshop.internal/' /home/roboshop/payment/systemd.service
mv /home/roboshop/payment/systemd.service /etc/systemd/system/payment.service
systemctl daemon-reload
systemctl enable payment
 systemctl start payment

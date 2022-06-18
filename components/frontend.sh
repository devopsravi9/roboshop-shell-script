#!/usr/bin/bash


yum install nginx -y
systemctl enable nginx
systemctl start nginx

curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
cd /usr/share/nginx/html
rm -rf *
unzip -o /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md

mv localhost.conf /etc/nginx/default.d/roboshop.conf
systemctl restart nginx

sed -i -e '/api\/catalogue/ s/localhost/catalogue.roboshop.internal/' /etc/nginx/default.d/roboshop.conf
sed -i -e '/api\/user/ s/localhost/user.roboshop.internal/' /etc/nginx/default.d/roboshop.conf
sed -i -e '/api\/cart/ s/localhost/cart.roboshop.internal/' /etc/nginx/default.d/roboshop.conf
sed -i -e '/api\/shipping/ s/localhost/shipping.roboshop.internal/' /etc/nginx/default.d/roboshop.conf
sed -i -e '/api\/payment/ s/localhost/payment.roboshop.internal/' /etc/nginx/default.d/roboshop.conf

#systemctl daemon-reload
#systemctl restart nginx
#    location /api/catalogue/ { proxy_pass http://localhost:8080/; }

   # location /api/user/ { proxy_pass http://localhost:8080/; }

  #  location /api/cart/ { proxy_pass http://localhost:8080/; }

 #   location /api/shipping/ { proxy_pass http://localhost:8080/; }

#    location /api/payment/ { proxy_pass http://localhost:8080/; }

#!/bin/bash

echo "starting frontend"

user_id=$(id -u)
if [ $user_id -ne 0 ]; then
  echo -e "\e[33m you needs to be root user to perform this\e[0m]" \n\t\t Example: sudo <filename>
  exit 1
fi  

echo "installing nginx"

yum install nginx -y
systemctl enable nginx
systemctl start nginx
exit 2

<<comm
# yum install nginx -y
# systemctl enable nginx
# systemctl start nginx


# curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

# cd /usr/share/nginx/html
# rm -rf *
# unzip /tmp/frontend.zip
# mv frontend-main/* .
# mv static/* .
# rm -rf frontend-main README.md
# mv localhost.conf /etc/nginx/default.d/roboshop.conf
comm
exit 2
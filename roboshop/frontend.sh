#!/bin/bash

echo "i am frontend"

yum install nginx -y

user_id=$(id -u)

if [[ $user_id -ne 0 ]]
then
  echo -e "\e[32m you have signed as normall user \e[0m"
  exit 1
else
  echo  -e "\e[33m kindly switch into root user to make changes \e[0m"
fi     

# systemctl enable nginx 
# systemctl start nginx 


# curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"


# cd /usr/share/nginx/html
# rm -rf * 
# unzip /tmp/frontend.zip
# mv frontend-main/* .
# mv static/* .
# rm -rf frontend-master README.md
# mv localhost.conf /etc/nginx/default.d/roboshop.conf


# systemctl restart nginx 
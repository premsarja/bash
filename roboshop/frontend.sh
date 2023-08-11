#!/bin/bash

echo "i am frontend"

yum install nginx -y

user_id=$(id -u)

if [[ $user_id -ne 0 ]]
then
  echo -e "\e[32m you have signed as normall user to make change perform as root \n \t EXAMPLE: sudo <scriptname> \e[0m"
  exit 1
fi     


echo "configuring frontend"

yum install nginx -y &>> /tmp/frontend.log && echo $date

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
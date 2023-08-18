#!/bin/bash 

user_id=$(id -u)

if [ $user_id -ne 0 ]; then
  echo -e "\e[32m script is executed by the root user or with sudo privilege \e[0m"
  exit 1
fi

echo -e "\e[35m configuring frontend \e[0m \n"
echo -n "installing frontend :"
yum install nginx -y >> /tmp/frontend.log
if [ $? -eq 0 ]; then
  echo -e "\e[33m sucessfully installed \e[0m"
else
  echo -e "\e[31m failed \e[0m"  
fi

echo -n "starting nginx"
systemctl enable nginx
systemctl start nginx

if [ $? -eq 0 ]; then
  echo -e "\e[33m sucessfully installed \e[0m"
else
  echo -e "\e[31m failed \e[0m"  
fi


echo -n "downloading the frontend component"

curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

if [ $? -eq 0 ]; then
  echo -e "\e[33m sucessfully installed \e[0m"
else
  echo -e "\e[31m failed \e[0m"  
fi
#!/bin/bash 

set -e

user_id=$(id -u)
component=mongodb
LOGFILE="/tmp/${component}.log"

if [ $user_id -ne 0 ]; then
  echo -e "\e[32m script is executed by the root user or with sudo privilege \e[0m"
  exit 1
fi

statusfunction(){

    if [ $1 -eq 0 ]; then
       echo -e "\e[33m sucessfully installed \e[0m"
    else
       echo -e "\e[31m failed \e[0m"  
       exit 2
    fi
}


echo -e "\e[35m configuring ${component}\e[0m"

echo -n "configuring ${component}  repo:"

curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo
statusfunction $?

echo "hi hello"
echo -n "installing ${component} :  "
yum install -y mongodb-org 
statusfunction $?

echo -n "Enabling the ${component} visibility :"
sed  -ie 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
statusfunction $?

echo -n "starting mongodb: "
systemctl enable mongod
systemctl start mongod
statusfunction $?

echo -n "Downloading the ${component} schema: "
curl -s -L -o /tmp/${component}.zip "https://github.com/stans-robot-project/${component}/archive/main.zip" 
statusfunction $?

echo -n "Extracing the ${component} Schema:"
cd /tmp 
unzip -o ${component}.zip &>> ${LOGFILE} 
statusfunction $?

echo -n "Injecting ${component} Schema:"
cd ${component}-main
mongo < catalogue.js    &>>  ${LOGFILE}
mongo < users.js        &>>  ${LOGFILE}
statusfunction $?

echo -e "\e[35m ${component} Installation Is Completed \e[0m \n"

for i in {1..12};do
  touch "$i"
done  
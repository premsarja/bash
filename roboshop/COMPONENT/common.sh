#!/bin/bash

#all the common functions are declared here

set -e

APPUSER="roboshop"
LOGFILE="/tmp/${COMPONENT}.log"

USER_ID=$(id -u)

if [ $USER_ID -ne 0 ]; then
  echo -e "\e[32m script is executed by the root user or with sudo privilege \e[0m"
  exit 1
fi

statusfunction() {
    if [ $? -eq 0 ]; then 
        echo -e "\e[32m success \e[0m"
    else 
        echo -e "\e[31m failure \e[0m"
        exit 2
    fi
}


statusfunction() {

    if [ $? -eq 0 ]; then
       echo -e "\e[33m sucessfully installed \e[0m"
    else
       echo -e "\e[31m failed \e[0m"  
       exit 1
    fi
}

#creating user function


CREATE_USER() {
        # useradd ${APPUSER}  &>> ${LOGFILE} 
        id ${APPUSER}  &>> ${LOGFILE} 
            if [ $? -ne 0 ] ; then 
            echo -n "Creating Application User Account :"
            useradd roboshop 
            statusfunction $? 
        fi    
}
#downloading COMPONENT and extracting 

downloading_and_extracting() {
echo -n "downlaoding the ${COMPONENT} : "
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"
cd /home/${APPUSER}
rm -rf ${COMPONENT}  &>> ${LOGFILE} 
unzip -o /tmp/${COMPONENT}.zip
statusfunction $?

mv ${COMPONENT}-main ${COMPONENT}
chown -R ${APPUSER}:${APPUSER} /home/${APPUSER}/${COMPONENT}
statusfunction $?
}

config_service() {
echo -n "updating the ${COMPONENT} systemfile: "
# sed -ie 's/MONGO_DNSNAME/172.31.45.60/g' /home/${APPUSER}/${COMPONENT}/systemd.service
sed -ie 's/CARTENDPOINT/cart.roboshop-internal/g' /home/${APPUSER}/${COMPONENT}/systemd.service
sed -ie 's/DB_HOST/mysql.roboshop-internal/g' /home/${APPUSER}/${COMPONENT}/systemd.service
# sed -ie "s/REDIS_ENDPOINT/redis.roboshop-internal/g" /home/roboshop/${COMPONENT}/systemd.service
# sed -ie "s/MONGO_ENDPOINT/mongodb.roboshop-internal/g" /home/roboshop/${COMPONENT}/systemd.service

# sed -ie "s/CATALOGUE_ENDPOINT/catalogue.roboshop-internal/g" /home/roboshop/${COMPONENT}/systemd.service
mv /home/${APPUSER}/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
echo -n "changing the ownership : "
statusfunction $?


echo -n "starting the ${COMPONENT} service: "
systemctl daemon-reload
systemctl start ${COMPONENT}  &>> ${LOGFILE}
systemctl enable ${COMPONENT}  &>> ${LOGFILE}
systemctl status ${COMPONENT} -l  &>> ${LOGFILE}
statusfunction $?
}

#creating nodejs npm install -g npm@latest

NODEJS() {
echo -e "\e[35m configuring ${COMPONENT} \e[0m"

echo -n "configuring ${COMPONENT} repo :"
curl --silent --location https://rpm.nodesource.com/setup_16.x |sudo bash - &>> ${LOGFILE}
statusfunction $? 

echo -n "Installing NodeJS :"
yum install nodejs -y   &>> ${LOGFILE} 
statusfunction $?

CREATE_USER   #calls create_user function that creates user account

downloading_and_extracting  #download and extract the COMPONENT

echo -n "generating the ${COMPONENT} artifacts :"
cd /home/${APPUSER}/${COMPONENT}/
npm install &>> ${LOGFILE}
statusfunction $?

config_service
}

MVN_PACKAGE() {
        echo -n "Generating the ${COMPONENT} artifacts :"
        cd /home/${APPUSER}/${COMPONENT}/
        mvn clean package   &>> ${LOGFILE}
        mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar
        statusfunction $?
}

JAVA() {
        echo -e "\e[35m Configuring ${COMPONENT} ......! \e[0m \n"

        echo -n "Installing maven:"
        yum install maven -y    &>> ${LOGFILE}
        statusfunction $? 

        CREATE_USER              # calls CREATE_USER function that creates user account.

        downloading_and_extracting     # Downloads and extracts the COMPONENTs

        MVN_PACKAGE

        config_service

}

PYTHON() {
        echo -e "\e[35m Configuring ${COMPONENT} ......! \e[0m \n"

        echo -n "Installing python:"
        yum install python36 gcc python3-devel -y &>> ${LOGFILE}
        statusfunction $? 

        create_user              # calls CREATE_USER function that creates user account.

        downloading_and_extracting     # Downloads and extracts the COMPONENTs

        echo -n "Generating the artifacts"
        cd /home/${APPUSER}/${COMPONENT}/ 
        pip3 install -r requirements.txt    &>> ${LOGFILE} 
        statusfunction $?

        user_id=$(id -u roboshop)
        GROUPID=$(id -g roboshop)

        echo -n "Updating the uid and gid in the ${COMPONENT}.ini file"
        sed -i -e "/^uid/ c uid=${user_id}" -e "/^gid/ c gid=${GROUPID}" /home/${APPUSER}/${COMPONENT}/${COMPONENT}.ini
        statusfunction $?

        config_service
}
set -x
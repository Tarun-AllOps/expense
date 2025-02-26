#!/bin/bash

#LogFolder creation
logFolder="/var/log/expense-logs"
fileName=$(echo $0 | cut -d "." -f1)
timeStamp=$(date +%Y-%m-%d-%H-%M-%S)
logFile="$logFolder/$fileName-$timeStamp.log"
mkdir -p $logFolder

#colors
r="\e[31m"
g="\e[32m"
y="\e[33m"
n="\e[0m"

userId=$(id -u)

CHECK_USER(){
    if [ $userId -ne 0 ];then
        echo "$r This command requires superuser mode. $n" | tee -a $logFile
        exit 1
    fi
}

VALIDATE(){
    if [ $1 -eq 0 ];then
        echo "$2 .....is SUCCESS" | tee -a $logFile
    else
        echo "$2 .....is FAILED" | tee -a $logFile
        exit 1
    fi
}

CHECK_USER

dnf install mysql-server -y
VALIDATE $? "Installing mysql-server"

systemctl enable mysqld
VALIDATE $? "Enableing mysql"

systemctl start mysqld
VALIDATE $? "Staring mysql"


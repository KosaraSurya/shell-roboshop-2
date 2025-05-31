#!bin/bash

source ./common.sh
app_name="payment"

CHECK_ROOT
app_name
system_setup


    dnf install python3 gcc python3-devel -y
    VALIDATE $? "Install Python3 packages"

    pip3 install -r requirements.txt 
    VALIDATE $? "Installing dependencies"
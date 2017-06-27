#!/bin/sh

# check if aws credentials already exist
if [ -f ".aws/credentials" ]
then
    echo "aws credentials already exist"
else
    mkdir .aws    
    cp secure/.aws/* .aws/
fi

# if needed, isntall backup public key
if  gpg -k | grep "<mykey>" 
then
    echo "backup key found"
else
    gpg --trust-model always --import secure/<keyfile>
fi

# check if mysqlbackup is already set up
if  crontab -l | grep 'mysqlbackup' 
then
    echo "cron already set up."
else
    # set mysqlbackup to run every tuesday (* * * * 2 = tuesday)
    (crontab -l 2>/dev/null; echo "* * * * 2 mysqlbackup.sh ") | crontab -
    echo "cron now set up"
fi
# show that now script is scheduled
crontab -l | grep 'mysqlbackup'

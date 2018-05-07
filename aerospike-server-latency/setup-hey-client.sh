#!/bin/bash

apt-get update
mkdir /root/setup-logs

# download and install Go
printf "\nDownload and install Go...\n" >> /root/setup-logs/hey-installation.log
cd /root
wget https://dl.google.com/go/go1.10.2.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.10.2.linux-amd64.tar.gz
echo export PATH=$PATH:/usr/local/go/bin >> /etc/profile
source /etc/profile
printf "\nChecking version of Go...\n"  >> /root/setup-logs/hey-installation.log
go version 2>> /root/setup-logs/hey-installation.log >> /root/setup-logs/hey-installation.log
if [ $? > 0 ]
then
    printf "\n[Retry] Checking version of Go...\n" >> /root/setup-logs/hey-installation.log
    /usr/local/go/bin/go version 2>> /root/setup-logs/hey-installation.log >> /root/setup-logs/hey-installation.log
fi
printf "\nChecking GOPATH...\n" >> /root/setup-logs/hey-installation.log
gopath=$(/usr/local/go/bin/go env GOPATH)
if [ "$gopath" == "" ]
then    
    printf "\nGOPATH not set.\n" >> /root/setup-logs/hey-installation.log
    printf "\nSetting GOPATH...\n" >> /root/setup-logs/hey-installation.log
    echo export GOPATH=$HOME/go >> ~/.profile
    source ~/.profile
fi
echo $gopath >> /root/setup-logs/hey-installation.log

# install hey
printf "\nInstalling hey client...\n" >> /root/setup-logs/hey-installation.log
/usr/local/go/bin/go get -u -v github.com/rakyll/hey 2>> /root/setup-logs/hey-installation.log
printf "\nChecking hey client installation...\n" >> /root/setup-logs/hey-installation.log
ls -al /root/go/bin >> /root/setup-logs/hey-installation.log

# setup ulimit 
printf "\nSetting up ulimit...\n" >> /root/setup-logs/hey-installation.log
echo ulimit -n 635535 >> /etc/profile
source /etc/profile
ulimit -n 2>> /root/setup-logs/hey-installation.log >> /root/setup-logs/hey-installation.log
ulimit -a >> /root/setup-logs/hey-installation.log

# setup sysctl
printf "\nSetting up sysctl values...\n" >> /root/setup-logs/hey-installation.log
cat >> /etc/sysctl.conf << EOF
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
EOF
shutdown -r
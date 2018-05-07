#!/bin/bash

apt-get update
mkdir /root/setup-logs

# download and install Go
printf "\nDownload and install Go...\n"  >> /root/setup-logs/hey-installation.log
cd /root
wget https://dl.google.com/go/go1.10.2.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.10.2.linux-amd64.tar.gz
echo export PATH=$PATH:/usr/local/go/bin >> /etc/profile
source /etc/profile
go version >> /root/setup-logs/hey-installation.log

# install hey
printf "\nInstalling hey client...\n"  >> /root/setup-logs/hey-installation.log
go get -u -v github.com/rakyll/hey 2>>/root/setup-logs/hey-installation.log
ls -al /root/go/bin >> /root/setup-logs/hey-installation.log

# setup ulimit 
printf "\nSetting up ulimit...\n"  >> /root/setup-logs/hey-installation.log
echo ulimit -n 635535 >> /etc/profile
source /etc/profile
ulimit -a >> /root/setup-logs/hey-installation.log

# setup sysctl
printf "\nSetting up sysctl values...\n"  >> /root/setup-logs/hey-installation.log
cat >> /etc/sysctl.conf << EOF
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
EOF
shutdown -r
#!/bin/bash

apt-get update
mkdir /root/setup-logs

# download and install Go
cd /root
wget https://dl.google.com/go/go1.10.2.linux-amd64.tar.gz >> /root/setup-logs/hey-installation.log
tar -C /usr/local -xzf go1.10.2.linux-amd64.tar.gz
echo export PATH=$PATH:/usr/local/go/bin >> /etc/profile
source /etc/profile
go version >> /root/setup-logs/hey-installation.log

# install hey
go get -u -v github.com/rakyll/hey >> /root/setup-logs/hey-installation.log

# setup ulimit 
ulimit -n 65535

# setup sysctl
cat >> /etc/sysctl.conf << EOF
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
EOF
shutdown -r
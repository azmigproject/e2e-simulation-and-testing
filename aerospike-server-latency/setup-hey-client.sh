#!/bin/bash

apt-get update

# download and install Go
cd /root
wget https://dl.google.com/go/go1.10.2.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.10.2.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
echo export PATH=$PATH:/usr/local/go/bin >> /etc/profile
source /etc/profile
go version
export GOPATH=/root/go
echo GOPATH=$GOPATH

# install hey
go get -u -v github.com/rakyll/hey
ls -al /root/go/bin

# setup ulimit 
echo ulimit -n 635535 >> /etc/profile
source /etc/profile

# setup sysctl
cat >> /etc/sysctl.conf << EOF
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
EOF
shutdown -r
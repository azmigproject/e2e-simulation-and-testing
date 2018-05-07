#!/bin/bash

apt-get update
mkdir setup-logs

# install Aerospike server
pip install --upgrade pip >> setup-logs/aerospike-installation.log
wget -O aerospike-server.tgz https://www.aerospike.com/download/server/latest/artifact/ubuntu16 >> setup-logs/aerospike-installation.log
tar -zxvf aerospike-server.tgz
cd aerospike-server-community-*
./asinstall >> setup-logs/aerospike-installation.log

# Install Aerospike Management Console (AMC)
wget -O aerospike-management-console.deb https://www.aerospike.com/download/amc/latest/artifact/ubuntu12 >> setup-logs/aerospike-installation.log
dpkg -i aerospike-management-console.deb
apt-get -f install >> setup-logs/aerospike-installation.log

# Start Aerospike and AMC at start up
sed -i.bak '/exit 0/d' /etc/rc.local
cat >> /etc/rc.local << EOF
sudo service aerospike start
if [ $? != 0 ]
then
    exit $?
fi
sudo service amc start
if [ $? != 0 ]
then
    exit $?
fi
exit 0
EOF

# setup ulimit 
ulimit -n 65535

# setup sysctl
cat >> /etc/sysctl.conf << EOF
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
EOF
shutdown -r
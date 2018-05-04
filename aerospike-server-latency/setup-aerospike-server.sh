#!/bin/bash

# install Aerospike server
apt-get update
wget -O aerospike-server.tgz https://www.aerospike.com/download/server/latest/artifact/ubuntu16
tar -zxvf aerospike-server.tgz
cd aerospike-server-community-*
./asinstall

# Install Aerospike Management Console (AMC)
wget -O aerospike-management-console.deb https://www.aerospike.com/download/amc/latest/artifact/ubuntu12
dpkg -i aerospike-management-console.deb
apt-get -f install

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
reboot

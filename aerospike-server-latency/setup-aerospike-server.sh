#!/bin/bash

apt-get update
mkdir /root/setup-logs

# install Aerospike server
printf "\nDownload and install Aerospike server...\n" >> /root/setup-logs/aerospike-setup.log
pip install --upgrade pip >> /root/setup-logs/aerospike-setup.log
wget -O aerospike-server.tgz https://www.aerospike.com/download/server/latest/artifact/ubuntu16
tar -zxvf aerospike-server.tgz
cd aerospike-server-community-*
./asinstall >> /root/setup-logs/aerospike-setup.log

# Install Aerospike Management Console (AMC)
printf "\nDownload and install Aerospike Management Console...\n" >> /root/setup-logs/aerospike-setup.log
wget -O aerospike-management-console.deb https://www.aerospike.com/download/amc/latest/artifact/ubuntu12
dpkg -i aerospike-management-console.deb
apt-get -f install >> /root/setup-logs/aerospike-setup.log

# Start Aerospike and AMC at start up
printf "\nSetup to start Aerospike and AMC at start up...\n" >> /root/setup-logs/aerospike-setup.log
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
printf "\nSetting up ulimit...\n"  >> /root/setup-logs/aerospike-setup.log
echo ulimit -n 635535 >> ~/.bashrc
source ~/.bashrc
ulimit -a >> /root/setup-logs/aerospike-setup.log

# setup sysctl
printf "\nSetting up sysctl values...\n"  >> /root/setup-logs/aerospike-setup.log
cat >> /etc/sysctl.conf << EOF
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
EOF

printf "\nComplete.\nRestarting...\n"
shutdown -r
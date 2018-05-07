#!/bin/bash

apt-get update
mkdir /root/setup-logs

# install and setup Java client
printf "\nDownload and install Java client...\n" >> /root/setup-logs/java-client-installation.log
apt-get install -y openjdk-8* >> /root/setup-logs/java-client-installation.log
apt-get install -y maven maven* >> /root/setup-logs/java-client-installation.log
git clone https://github.com/aerospike/aerospike-client-java.git /root/aerospike-client-java >> /root/setup-logs/java-client-installation.log
cd /root/aerospike-client-java
cp pom.xml pom.xml.bak
dependency="<dependencies>\n<dependency>\n<groupId>com.aerospike</groupId>\n<artifactId>aerospike-client</artifactId>\n<version>4.0.6</version>\n</dependency>\n</dependencies>"
temp=$(echo $dependency | sed 's/\//\\\//g')
sed "/<\/project>/ s/.*/${temp}\n&/" pom.xml
more pom.xml >> /root/setup-logs/java-client-installation.log
./build_all >> /root/setup-logs/java-client-installation.log

# setup ulimit 
printf "\nSetting up ulimit...\n"  >> /root/setup-logs/java-client-installation.log
echo ulimit -n 635535 >> /etc/profile
source /etc/profile
ulimit -a >> /root/setup-logs/java-client-installation.log

# setup sysctl
printf "\nSetting up sysctl values...\n"  >> /root/setup-logs/java-client-installation.log
cat >> /etc/sysctl.conf << EOF
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
EOF

printf "\nComplete.\nRestarting...\n"
shutdown -r
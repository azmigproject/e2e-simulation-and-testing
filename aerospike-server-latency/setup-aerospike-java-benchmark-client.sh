#!/bin/bash

apt-get update
mkdir /root/setup-logs

# install and setup Java client
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
ulimit -n 65535

# setup sysctl
cat >> /etc/sysctl.conf << EOF
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
EOF
shutdown -r
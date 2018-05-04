#!/bin/bash
apt-get update -y
apt-get install -y openjdk-8*
apt-get install -y maven maven*
git clone https://github.com/aerospike/aerospike-client-java.git /root/aerospike-client-java
cd /root/aerospike-client-java
cp pom.xml pom.xml.bak
dependency="<dependencies>\n<dependency>\n<groupId>com.aerospike</groupId>\n<artifactId>aerospike-client</artifactId>\n<version>4.0.6</version>\n</dependency>\n</dependencies>"
temp=$(echo $dependency | sed 's/\//\\\//g')
sed "/<\/project>/ s/.*/${temp}\n&/" pom.xml
./build_all
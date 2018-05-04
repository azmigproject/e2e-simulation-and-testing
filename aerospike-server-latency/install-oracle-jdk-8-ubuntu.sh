#!/bin/bash
sudo apt-get update -y
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update -y
sudo apt-get install -y oracle-java9-installer
echo '\n' | sudo update-alternatives --config java
echo '\n' | sudo update-alternatives --config javac
echo '\n' | sudo update-alternatives --config javadoc
sudo cat >> /etc/environment << EOF
JAVA_HOME="/usr/lib/jvm/java-8-oracle/bin/java"
EOF
source /etc/environment
echo $JAVA_HOME
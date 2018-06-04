#!/bin/bash
service_name="$1"

# install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-cache policy docker-ce
apt-get install -y docker-ce

# create docker files
mkdir -p /root/$service_name
cd /root/$service_name
wget -O service2.war https://raw.githubusercontent.com/azmigproject/e2e-simulation-and-testing/master/jmeter-tests/docker-vm/webapps/$service_name.war
cat > DockerFile << EOF
FROM ubuntu:16.04
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install openjdk-8-jdk wget
RUN mkdir /usr/local/tomcat
RUN wget http://www-eu.apache.org/dist/tomcat/tomcat-8/v8.5.31/bin/apache-tomcat-8.5.31.tar.gz -O /tmp/tomcat.tar.gz
RUN cd /tmp && tar xvfz tomcat.tar.gz
RUN cp -Rv /tmp/apache-tomcat-8.5.31/* /usr/local/tomcat/
EXPOSE 8080
CMD /usr/local/tomcat/bin/catalina.sh run
COPY service2.war /usr/local/tomcat/webapps/service2.war
EOF
# create process in docker
docker build . -t $service_name
docker images
docker run -d --name=service2 -p 8882:8080 -t $service_name
docker ps

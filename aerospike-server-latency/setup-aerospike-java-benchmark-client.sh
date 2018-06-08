#!/bin/bash

apt-get update

# install and setup Java client
apt-get install -y openjdk-8*
apt-get install -y maven maven*
git clone https://github.com/aerospike/aerospike-client-java.git /root/aerospike-client-java
cd /root/aerospike-client-java
cp pom.xml pom.xml.bak
dependency="<dependencies>\n<dependency>\n<groupId>com.aerospike</groupId>\n<artifactId>aerospike-client</artifactId>\n<version>4.0.6</version>\n</dependency>\n</dependencies>"
temp=$(echo $dependency | sed 's/\//\\\//g')
sed "/<\/project>/ s/.*/${temp}\n&/" pom.xml
more pom.xml
./build_all

# setup ulimit 
echo ulimit -n 635535 >> /etc/profile
source /etc/profile
ulimit -a

# setup sysctl
cat >> /etc/sysctl.conf << EOF
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
EOF

# install and setup for Python web service
# install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-cache policy docker-ce
apt-get install -y docker-ce
# setup python
apt-get install -y python-dev libssl-dev python3-pip
pip3 install Flask aerospike
# create web-service directory, web-service file and docker file
mkdir /root/web-service
cd /root/web-service
cat > main.py << EOF
# import the module
from flask import Flask
from time import gmtime, strftime
import aerospike
import json

# Configure the client
config = {
  'hosts': [('10.0.0.4', 3000)]
}
# Records are addressable via a tuple of (namespace, set, key)
read_key = ('test', 'demo', 'foo')
write_key = ('test', 'demo', 'foo')
app = Flask(__name__)


@app.route("/write")
def write():
    # Create a client and connect it to the cluster
    try:
        client = aerospike.client(config).connect()
    except Exception as e:
        import sys
        error = "failed to connect to the cluster with {0} and {1}".format(
            config['hosts'], e)
        return json.dumps({"error": error}, sort_keys=True, indent=2)
        sys.exit(1)

    try:
        # Write a record
        data = {
            'name': 'John Doe',
            'age': 32,
            'timestamp': strftime("%Y-%m-%d %H:%M:%S", gmtime())
        }
        client.put(write_key, data)
    except Exception as e:
        import sys
        error = "{0}".format(e)
        return json.dumps({"error": error}, sort_keys=True, indent=2)

    # Close the connection to the Aerospike cluster
    client.close()
    return json.dumps({"record": data}, sort_keys=True, indent=2)


@app.route("/read")
def read():
    # Create a client and connect it to the cluster
    try:
        client = aerospike.client(config).connect()
    except Exception as e:
        import sys
        error = "failed to connect to the cluster with {0} and {1}".format(
            config['hosts'], e)
        return json.dumps({"error": error}, sort_keys=True, indent=2)
        sys.exit(1)

    # Read a record
    (key, metadata, record) = client.get(read_key)
    data = {
        "key": str(key),
        "metadata": metadata,
        "record": record,
        "timestamp": strftime("%Y-%m-%d %H:%M:%S", gmtime())
    }
    # Close the connection to the Aerospike cluster
    client.close()
    return json.dumps({"0": data}, sort_keys=True, indent=2)


if __name__ == "__main__":
    app.run()

EOF
# create docker file
cat > Dockerfile << EOF
FROM python:latest
RUN pip install Flask aerospike
WORKDIR /usr/local/bin
EXPOSE 5000
COPY main.py .
CMD ["python", "main.py"]
EOF
# create process in docker
docker build . -t python-web-service
docker images
docker run -d -i --name=py-web-service -p 8882:5000 -t python-web-service
docker ps

# start docker container at start up 
sed -i.bak '/exit 0/d' /etc/rc.local
cat >> /etc/rc.local << EOF
sudo docker start py-web-service
if [ $? != 0 ]
then
    exit $?
fi
exit
EOF

shutdown -r
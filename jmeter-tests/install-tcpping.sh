#!/bin/bash

apt-get install -y tcptraceroute
cd /usr/bin
wget http://www.vdberg.org/~richard/tcpping
chmod 755 tcpping
cd
#!/bin/bash
# https://gist.github.com/Voronenko/31161ab292c7967fcd38c092335a99e1 

# remove existing one
sudo apt remove mysql-client mysql-server libmysqlclient-dev mysql-common
sudo dpkg -l | grep mysql
# sudo dpkg -P <package> [<package> ...].


# install new
sudo apt-cache policy mysql-server
mkdir backup
cp /etc/apt/sources.list.d/mysql.list backup/mysql.list.bk
more /etc/apt/sources.list.d/mysql.list
cat > /etc/apt/sources.list.d/mysql.list << EOF
### THIS FILE IS AUTOMATICALLY CONFIGURED ###
# You may comment out entries below, but any other modifications may be lost.
# Use command 'dpkg-reconfigure mysql-apt-config' as root for modifications.
deb http://repo.mysql.com/apt/ubuntu/ wily mysql-apt-config
deb http://repo.mysql.com/apt/ubuntu/ wily mysql-5.6
deb http://repo.mysql.com/apt//ubuntu/ wily mysql-tools
deb-src http://repo.mysql.com/apt/ubuntu/ wily mysql-5.6
EOF
echo "[Updated] /etc/apt/sources.list.d/mysql.list file"
touch /etc/apt/preferences.d/mysql
cat > /etc/apt/preferences.d/mysql <<EOF
Package: *
Pin: origin "repo.mysql.com"
Pin-Priority: 999
EOF
more /etc/apt/preferences.d/mysql
sudo apt-get update -y
sudo apt-get install -y mysql-community-client mysql-client mysql-server libmysqlclient-dev
mysql --version
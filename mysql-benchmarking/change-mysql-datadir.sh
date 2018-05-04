#!/bin/bash

device_path=/dev/sdc
mounted_volume_path=/mnt/db

# format a drive to XFS
sudo mkfs.xfs -f $device_path

# mount
mkdir $mounted_volume_path
sudo mount $device_path $mounted_volume_path

# file storage
df -h

# stop mysql
sudo systemctl stop mysql
sudo systemctl status mysql
sudo rsync -av /var/lib/mysql $mounted_volume_path
mkdir backup
sudo cp -r /var/lib/mysql backup/mysql.bak

# Pointing to the New Data Location
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
# change following line
# datadir=$mounted_volume_path/mysql

# Configuring AppArmor Access Control Rules
sudo nano /etc/apparmor.d/tunables/alias
# change following line
# alias /var/lib/mysql/ -> $mounted_volume_path/mysql/,
sudo systemctl restart apparmor

# Restarting MySQL
sudo mkdir /var/lib/mysql/mysql -p # optional
sudo systemctl start mysql
sudo systemctl status mysql
mysql -u username -ppassword -e "select @@datadir"
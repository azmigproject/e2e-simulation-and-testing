#!/bin/bash

add_user()
{
    # add user in mysql database
    mysql -u root -p$1 -e "CREATE DATABASE sbtest"
    mysql -u root -p$1 -e "CREATE USER 'username'@'localhost' IDENTIFIED BY 'password'"
    mysql -u root -p$1 -e "GRANT ALL PRIVILEGES ON *.* TO 'username'@'localhost' WITH GRANT OPTION"
    mysql -u root -p$1 -e "CREATE USER 'username'@'%' IDENTIFIED BY 'password'"
    mysql -u root -p$1 -e "GRANT ALL PRIVILEGES ON *.* TO 'username'@'%' WITH GRANT OPTION"
    mysql -u root -p$1 -e "FLUSH PRIVILEGES"
}
if [ "$1" != "" ]
then
    add_user $1
else
    echo "Enter Root password as command line parameter. E.g.: ./add-mysql-user.sh <password>"
fi

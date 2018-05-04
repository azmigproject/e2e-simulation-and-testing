#!/bin/bash

install_sysbench_0_5()
{
    sudo apt-get install -y automake
    sudo apt-get install -y libtool
    sudo apt-get install -y libmysqlclient-dev
    sudo apt-get install -y libssl1.0.0 libssl-dev
    sudo apt-get install -y make
    wget http://repo.percona.com/apt/pool/main/s/sysbench/sysbench_0.5.orig.tar.gz
    tar -xvf sysbench_0.5.orig.tar.gz
    cd sysbench-0.5
    ./autogen.sh
    ./configure
    ln -s /usr/lib/x86_64-linux-gnu/libmysqlclient.so /usr/lib/x86_64-linux-gnu/libmysqlclient_r.so
    make
    make install
    sysbench --version
}
install_mysql_5_6_xx()
{

}
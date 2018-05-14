#!/bin/bash

date_ist=$(date -d '+5 hour 30 minutes' '+%m-%d-%y')
start_date_time_ist=$(date -d '+5 hour 30 minutes' '+%F %T')

lua="$1"
log_file_info="$2"
threads="$3"

correct_syntax="correct syntax: ./iostat-start.sh <lua type> <log-file-info=[default,innodb-flush]> <thread count>"
log_file="/root/logs/iostat-$threads-threads-$lua-$log_file_info-$date_ist.log"

if [ -z $threads ] || [ -z $log_file_info ] || [ -z $lua ]; then
    echo "[Error] enter no. of threads and log file info"
    echo "[info] $correct_syntax"
    exit
fi
if [ $log_file_info == "default" ] || [ $log_file_info == "innodb-flush" ]; then
    echo "[Info] [$start_date_time_ist] : Started iostat..."
    echo "[Info] $threads threads" >> $log_file
    timeout 14m iostat -xd 1 >> $log_file
else
    echo "[Error] incorrect log-file-info"
    echo "[info] $correct_syntax"
    exit
fi

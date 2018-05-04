#!/bin/bash
threads="$1"
log_file_suffix="$2"
max_time="$3"
mysql_db="--mysql-db=newsbtest"

if [ -z $threads ]; then
    echo "[Error] enter of threads as command line paramter"
    echo "correct syntax: ./start-benchmark.sh <thread count> [<log-file-suffix=default> <time=900>]"
    exit
fi
if [ -z $log_file_suffix ]; then
    log_file_suffix="default"
fi
if [ -z $max_time ]; then
    max_time=900
fi

echo "Started benchmark test..."
echo sysbench --test=/root/sysbench-0.5/sysbench/tests/db/oltp.lua $mysql_db --mysql-user=username --mysql-password=password --oltp-read-only=off  --oltp-non-index-updates=0 --max-requests=0 --max-time=$max_time --num-threads=$threads run >> mysql-$log_file_suffix-$(date +%m-%d-%y).log
sysbench --test=/root/sysbench-0.5/sysbench/tests/db/oltp.lua $mysql_db --mysql-user=username --mysql-password=password --oltp-read-only=off  --oltp-non-index-updates=0 --max-requests=0 --max-time=$max_time --num-threads=$threads run >> mysql-$log_file_suffix-$(date +%m-%d-%y).log
echo "Benchmark test complete."

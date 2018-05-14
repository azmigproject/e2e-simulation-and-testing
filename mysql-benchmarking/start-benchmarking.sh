#!/bin/bash

#lua="oltp"
#lua="oltp_custom"
lua="oltp_custom_readonly"
#lua="oltp_custom_updateonly"
#lua="prepare_parallel"

lua_path="/root/sysbench-0.5/sysbench/tests/db/$lua.lua"
date_ist=$(date -d '+5 hour 30 minutes' '+%m-%d-%y')
start_date_time_ist=$(date -d '+5 hour 30 minutes' '+%F %T')
end_date_time_ist_approx=$(date -d '+5 hour 30 minutes 900 seconds' '+%F %T')

log_file_info="$1"
threads="$2"
innodb_flush_options=""
max_time=900

log_file="/root/logs/mysql-sysbench-$lua-$log_file_info-$date_ist.log"

if [ -z $threads ]; then
    echo "[Error] enter of threads as command line paramter"
    echo "[Info] correct syntax: ./do-benchmark.sh <log-file-info=default,innodb-flush> <thread count>"
    exit
fi
if [ $log_file_info == "default" ] || [ $log_file_info == "innodb-flush" ]; then
    if [ $log_file_info == "innodb-flush" ]; then
        innodb_flush_options="--innodb-flush-log-at-trx-commit=0 --innodb_flush_method=O_DIRECT"
    fi
    echo "[Info] [$start_date_time_ist] : Started benchmark test... should end by [$end_date_time_ist_approx]"
    sysbench_command="sysbench --test=$lua_path --mysql-user=username --mysql-password=password --oltp-read-only=off --max-requests=0  --oltp_index_updates=10 --oltp-non-index-updates=10 --oltp-skip-trx='on' $innodb_flush_options --max-time=$max_time --num-threads=$threads run"
    echo $sysbench_command >> $log_file
    $sysbench_command >> $log_file
    echo "[Info] [$(date -d '+5 hour 30 minutes' '+%F %T')] Benchmark test complete."
else
    echo "[Error] incorrect log-file-info"
    echo "[Info] correct syntax: ./do-benchmark.sh <log-file-info=default,innodb-flush> <thread count>"
    exit
fi

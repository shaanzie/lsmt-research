#!/bin/bash

startup_workload() {
    /home/ubuntu/ycsb/bin/ycsb load -P mongodb /home/ubuntu/ycsb/workloads/$1 
}

execute_workload() {
    bench=$1
    workload=$2
    sar_delay=1
    sar_csv=sar_${bench}-${workload}.csv
    pidstat_file=${bench}-${workload}.pidstat
    
    sar_file=sar_out
    rm $sar_file

    delay=1000

    echo "===== $bench : $workload ======"

    sar -r ALL -u ALL -o $sar_file $sar_delay >/dev/null 2>&1 &
    sar_process=$!

    sync
    sleep 1

    command="/home/ubuntu/ycsb/bin/ycsb run -P mongodb /home/ubuntu/ycsb/workloads/$workload"

    echo "Executing $command"

    timepid=$!
    sleep 3

    pidstat -h -d -r -s -u -T ALL $sar_delay -e $command > $pidstat_file
    pidstat=$!

    echo "killing sar"
    kill -9 $sar_process
    sleep 1

    echo "killing pidstat"
    kill -9 $pidstat
    sleep 1

    sadf -dh $sar_file -- -r ALL -u ALL > $sar_csv

    sleep 5
}

size="tiny"

startup_workload "workloada"

execute_workload "mongodb" "workloada"

execute_workload "mongodb" "workloadb"

execute_workload "mongodb" "workloadc"

execute_workload "mongodb" "workloadd"

execute_workload "mongodb" "workloade"

execute_workload "mongodb" "workloadf"

mkdir -p ~/DB-data/mongodb/$size/
mv *.csv ~/DB-data/mongodb/$size/
mv *.pidstat ~/DB-data/mongodb/$size/
rm $sar_file

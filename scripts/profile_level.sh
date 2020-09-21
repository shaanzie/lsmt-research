#!/bin/bash

startup_workload() {
    mkdir -p /home/ubuntu/db-inp
    g++ /home/ubuntu/lsmt-research/leveldb/setup_leveldb.cpp -lleveldb -lsnappy -lpthread -std=c++17
    ./a.out $1 /home/ubuntu/db-inp/level
    g++ /home/ubuntu/lsmt-research/leveldb/benchmarks/benchmark_workload.cpp -lleveldb -lsnappy -lpthread --std=c++17
}

set_path() {
    export PATH=$PATH:/home/ubuntu/pmu-tools
}

execute_workload() {
    bench=$1
    workload=$2
    ops=$3
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

    echo "Executing $command"
    command="./a.out $ops /home/ubuntu/db-inp/level $workload"

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

    perf_file=${bench}-${workload}.csv
    killall perf
    set_path
    toplev.py -l3 -I 1000 -x, -o $perf_file bash $command  

    sadf -dh $sar_file -- -r ALL -u ALL > $sar_csv

    sleep 5
}

recordcount=1000
numops=10000

while getopts ":cfln" opt; do
    case ${opt} in
        c ) $recordcount=$OPTARG
        ;;
        n ) $numops=$OPTARG
        ;;
        \? ) echo "Usage: bash profile_level.sh [-c] [-n]"
        ;;
    esac
done

startup_workload $recordcount

execute_workload "leveldb" "write_heavy" $numops

execute_workload "leveldb" "update_heavy" $numops

execute_workload "leveldb" "read_heavy" $numops

execute_workload "leveldb" "read_and_modify" $numops

mkdir -p /home/ubuntu/benchsuite-results/leveldb
mv *.csv /home/ubuntu/benchsuite-results/leveldb
mv *.pidstat /home/ubuntu/benchsuite-results/leveldb
mv *.perf ~/benchsuite-results/leveldb
rm $sar_file
rm -r a.out CURRENT LOCK LOG* MANIFEST* *.log /dbs
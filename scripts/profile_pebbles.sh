#!/bin/bash

startup_workload() {
    mkdir -p /dbs
    g++ /benchsuite/pebblesdb/setup_pebblesdb.cpp -lpebblesdb -lsnappy -lpthread -std=c++17
    ./a.out $1 /dbs/pebbles
    g++ /benchsuite/pebblesdb/benchmarks/benchmark_workload.cpp -lpebblesdb -lsnappy -lpthread --std=c++17
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
    command="./a.out $ops /dbs/level $workload"

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

execute_workload "pebblesdb" "write_heavy" $numops

execute_workload "pebblesdb" "update_heavy" $numops

execute_workload "pebblesdb" "read_heavy" $numops

execute_workload "pebblesdb" "read_and_modify" $numops

mkdir -p /benchsuite/results/pebblesdb
mv *.csv /benchsuite/results/pebblesdb
mv *.pidstat /benchsuite/results/pebblesdb
rm $sar_file
rm -r a.out CURRENT LOCK LOG* MANIFEST* *.log /dbs
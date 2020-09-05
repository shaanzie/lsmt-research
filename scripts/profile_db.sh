#! /bin/bash

startup_db() {
    python3 /home/ubuntu/lsmt-research/$1/setup-$1.py
}

cleanup_db() {
    # TODO
}

execute_workload() {
    bench=$1
    execfile=$2
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

    command="python3 /home/ubuntu/lsmt-research/$bench/benchmarks/$workload.py"

    echo "Executing $command"

    timepid=$!
    bashpid=`ps -elf | grep "$command" | grep -v "/usr/bin/time" |  grep -v "grep" |   tr -s " " | cut -d " " -f 4`
    sleep 3

    echo -e "Bash: $bashpid"
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

startup_db "cassandra"
execute_workload "cassandra" "singleRead"
execute_workload "cassandra" "singleWrite"
execute_workload "cassandra" "singleAggregation"
execute_workload "cassandra" "singleUpdate"
execute_workload "cassandra" "batchedReads"
execute_workload "cassandra" "batchedWrites"
execute_workload "cassandra" "batchedAggregation"
execute_workload "cassandra" "batchedUpdates"
cleanup_db "cassandra"

sleep 10

startup_db "hbase"
execute_workload "hbase" "singleRead"
execute_workload "hbase" "singleWrite"
execute_workload "hbase" "singleAggregation"
execute_workload "hbase" "singleUpdate"
execute_workload "hbase" "batchedReads"
execute_workload "hbase" "batchedWrites"
execute_workload "hbase" "batchedAggregation"
execute_workload "hbase" "batchedUpdates"
cleanup_db "hbase"

sleep 10

startup_db "leveldb"
execute_workload "leveldb" "singleRead"
execute_workload "leveldb" "singleWrite"
execute_workload "leveldb" "singleAggregation"
execute_workload "leveldb" "singleUpdate"
execute_workload "leveldb" "batchedReads"
execute_workload "leveldb" "batchedWrites"
execute_workload "leveldb" "batchedAggregation"
execute_workload "leveldb" "batchedUpdates"
cleanup_db "leveldb"

sleep 10

startup_db "mongo"
execute_workload "mongo" "singleRead"
execute_workload "mongo" "singleWrite"
execute_workload "mongo" "singleAggregation"
execute_workload "mongo" "singleUpdate"
execute_workload "mongo" "batchedReads"
execute_workload "mongo" "batchedWrites"
execute_workload "mongo" "batchedAggregation"
execute_workload "mongo" "batchedUpdates"
cleanup_db "mongo"

sleep 10

startup_db "pebblesdb"
execute_workload "pebblesdb" "singleRead"
execute_workload "pebblesdb" "singleWrite"
execute_workload "pebblesdb" "singleAggregation"
execute_workload "pebblesdb" "singleUpdate"
execute_workload "pebblesdb" "batchedReads"
execute_workload "pebblesdb" "batchedWrites"
execute_workload "pebblesdb" "batchedAggregation"
execute_workload "pebblesdb" "batchedUpdates"
cleanup_db "pebblesdb"

sleep 10

startup_db "rocksdb"
execute_workload "rocksdb" "singleRead"
execute_workload "rocksdb" "singleWrite"
execute_workload "rocksdb" "singleAggregation"
execute_workload "rocksdb" "singleUpdate"
execute_workload "rocksdb" "batchedReads"
execute_workload "rocksdb" "batchedWrites"
execute_workload "rocksdb" "batchedAggregation"
execute_workload "rocksdb" "batchedUpdates"
cleanup_db "rocksdb"

mkdir -p ~/DB-data/$size/
mv *.csv ~/DB-data/$size/
mv *.pidstat ~/DB-data/$size/
rm $sar_file
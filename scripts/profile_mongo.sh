#!/bin/bash

startup_workload() {
    python3 /home/ubuntu/lsmt-research/mongo/setup_mongo.py --recordcount $1 --fieldcount $2 --fieldlength $3
}

execute_workload() {
    bench=$1
    workload=$2
    opts=$3
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
    
    case $workload in
        "writeHeavy" ) 
        command="python3 /home/ubuntu/lsmt-research/mongo/benchmarks/$workload.py --writeallfields $opts"
        ;;
        "updateHeavy" ) 
        command="python3 /home/ubuntu/lsmt-research/mongo/benchmarks/$workload.py --writeallfields $opts"
        ;;
        "readAndModify" ) 
        command="python3 /home/ubuntu/lsmt-research/mongo/benchmarks/$workload.py --readallfields $opts"
        ;;
        "readHeavy" ) 
        command="python3 /home/ubuntu/lsmt-research/mongo/benchmarks/$workload.py --readallfields $opts"
        ;;
    esac

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

recordcount=1000
fieldcount=10
fieldlength=100
readallfields="True"
writeallfields="True"

while getopts ":cflrw" opt; do
    case ${opt} in
        c ) $recordcount=$OPTARG
        ;;
        f ) $fieldcount=$OPTARG
        ;;
        l ) $fieldlength=$OPTARG
        ;;
        r ) $readallfields=$OPTARG
        ;;
        w ) $writeallfields=$OPTARG
        ;;
        \? ) echo "Usage: bash profile_mongo.sh [-c] [-f] [-l] [-r] [-w]"
        ;;
    esac
done

startup_workload $recordcount $fieldcount $fieldlength

execute_workload "mongodb" "writeHeavy" $writeallfields

execute_workload "mongodb" "updateHeavy" $writeallfields

execute_workload "mongodb" "readHeavy" $readallfields

execute_workload "mongodb" "readAndModify" $readallfields

mkdir -p ~/DB-data/mongodb/$size/
mv *.csv ~/DB-data/mongodb/$size/
mv *.pidstat ~/DB-data/mongodb/$size/
rm $sar_file

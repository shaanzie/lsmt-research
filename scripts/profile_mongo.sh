#!/bin/bash

startup_workload() {
    python3 /benchsuite/mongo/setup_mongo.py --recordcount $1 --fieldcount $2 --fieldlength $3
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
    command="python3  /benchsuite/mongo/workload.py --numops $ops --type $workload"

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
numops=10000

while getopts ":cfln" opt; do
    case ${opt} in
        c ) $recordcount=$OPTARG
        ;;
        f ) $fieldcount=$OPTARG
        ;;
        l ) $fieldlength=$OPTARG
        ;;
        n ) $numops=$OPTARG
        ;;
        \? ) echo "Usage: bash profile_mongo.sh [-c] [-f] [-l] [-n]"
        ;;
    esac
done

startup_workload $recordcount $fieldcount $fieldlength

execute_workload "mongodb" "writeHeavy" $numops

execute_workload "mongodb" "updateHeavy" $numops

execute_workload "mongodb" "readHeavy" $numops

execute_workload "mongodb" "readAndModify" $numops

mkdir -p /home/shaanzie/DB-data/mongodb
mv *.csv /home/shaanzie/DB-data/mongodb
mv *.pidstat /home/shaanzie/DB-data/mongodb
rm $sar_file

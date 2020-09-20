#!/bin/bash

startup_workload() {
    python3 /benchsuite/cassandra/setup_cassandra.py --numRows $1 --numFields 10
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

    command="python3 /benchsuite/cassandra/workload.py --numops $ops --type $workload"

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

execute_workload "cassandra" "readHeavy" $numops

execute_workload "cassandra" "writeHeavy" $numops

execute_workload "cassandra" "updateHeavy" $numops

execute_workload "cassandra" "readAndModify" $numops

mkdir -p /home/ubuntu/benchsuite-results/cassandra/
mv *.csv /home/ubuntu/benchsuite-results/cassandra/
mv *.pidstat /home/ubuntu/benchsuite-results/cassandra/
rm $sar_file
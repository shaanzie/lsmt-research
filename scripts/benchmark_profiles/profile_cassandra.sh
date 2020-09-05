#!/bin/bash

startup_workload() {
    ~/ycsb/bin/ycsb load cassandra workloads/$1
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

    command="~/ycsb/bin/ycsb run cassandra workloads/$workload"

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

startup_workload "workloada"
execute_workload "cassandra" "workloada"

startup_workload "workloadb"
execute_workload "cassandra" "workloadb"

startup_workload "workloadc"
execute_workload "cassandra" "workloadc"

startup_workload "workloadd"
execute_workload "cassandra" "workloadd"

startup_workload "workloade"
execute_workload "cassandra" "workloade"

startup_workload "workloadf"
execute_workload "cassandra" "workloadf"


mkdir -p ~/DB-data/cassandra/$size/
mv *.csv ~/DB-data/cassandra/$size/
mv *.pidstat ~/DB-data/cassandra/$size/
rm $sar_file
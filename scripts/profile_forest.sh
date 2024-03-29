#!/bin/bash

# startup_workload() {
#     mkdir -p /home/ishaanl/db-inp
#     g++ /home/ishaanl/lsmt-research/leveldb/setup_leveldb.cpp -lleveldb -lsnappy -lpthread -std=c++17
#     ./a.out $1 /home/ishaanl/db-inp/level
#     g++ /home/ishaanl/lsmt-research/leveldb/benchmarks/benchmark_workload.cpp -lleveldb -lsnappy -lpthread --std=c++17
# }

set_path() {
    export PATH=$PATH:/home/ishaanl/pmu-tools
}

execute_workload() {
    bench=$1
    workload=$2
    ops=$3
    lsmnum=$4
    fallbacks=$5
    pr=$6
    kv=$7
    uc=$8
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

    cd /home/ishaanl/lsm_forest/build

    command="./db_bench --benchmarks=$workload --num=$ops --histogram=1 --db=/home/ishaanl/forest_dbfiles --num_lsms=$lsmnum --num_fallbacks=$fallbacks --parallel_reads=$pr --key_value_separation=$kv --ensure_update_consistency=$uc"

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

    perf_file=${bench}-${workload}.csv
    killall perf
    set_path
    toplev.py -l3 -I 1000 -x, -o $perf_file $command  

    sadf -dh $sar_file -- -r ALL -u ALL > $sar_csv

    mv latency.csv /home/ishaanl/forest-results-$lsmnum-$fallbacks-$pr-$kv-$uc/$bench-$workload-latency.csv

    sleep 5
}

recordcount=1000
numops=1000000

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

# startup_workload $recordcount


lsmnum=5
fallbacks=2
pr=0
kv=0
uc=0

mkdir -p /home/ishaanl/forest-results-$lsmnum-$fallbacks-$pr-$kv-$uc

execute_workload "forest" "fillseq" $numops $lsmnum $fallbacks $pr $kv $uc

execute_workload "forest" "fillrandom" $numops $lsmnum $fallbacks $pr $kv $uc

execute_workload "forest" "readrandom" $numops $lsmnum $fallbacks $pr $kv $uc

mv *.csv /home/ishaanl/forest-results-$lsmnum-$fallbacks-$pr-$kv-$uc
mv *.pidstat /home/ishaanl/forest-results-$lsmnum-$fallbacks-$pr-$kv-$uc
rm $sar_file
cd /home/ishaanl/forest-results-$lsmnum-$fallbacks-$pr-$kv-$uc
rm *.ldb LOCK CURRENT MANIFEST*
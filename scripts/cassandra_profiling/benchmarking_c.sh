sar -r ALL -u ALL -t -P 4,5,6,7,8,9,10,11,12,13,14,15,20,21,22,23,24,25,26,27,28,29,30,31 -b -B -o ./sar_workload_output 1 2000 >/dev/null 2>&1 &
./bin/ycsb load cassandra-cql -p hosts=localhost -P $1 -s > ./workload_load.txt
taskset --cpu-list 0,1,2,3,16,17,18,19 ./bin/ycsb run cassandra-cql -p hosts=localhost -P $1 -s -threads 16 > ./workload_run.txt


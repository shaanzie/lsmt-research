### Profiling and Graphing Cassandra Workloads

Run the following command along with the path to the YCSB workload to profile Cassandra on YCSB Workload.
```
sh benchmark_cassandra path_to_workload
```
Then run the following command to parse the debug, gc log files.
```
g++ cassandra_debug_log_parser.cpp
./a.out path_to_the_debug_log_file > compactions.txt
g++ gc_log_parser.cpp
./a.out path_to_the_gc_log_file > gc_stops.txt
```
The debug and the gc log files are generally found in the /var/log/cassandra/ directory.

To extract the cpu util and mem util data from the sar_workload_output, run the following command to generate corresponding csv files.
```
sar -f sar_workload_output | grep -v Average | grep -v Linux |awk '{if ($0 ~ /[0-9]/) { print $1","$2","$4","$5","$6","$7","$8","$9; }  }' > cpuutil.csv
sar -r -f sar_workload_output | grep -v Average | grep -v Linux |awk '{if ($0 ~ /[0-9]/) { print $1","$2","$3","$4","$5","$6","$7","$8","$9","$10","$11","$12","$13; }  }' > memutil.csv
```

To plot the graphs, run the Plot_Cassandra.ipynb notebook. Mention the path to the raw latency output file in the cell for reading the latency data. 
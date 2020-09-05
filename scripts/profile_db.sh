#! /bin/bash

# bash benchmark_profiles/profile_cassandra.sh

#bash benchmark_profiles/profile_hbase.sh

# bash benchmark_profiles/profile_mongo.sh

#bash benchmark_profiles/profile_rocks.sh

pidstat -h -d -r -s -u -T ALL 1000 -e ~/ycsb/bin/ycsb run -s -P mongodb-async ~/ycsb/workloads/workloada > sample.pidstat
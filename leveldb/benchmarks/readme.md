# Running benchmarks

```
 g++ benchmark_workload.cpp -lleveldb -lsnappy -lpthread --std=c++17
 ./a.out <num_records> <db_location> <"read_heavy"|"update_heavy"|"write_heavy"|"read_and_modify">
```

example (to run a 1000 queries on database1 - write heavy workload):
```
g++ benchmark_workload.cpp -lleveldb -lsnappy -lpthread --std=c++17
./a.out 10000 database1 write_heavy
```

additionally, [WIP]

```
./a.out <num_records> <db_location> custom <read_proportion> <write_proportion> <update_proportion>
```

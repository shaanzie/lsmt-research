# LSMT Benchmarking suite

This project defines a novel Log Structured Merge Tree Benchmarking Suite for optimized LSMT designs. It reuses the ideas of the YCSB suite for benchmarking, and is written with system profiling needs in mind. 

The workloads mainly profiled for are
- Update Heavy workload
- Read Mostly workload
- Read only workload
- Read latest workload
- Short ranges workload
- Read-Modify workload

We also provide the following options for the setup
- recordcount(c): the number of records in the dataset at the start of the workload (default: 1000)
- fieldcount(f): the number of fields in a record (default: 10)
- fieldlength(l): the size of each field (default: 100)
- readallfields(r): should reads read all fields (true) or just one (false) (default: true)
- writeallfields(w): should updates and read/modify/writes update all fields (true) or just one (false) (default: true)


## Usage

```
./scripts/profile_<database>  [OPTIONS]
```
To run the docker container
```
docker run -it -v <PATH>/lsmt-research:/benchsuite --name test -d lsmt
docker exec test bash
```
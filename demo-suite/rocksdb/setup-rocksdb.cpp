#include<bits/stdc++.h>
#include "rocksdb/db.h"

using namespace std;

rocksdb::DB* db;
rocksdb::Options options;
options.create_if_missing = true;
rocksdb::Status status = rocksdb::DB::Open(options, "/home/ubuntu/benchmarks-rocks", &db);
// assert(status.ok());



delete db;
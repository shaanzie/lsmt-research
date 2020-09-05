#include<bits/stdc++.h>
#include "leveldb/db.h"

using namespace std;

leveldb::DB* db;
leveldb::Options options;
options.create_if_missing = true;
leveldb::Status status = pebblesdb::DB::Open(options, "/home/ubuntu/benchmarks-pebbles", &db);
// assert(status.ok());



delete db;
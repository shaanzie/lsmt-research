#include<bits/stdc++.h>
#include "pebblesdb/db.h"

using namespace std;

pebblesdb::DB* db;
pebblesdb::Options options;
options.create_if_missing = true;
pebblesdb::Status status = pebblesdb::DB::Open(options, "/home/ubuntu/benchmarks-pebbles", &db);
// assert(status.ok());



delete db;
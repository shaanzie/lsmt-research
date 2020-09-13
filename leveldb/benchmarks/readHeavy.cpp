#include "run_workload.cpp"
#include <cassert>
#include "leveldb/db.h"

int main(int argc, char const *argv[]){

  leveldb::DB* db;
  leveldb::Options options;

  options.create_if_missing = false;
  options.error_if_exists = false;

  leveldb::Status status = leveldb::DB::Open(options, argv[2], &db);
  assert(("[ERROR] Cannot create database, the database might not exist", status.ok()));

  long int total_iterations = atoi(argv[1]);

  workload_properties properties(total_iterations, 0.95, 0.05, 0.05);

  Workload<leveldb::DB*, leveldb::ReadOptions, leveldb::WriteOptions> read_heavy_workload(db, leveldb::ReadOptions(), leveldb::WriteOptions(), &properties);
  read_heavy_workload.run();

  delete db;

  return 0;
}

#include "./../../scripts/benchmarking/run_workload.cpp"
#include <cassert>
#include "rocksdb/db.h"

int main(int argc, char const *argv[]){

  rocksdb::DB* db;
  rocksdb::Options options;

  options.create_if_missing = false;
  options.error_if_exists = false;

  rocksdb::Status status = rocksdb::DB::Open(options, argv[2], &db);
  assert(("[ERROR] Cannot create database, the database might not exist", status.ok()));

  long int total_iterations = atoi(argv[1]);

  double read_proportion = 0, write_proportion = 0, update_proportion = 0;


  if(argv[3] == "custom"){
    read_proportion = std::atof(argv[4]);
    write_proportion = std::atof(argv[5]);
    update_proportion = std::atof(argv[6]);
  }
  else{
    set_proportions_by_workload_type(argv[3], read_proportion, write_proportion, update_proportion);
  }

  workload_properties properties(total_iterations, read_proportion, write_proportion, update_proportion);

  Workload<rocksdb::DB*, rocksdb::ReadOptions, rocksdb::WriteOptions> read_heavy_workload(db, rocksdb::ReadOptions(), rocksdb::WriteOptions(), &properties);
  read_heavy_workload.run();

  delete db;

  return 0;
}

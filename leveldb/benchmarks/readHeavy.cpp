#include "workloadGenerator.cpp"
#include "leveldb/db.h"


std::string get_random_key(){
  return "1";
}

std::string get_random_value(){
  return "2";
}


int main(int argc, char const *argv[]){
  QueryGenerator obj(0.95, 0.05, 0.05);

  leveldb::DB* db;
  leveldb::Options options;

  options.create_if_missing = false;
  options.error_if_exists = false;

  std::string_view read = "READ";
  std::string_view write = "WRITE";
  std::string_view update = "UPDATE";

  int writecount = 0;
  int readcount = 0;
  int updatecount = 0;

  leveldb::Status status = leveldb::DB::Open(options, argv[2], &db);
  assert(("[ERROR] Cannot create database, the database might not exist", status.ok()));

  int total_iterations = atoi(argv[1]);

  // WRAP all of this up into a run workload query.
  for(int i = 0; i < total_iterations; i++){
    auto result = obj.next_query();
    auto random_key = get_random_key();

    std::string x = "";

    if (result == read){
          ++readcount;
          db -> Get(leveldb::ReadOptions(), random_key, &x);
          std::cout << x << std::endl;
    }
    else if (result == update){
      ++updatecount;
      auto random_value = get_random_value();
      // should i delete and update?
      db -> Put(leveldb::WriteOptions(), random_key, random_value);
    }
    else if (result == write){
      ++writecount;
      auto random_value = get_random_value();
      db -> Put(leveldb::WriteOptions(), random_key, random_value);
    }

    // insert sleep time here, if necessary
  }

  std::cout << std::endl;
  std::cout << "[READS] " << readcount << std::endl;
  std::cout << "[WRITES] " << writecount << std::endl;
  std::cout << "[UPDATES] " << updatecount << std::endl;

  return 0;
}

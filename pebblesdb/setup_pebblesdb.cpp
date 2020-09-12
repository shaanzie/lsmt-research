#include <cassert>
#include <iostream>
#include <string>
#include "pebblesdb/db.h"

std::string get_dummy_value(){
  // extend this to generate and return random values
  return "dummy value";
}

int main(int argc, char const *argv[]){

    leveldb::DB* db;
    leveldb::Options options;

    options.create_if_missing = true;
    options.error_if_exists = true;


    leveldb::Status status = leveldb::DB::Open(options, argv[2], &db);

    assert(("[ERROR] Cannot create database, the database might already exist", status.ok()));

    std::string value;
    std::string key;

    for(int i = 0; i < atoi(argv[1]); i++){

      key = std::to_string(i);
      value = get_dummy_value();

      db -> Put(leveldb::WriteOptions(), std::to_string(i), value);

      std::cout << "[Wrote] Key: " << key << std::endl;
    }


    // for(int i = 0; i < atoi(argv[1]); i++){
    //   string x;
    //   db -> Get(leveldb::ReadOptions(), std::to_string(i), &x);
    //   std::cout << x;
    // }

    return 0;
}

#include "workloadGenerator.cpp"

template<typename T1, typename T2, typename T3>
class Workload{
private:
  T1 db_;
  T2 read_options_;
  T3 write_options_;

  workload_properties* properties_;

  std::string get_random_key(){
    return "1";
  }

  std::string get_random_value(){
    return "2";
  }

public:

  Workload(T1 opened_db, T2 read_options, T3 write_options, workload_properties* properties){
    this -> db_ = opened_db;
    this -> read_options_ = read_options;
    this -> write_options_ = write_options;
    this -> properties_ = properties;
  }

  std::string read(std::string key){
    std::string x;
    db_-> Get(this -> read_options_, key, &x);
    return x;
  }

  void write(std::string key, std::string value){
    db_-> Put(this -> write_options_, key, value);
  }

  void update(std::string key, std::string value){
    // should i delete and update?
    db_-> Put(this -> write_options_, key, value);
  }

  int run(){
    std::string_view read = "READ";
    std::string_view write = "WRITE";
    std::string_view update = "UPDATE";

    int writecount = 0;
    int readcount = 0;
    int updatecount = 0;

    auto [total_iterations, reads_proportion, write_proportion, update_proportion] = *(this -> properties_);

    QueryGenerator query_generator(reads_proportion, write_proportion, update_proportion);

    for(int i = 0; i < total_iterations; i++){
      auto result = query_generator.next_query();
      auto random_key = get_random_key();

      if (result == read){
        ++readcount;

        auto result = this -> read(random_key);
      }

      else if (result == update){
        ++updatecount;
        auto random_value = get_random_value();

        // should i delete and update?
        this -> update(random_key, random_value);
      }

      else if (result == write){
        ++writecount;
        auto random_value = get_random_value();

        this -> write(random_key, random_value);
      }


    }

    std::cout << std::endl;
    std::cout << "[READS] " << readcount << std::endl;
    std::cout << "[WRITES] " << writecount << std::endl;
    std::cout << "[UPDATES] " << updatecount << std::endl;

    return 0;

  }


};

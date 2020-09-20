#include "workloadGenerator.cpp"

template<typename T1, typename T2, typename T3>
class Workload{
private:
  T1 db_;
  T2 read_options_;
  T3 write_options_;

  workload_properties* properties_;


  int num_cols_;
  int num_chars_per_col_;
  long long int key_range_low_;
  long long key_range_high_;

  std::string get_random_key(){
    // not ideal. with a big range, most of the reads will be to keys not already written.
    // Given bloom filter optimizations in DBs, its unlikely we will ever have a db query go search the sstables
    // This is just a  temporary fix, will be rewritten considering other issues with the design adn expected behaviour.

    return std::to_string(rand() % this -> key_range_high_ + this -> key_range_low_);
  }

  std::string get_random_value(){

    std::string new_value, new_column_value;

    new_value.reserve(this -> num_cols_ + this -> num_chars_per_col_ * this -> num_cols_);
    new_column_value.reserve(this -> num_chars_per_col_);

    new_value = "";

    for(int i = 0; i < this -> num_cols_; ++i){
      new_column_value = "";

      for(int j = 0; j < this -> num_chars_per_col_; ++j){
          new_column_value += std::to_string(rand() % 10);
      }

      new_value += new_column_value + ";";
    }

    // std::cout << new_value << std::endl;
    return new_value;

  }

public:

  Workload(T1 opened_db, T2 read_options, T3 write_options,
          workload_properties* properties,
          int num_cols = 10, int num_chars_per_col = 100,
          long long int key_range_low = 0,
          long long int key_range_high = 10000){

    this -> db_ = opened_db;
    this -> read_options_ = read_options;
    this -> write_options_ = write_options;
    this -> properties_ = properties;

    this -> num_cols_ = num_cols;
    this -> num_chars_per_col_ = num_chars_per_col,
    this -> key_range_low_ = key_range_low;
    this -> key_range_high_ = key_range_high;

    srand(time(NULL));
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

void set_proportions_by_workload_type(std::string workload_type, double& read_proportion, double& write_proportion, double& update_proportion){
  if(workload_type == "update_heavy"){
    update_proportion = 0.95;
    write_proportion = 0.03;
    read_proportion = 0.02;
  }
  else if (workload_type == "read_heavy"){
    read_proportion = 0.95;
    write_proportion = 0.03;
    update_proportion = 0.02;
  }
  else if (workload_type == "write_heavy"){
    write_proportion = 0.95;
    read_proportion = 0.03;
    update_proportion = 0.02;
  }
  else if (workload_type == "read_and_modify"){
    read_proportion = 0.48;
    write_proportion = 0.04;
    update_proportion = 0.48;
  }
}

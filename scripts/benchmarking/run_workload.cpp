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

  std::string get_random_value(int num_cols = 10, int num_chars_per_string = 100){

    std::string new_value, new_column_value;

    new_value.reserve(num_cols + num_chars_per_string * num_cols);
    new_column_value.reserve(num_chars_per_string);

    new_value = "";

    for(int i = 0; i < num_cols; ++i){
      new_column_value = "";

      for(int j = 0; j < num_chars_per_string; ++j){
          new_column_value += std::to_string(rand() % 10);
      }

      new_value += new_column_value + ";";
    }

    std::cout << new_value << std::endl;

    return new_value;

  }

public:

  Workload(T1 opened_db, T2 read_options, T3 write_options, workload_properties* properties){
    this -> db_ = opened_db;
    this -> read_options_ = read_options;
    this -> write_options_ = write_options;
    this -> properties_ = properties;

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

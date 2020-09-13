#include <iostream>
#include <unordered_map>
#include <cassert>
#include <time.h>

class workload_properties{
public:
  long int num_records_;
  double read_proportion_;
  double write_proportion_;
  double update_proportion_;

  workload_properties(long int records, double reads, double writes, double updates): num_records_(records),
                      read_proportion_(reads), write_proportion_(writes), update_proportion_(updates) {}
};

class QueryGenerator{

private:
std::unordered_map<std::string_view, double> proportions_{{"READ", 0},
                                                        {"WRITE", 0},
                                                        {"UPDATE", 0}};

public:
  QueryGenerator(double read_proportion = 1, double write_proportion = 0, double update_proportion = 0){

      // check that they all sum to 1
      proportions_["READ"] = read_proportion;
      proportions_["WRITE"] = write_proportion;
      proportions_["UPDATE"] = update_proportion;

      srand(time(NULL));
  }

  std::string_view next_query() {
    // from YCSB : https://github.com/brianfrankcooper/YCSB/blob/master/core/src/main/java/site/ycsb/generator/DiscreteGenerator.java#L50
    double sum = 0;

    for (auto &[operation, weight] : this -> proportions_) {
      sum += weight;
    }

    double val =  rand() % 1000 / 1000.0;

    for (auto &[operation, weight] : this -> proportions_) {
      double pw = weight / sum;
      if (val < pw) {
        return operation;
      }

      val -= pw;
    }

    throw std::string("should not get here.");
  }

};

// # if 0
// int main(int argc, char const *argv[]){
//   QueryGenerator obj(0.1, 0.7, 0.2);
//
//   int writecount = 0;
//   int readcount = 0;
//   int updatecount = 0;
//
//   std::string_view read = "READ";
//   std::string_view write = "WRITE";
//   std::string_view update = "UPDATE";
//
//   for(int i = 0; i < atoi(argv[1]); i++){
//     auto result = obj.next_query();
//
//     if (result == read) ++readcount;
//     else if (result == update) ++updatecount;
//     else if (result == write) ++writecount;
//   }
//
//   std::cout << "[READS] " << readcount << std::endl;
//   std::cout << "[WRITES] " << writecount << std::endl;
//   std::cout << "[UPDATES] " << updatecount << std::endl;
//
//   return 0;
// }
//
// #endif

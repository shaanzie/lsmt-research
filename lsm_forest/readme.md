## Execution

```
g++ setup_leveldb.cpp -lleveldb -lsnappy -lpthread -std=c++17
./a.out <num_records> <database_location>
```

## Installation

run
```
sudo bash ./../scripts/install_DBs/install_leveldb.sh
```

or
```
git clone --recurse-submodules https://github.com/google/leveldb.git
cd leveldb
mkdir -p build && cd build
cmake -DCMAKE_BUILD_TYPE=Release .. && cmake --build .

sudo cp libleveldb.* /usr/local/lib

cd .. && cd include/

sudo cp -R leveldb /usr/local/include
sudo ldconfig
```

## Running YCSB benchmarks

clone this repo - [https://github.com/tejvi-m/YCSB_lsmt](https://github.com/tejvi-m/YCSB_lsmt)
and follow the instructions for building and running benchmarks at [https://github.com/tejvi-m/YCSB_lsmt/tree/lsmt-research/leveldbjni](https://github.com/tejvi-m/YCSB_lsmt/tree/lsmt-research/leveldbjni)


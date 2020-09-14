
# Installation and Execution

[recommended]

### Installation
```

mkdir -p build && cd build
cmake -DCMAKE_BUILD_TYPE=Release .. && cmake --build .

sudo cp librocksdb.* /usr/local/lib
sudo cp librocksdb.* /usr/lib

cd .. && cd include
sudo cp -R rocksdb /usr/local/include/

sudo ldconfig

```

### Execution

```
g++ setup_rocksdb.cc -lrocksdb -lsnappy -lpthread -std=c++17
./a.out <num_records> <database_location>
```


[or]


### Execution and installation


```
make all
./setup_rocksdb <num_records> <database_location>
```



The scripts assume that the rocksdb source is available at ```~/rocksdb```


```
git clone https://github.com/facebook/rocksdb.git
cd rocksdb/
make all
make install
```

Ubuntu might need other dependecies. [This](https://gist.github.com/diegopacheco/e8ccd6e719628e30a2ad0de3cc60234c) might be helpful.

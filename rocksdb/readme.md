
# Installation and Execution

[recommended]

### Installation

run
```
sudo bash ./../scripts/install_DBs/install_rocksdb.sh
```

or
```

mkdir -p build && cd build
cmake -DCMAKE_BUILD_TYPE=Release .. && cmake --build .

sudo cp librocksdb.* /usr/local/lib
sudo cp librocksdb.* /usr/lib

cd .. && cd include
sudo cp -R rocksdb /usr/local/include/

sudo ldconfig

```


Note: cmake with gcc 9 has some issues that will result in errors.

A quick workaround is to change ```cmake -DCMAKE_BUILD_TYPE=Release .. && cmake --build . ``` to ```cmake -DCMAKE_BUILD_TYPE=Debug .. && cmake --build . ```

This, however, may result in executables running slower than they would when compiled in  ```Release``` mode.

A (possibly) better fix is to change compiler versions since this works just fine with gcc10. [link](https://askubuntu.com/a/26518)

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

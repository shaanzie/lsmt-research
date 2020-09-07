## Execution

```
g++ setup-pebblesdb.cpp -lpebblesdb -lsnappy -lpthread
./a.out <num_records> <database_location>
```

## Installation

[WIP, but this works]

```
git clone https://github.com/utsaslab/pebblesdb.git

cd pebblesdb/src

autoreconf -i
./configure

make
make install

sudo ldconfig


sudo cp libpebblesdb.la /usr/local/lib/
sudo cp -R include/pebblesdb /usr/local/include/
sudo cp ./.libs/libpebblesdb.so* /usr/local/lib/
sudo cp ./.libs/libpebblesdb.so* /usr/lib/

sudo ldconfig
```

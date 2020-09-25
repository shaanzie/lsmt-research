cd ~
git clone https://github.com/facebook/rocksdb.git
cd rocksdb

mkdir -p build && cd build
cmake -DCMAKE_BUILD_TYPE=Release .. && cmake --build .

sudo cp librocksdb.* /usr/local/lib
sudo cp librocksdb.* /usr/lib

cd .. && cd include
sudo cp -R rocksdb /usr/local/include/

sudo ldconfig

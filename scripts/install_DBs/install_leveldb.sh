cd ~
git clone --recurse-submodules https://github.com/google/leveldb.git
cd leveldb

mkdir -p build && cd build
cmake -DCMAKE_BUILD_TYPE=Release .. && cmake --build .

sudo cp libleveldb.* /usr/local/lib

cd .. && cd include/

sudo cp -R leveldb /usr/local/include
sudo ldconfigmake

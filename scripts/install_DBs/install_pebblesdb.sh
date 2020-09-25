cd ~
git clone https://github.com/utsaslab/pebblesdb.git
cd pebblesdb
cd src

autoreconf -i
./configure

make
make install

sudo cp libpebblesdb.la /usr/local/lib/
sudo cp -R include/pebblesdb /usr/local/include/
sudo cp ./.libs/libpebblesdb.so* /usr/local/lib/
sudo cp ./.libs/libpebblesdb.so* /usr/lib/

sudo ldconfig

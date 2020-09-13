FROM mongo:latest

RUN apt-get update

RUN apt-get install python3 openjdk-8-jdk -y

RUN apt-get install python3-pip git wget -y && pip3 install pymongo

RUN sh -c 'echo "deb http://www.apache.org/dist/cassandra/debian 40x main" > /etc/apt/sources.list.d/cassandra.list'; \
wget -q -O - https://www.apache.org/dist/cassandra/KEYS | apt-key add -; \
apt update; \
DEBIAN_FRONTEND=noninteractive apt-get -yq install cassandra; 

RUN apt-get install autoconf libsnappy-dev libtool -y && git clone https://github.com/utsaslab/pebblesdb.git /pebblesdb ; \
cd /pebblesdb/src ; \
autoreconf -i ; \
./configure ; \
make ; \
make install ; \
ldconfig

RUN apt-get install libsnappy-dev; \
export VER="1.20"; \
wget https://github.com/google/leveldb/archive/v${VER}.tar.gz; \
tar xvf v${VER}.tar.gz; \
rm -f v${VER}.tar.gz; \
mv leveldb-${VER} /leveldb; \
cd /leveldb ; \
make; \
scp -r out-static/lib* out-shared/lib* "/usr/local/lib"; \
cd include; \
scp -r leveldb /usr/local/include; \
ldconfig

RUN apt-get install -y libgflags-dev libsnappy-dev zlib1g-dev libbz2-dev libzstd-dev; \
git clone https://github.com/facebook/rocksdb.git /rocksdb; \
cd /rocksdb; \
make all

RUN apt-get install -y sysstat ;
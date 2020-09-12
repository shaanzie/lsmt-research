FROM ubuntu:18.04

RUN apt-get update

RUN apt-get install python3 openjdk-8-jdk -y

RUN apt-get install python3-pip git wget -y && pip3 install pymongo

RUN sh -c 'echo "deb http://www.apache.org/dist/cassandra/debian 40x main" > /etc/apt/sources.list.d/cassandra.list'; \
wget -q -O - https://www.apache.org/dist/cassandra/KEYS | apt-key add -; \
apt update; \
apt install cassandra -y; 

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10</span>; \
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list

RUN apt-get update; \
apt-get install -y mongodb-org; \
apt-get install -y mongodb-org=3.4 mongodb-org-server=3.4 mongodb-org-shell=3.4 mongodb-org-mongos=3.4 mongodb-org-tools=3.4;

RUN git clone https://github.com/utsaslab/pebblesdb.git /pebblesdb; \
cd pebblesdb/src; \
autoreconf -i; \
./configure; \
make; \
make install; \
ldconfig

RUN apt-get install libsnappy-dev; \
export VER="1.20"; \
wget https://github.com/google/leveldb/archive/v${VER}.tar.gz; \
tar xvf v${VER}.tar.gz; \
rm -f v${VER}.tar.gz; \
mv leveldb-${VER} /leveldb; \
cd /leveldb-${VER}; \
make; \
scp -r out-static/lib* out-shared/lib* "/usr/local/lib"; \
cd include; \
scp -r leveldb /usr/local/include; \
ldconfig

RUN sudo apt-get install -y libgflags-dev libsnappy-dev zlib1g-dev libbz2-dev libzstd-dev; \
git clone https://github.com/facebook/rocksdb.git; \
mv rocksdb /rocksdb && cd /rocksdb; \
make all

RUN git clone https://github.com/shaanzie/lsmt-research.git /benchmark;

WORKDIR /benchmark
g++ -Wall -Wextra -fPIC -shared -fpermissive -I /usr/include/python3.6m/ -lboost_python3 pybindings.cpp -o Workload.so -std=c++17 -O3

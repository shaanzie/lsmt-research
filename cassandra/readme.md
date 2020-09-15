### Setting up Cassandra Workloads

###### Prequisites: 
* docker-compose

Run the following command to start the cassandra database
```
docker-compose up -d
```
To setup the tables, run:
```
python setup_cassandra.py
```
You can pass the number of rows in the inital table as an argument

To run the workload:
```
python workload.py
```
You can specify the number of operations as the first argument(default:1000), and the workload type(readHeavy, writeHeavy, updateHeavy, readAndModify) as the next argument.

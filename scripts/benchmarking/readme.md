[WIP]

### Using python bindings


### Manjaro
prequisites: install boost library.
(```boost``` and ```boost-python``` from the AUR)

run

```
bash make_so_file.sh
```

This generates a ```Workload.so``` file.


### Ubuntu
run
```
cmake .
make
```
This also generates a Workload.so file.

Note: This could lead to issues with the compiler versions being used. In ```CMakeLists.txt```, set the compiler versions to the versions you have/want.

Install all the prerequisites (```libboost_all_dev```).

If, on running  ```make```, there are issues with finding the boost library, run ```mlocate```, searching for ```/usr/lib/x86_64-linux-gnu/libboost_python3``` and ```/usr/lib/x86_64-linux-gnu/libpython3```.

i.e.,

Find the right file (based on the extensions in ```CMakeLists.txt```) from the list of files printed on running
```
mlocate /usr/lib/x86_64-linux-gnu/libboost_python3
```

and rewrite the line to  ```set(Boost_LIBRARIES "<file_path>")``` in CMakeLists.txt

Similarly, find the right file (based on the extensions in ```CMakeLists.txt```) from the list of files printed on running
```
mlocate /usr/lib/x86_64-linux-gnu/libpython3
```

and rewrite the line to  ```set(PYTHON_LIBRARIES "<file_path>")```

Also, remember to remove the CMakeCache file that gets generated on failed runs.

### Usage
From the directory that contains the    ```Workload.so``` file, one can ```import Workload```

to get query types based on the proportions given by the user:
```
import Workload

# Use the required proportions here
# Workload.QueryGenerator(read_proportion, write_proportion, update_proportion)
query_gen = Workload.QueryGenerator(0.9, 0.1, 0.1)

# Run this in a loop. Over multiple iterations, the proportions will be approximately the desired proportions
query_gen.get_query_type()

# based on the query types returned, one can make the right calls to the database
```

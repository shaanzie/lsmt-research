[WIP]

### Using python bindings

prequisites: install boost library.
(```boost``` and ```boost-python``` from the AUR)

run

```
bash make_so_file.sh
```

This generates a ```Workload.so``` file.

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

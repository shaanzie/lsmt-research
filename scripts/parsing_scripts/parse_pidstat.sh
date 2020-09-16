#!/bin/bash

for FILE in $1/*/*.pidstat; do
    python3 pidstat_to_csv.py $FILE
    echo "Converted $FILE"
done

for FILE in $1/*/*pidstat.csv; do
    python3 Graphing-Pidstat.py $FILE
    echo "Done $FILE"
done
    
tar -cvf Pidstat-plots.tar.gz *png
rm *png
mv Pidstat-plots.tar.gz $1/
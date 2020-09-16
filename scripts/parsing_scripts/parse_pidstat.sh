#!/bin/bash

for FILE in $1/*/*.pidstat; do
    python3 pidstat_to_csv.py $FILE
    echo "Converted $FILE"
done

for FILE in $1/*/*pidstat.csv; do
    python3 Graphing-Pidstat-accumulated.py $FILE
    echo "Done $FILE"
done
    
tar -cvf Pidstat-plots.zip *png
rm *png
mv Pidstat-plots.zip $1/
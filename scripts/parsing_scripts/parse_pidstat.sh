#!/bin/bash

for FILE in $1/*/*.pidstat; do
    python3 pidstat_to_csv.py $FILE
    echo "Done $FILE"
done
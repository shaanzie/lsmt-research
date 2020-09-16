#!/bin/bash

for FILE in $1/*/*.csv; do
    sed -i 's/;/,/g' $FILE
done
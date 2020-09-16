#!/bin/bash

for FILE in $1/*/sar*.csv; do
    sed -i 's/;/,/g' $FILE
    python3 Graphing-SAR.py $FILE
    echo "Done $FILE"
done

tar -cvf SAR-plots.zip *png
rm *png
mv SAR-plots.zip $1/
# Parsing results

Assume your results are stored in `/results/<DB-name>`.

To parse the sar files:
```
bash parse_sar.sh /results
```

To parse the pidstat files:
```
bash parse_pidstat /results
```

To parse individual pidstat files:
```
python3 pidstat_to_csv.py $FILE
```
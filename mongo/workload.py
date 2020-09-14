#!/usr/bin/python3

import argparse
import pymongo
import random
import Workload

def get_random_sting(length):
    letters = string.ascii_lowercase
    result_str = ''.join(random.choice(letters) for i in range(length))
    return result_str

parser = argparse.ArgumentParser()
parser.add_argument("--numops", help="Number of operations (default: 1000)", default=1000)
parser.add_argument("--type", help="Type of Workload (readHeavy, writeHeavy, updateHeavy)", default=True)
args = parser.parse_args()

client = pymongo.MongoClient()
db = client['mongobench']
collect = db['benchmark']

readprop = 0.1
writeprop = 0.1
updateprop = 0.8

if(args.type == 'readHeavy'):
    readprop = 0.8
    writeprop = 0.1
    updateprop = 0.1
if(args.type == 'writeHeavy'):
    readprop = 0.1
    writeprop = 0.8
    updateprop = 0.1
if(args.type == 'updateHeavy'):
    readprop = 0.1
    writeprop = 0.1
    updateprop = 0.8

query_gen = Workload.QueryGenerator(readprop, writeprop, updateprop)

to_search = get_random_sting(1)
query = {"col-1": {"$regex": "^" + to_search}}
newvalue = {"$set": {"col-1": "Hello World!"}}
insertQuery = {}
for j in range(fieldcount):
    insertQuery["col-" + j] = get_random_sting(fieldlength)

for i in range(args.numops):
    query_type = query_gen.get_query_type()
    if(query_type == 'READ'):
        x = collect.find_one(query)
    if(query_type == 'WRITE'):
        x = collect.insert(insertQuery)
    if(query_type == 'UPDATE'):
        x = collect.find_one_and_update(query, newvalue)

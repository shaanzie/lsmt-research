#!/usr/bin/python3

import argparse
import pymongo
import random
import string
import Workload

def get_random_sting(length):
    letters = string.ascii_lowercase
    result_str = ''.join(random.choice(letters) for i in range(length))
    return result_str

parser = argparse.ArgumentParser()
parser.add_argument("--numops", help="Number of operations (default: 1000)", default=1000)
parser.add_argument("--type", help="Type of Workload (readHeavy, writeHeavy, updateHeavy, readAndModify)", default=True)
args = parser.parse_args()

client = pymongo.MongoClient()
db = client['mongobench']
collect = db['benchmark']

readprop = 0.1
writeprop = 0.1
updateprop = 0.8

if(args.type == 'readHeavy'):
    readprop = 0.95
    writeprop = 0.03
    updateprop = 0.02
if(args.type == 'writeHeavy'):
    readprop = 0.03
    writeprop = 0.95
    updateprop = 0.02
if(args.type == 'updateHeavy'):
    readprop = 0.02
    writeprop = 0.03
    updateprop = 0.95
if(args.type == 'readAndModify'):
    readprop = 0.48
    writeprop = 0.04
    updateprop = 0.48

query_gen = Workload.QueryGenerator(readprop, writeprop, updateprop)
fieldcount = 10
fieldlength = 100

to_search = get_random_sting(1)
query = {"col-1": {"$regex": "^" + to_search}}
newvalue = {"$set": {"col-1": "Hello World!"}}


for i in range(int(args.numops)):
    query_type = query_gen.get_query_type()
    if(query_type == 'READ'):
        x = collect.find_one(query)
    if(query_type == 'WRITE'):
        insertQuery = {}
        for j in range(fieldcount):
            insertQuery["col-" + str(j)] = get_random_sting(int(fieldlength))
        x = collect.insert_one(insertQuery)
        del insertQuery
    if(query_type == 'UPDATE'):
        x = collect.find_one_and_update(query, newvalue)

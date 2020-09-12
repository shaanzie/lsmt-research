#!/usr/bin/python3

import argparse
import pymongo
import random

parser = argparse.ArgumentParser()
parser.add_argument("--numops", help="Number of operations (default: 1000)", default=1000)
parser.add_argument("--readallfields", help="Should updates and writes update all fields(true) or just one (false) (default: true)", default=True)
args = parser.parse_args()

client = pymongo.MongoClient()
db = client['mongobench']
collect = db['benchmark']

query = {"col-1": {"$regex": "^l"}}

if(args.readallfields):
    x = collect.find(query)
else:
    for i in range(args.numops):
        x = collect.find_one(query)
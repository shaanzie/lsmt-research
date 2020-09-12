#!/usr/bin/python3

import pymongo
import string
import random
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--recordcount", help="The number of records in the dataset at the start of the workload (default: 1000)", default=1000)
parser.add_argument("--fieldcount", help="The number of fields in a record (default: 10)", default=10)
parser.add_argument("--fieldlength", help="The size of each field (default: 100)", default=100)
args = parser.parse_args()

def get_random_sting(length):
    letters = string.ascii_lowercase
    result_str = ''.join(random.choice(letters) for i in range(length))
    return result_str

def setup(recordcount=1000, fieldcount=10, fieldlength=100):
    client = pymongo.MongoClient()

    client.drop_database('mongobench')

    db = client['mongobench']
    collect = db['benchmark']

    for i in range(recordcount):
        insertQuery = {}
        for j in range(fieldcount):
            insertQuery["col-" + j] = get_random_sting(fieldlength)
        collect.insert_one(insertQuery)

setup(args.recordcount, args.fieldcount, args.fieldlength)
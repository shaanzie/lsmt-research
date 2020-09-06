import pymongo
import lorem
import sys
import random

client = pymongo.MongoClient()
db = client['benchmark']
table = db['table']
for i in range(sys.argv[1]):
    res = table.find({"text1" : lorem.sentence})
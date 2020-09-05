import pymongo
import lorem
import sys
import random

client = pymongo.MongoClient()
db = client['benchmark']
table = db['table']
res = table.find({"text1" : lorem.sentence})
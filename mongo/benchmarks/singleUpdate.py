import pymongo
import lorem
import sys
import random

client = pymongo.MongoClient()
db = client['benchmark']
table = db['table']
res = table.update_one({"text1" : lorem.sentence}, {"$set": {"text1" : lorem.sentence}})
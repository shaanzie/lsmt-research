import pymongo
import lorem
import sys
import random

client = pymongo.MongoClient()
db = client['benchmark']

for i in range(sys.argv[1]):
    table = db.table
    table.count_documents({"text1":lorem.sentence})
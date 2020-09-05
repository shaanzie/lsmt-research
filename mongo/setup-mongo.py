import pymongo
import lorem
import sys
import random

client = pymongo.MongoClient()
db = client['benchmark']

for i in range(sys.argv[1]):
    insertQuery = {
        "text1":lorem.sentence,
        "text2":lorem.sentence,
        "text3":lorem.sentence,
        "text4":lorem.sentence,
    }
    table = db.table
    table.insert_one(insertQuery)
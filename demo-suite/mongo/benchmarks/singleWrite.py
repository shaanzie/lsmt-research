import pymongo
import lorem
import sys
import random

client = pymongo.MongoClient()
db = client['benchmark']
insertQuery = {
    "text1":lorem.sentence,
    "text2":lorem.sentence,
    "text3":lorem.sentence,
    "text4":lorem.sentence,
}
table = db.table
table.insert_one(insertQuery)
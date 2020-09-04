import pymongo
import lorem
import sys
import random

client = pymongo.MongoClient()
db = client['benchmark']
table = db.table
table.count_documents({"text1":lorem.sentence})
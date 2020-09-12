import pymongo
import sys
import string
import random

def get_random_sting(length):
    letters = string.ascii_lowercase
    result_str = ''.join(random.choice(letters) for i in range(length))
    return result_str

client = pymongo.MongoClient()
db = client['benchmark']

for i in range(sys.argv[1]):
    insertQuery = {
        "col1": get_random_string(100),
        "col2": get_random_string(100),
        "col3": get_random_string(100),
        "col4": get_random_string(100),
        "col5": get_random_string(100),
        "col6": get_random_string(100),
        "col7": get_random_string(100),
        "col8": get_random_string(100),
        "col9": get_random_string(100),
        "col10": get_random_string(100),
    }
    table = db['mongobench']
    table.insert_one(insertQuery)
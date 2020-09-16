import argparse
from cassandra.cluster import Cluster
import os
import random
import Workload

def cassandra_connection():
    """
    Connection object for Cassandra
    :return: session, cluster
    """
    cluster = Cluster()
    session = cluster.connect()
    session.execute("""
        CREATE KEYSPACE IF NOT EXISTS test
        WITH REPLICATION =
        { 'class' : 'SimpleStrategy', 'replication_factor' : 1 }
        """)
    session.set_keyspace('test')
    print("Connected")
    return session, cluster


def read_query(session):
    """
    Reads a record from the table
    """
    recordId = random.randint(1, 100000)
    query = 'SELECT * FROM test WHERE col1=' + str(recordId) + ';'
    session.execute(query)
    print('Read Completed')


def write_query(session, numFields = 10):
    """
    Writes a record to the table
    """
    query = 'INSERT INTO test('
    fields = ['col' + str(x) for x in range(1, numFields + 1)]
    query += ','.join(fields) + ') VALUES('
    values = [str(random.randint(1, 100000)) for x in range(1, numFields + 1)]
    query += ','.join(values) + ');'
    session.execute(query)
    print('Write Completed')

def update_query(session, numRows):
    """
    Updates an existing record in the table
    """
    query = 'UPDATE test SET col2=' + str(random.randint(1, 100000)) + ' WHERE ' + 'col1=' + str(random.randint(1, numRows)) + ';'
    session.execute(query)
    print('Update Completed')


session, cluster = cassandra_connection()

parser = argparse.ArgumentParser()
parser.add_argument("--numops", help="Number of operations (default: 1000)", default=10)
parser.add_argument("--type", help="Type of Workload (readHeavy, writeHeavy, updateHeavy, readAndModify)", default=True)
args = parser.parse_args()

readprop = 0.1
writeprop = 0.1
updateprop = 0.8

if(args.type == 'readHeavy'):
    readprop = 0.95
    writeprop = 0.03
    updateprop = 0.02
if(args.type == 'writeHeavy'):
    readprop = 0.03
    writeprop = 0.95
    updateprop = 0.02
if(args.type == 'updateHeavy'):
    readprop = 0.02
    writeprop = 0.03
    updateprop = 0.95
if(args.type == 'readAndModify'):
    readprop = 0.48
    writeprop = 0.04
    updateprop = 0.48

query_gen = Workload.QueryGenerator(readprop, writeprop, updateprop)
numRows = session.execute('SELECT count(*) FROM test;')[0].count

for i in range(int(args.numops)):
    query_type = query_gen.get_query_type()
    if(query_type == 'READ'):
        read_query(session)
    if(query_type == 'WRITE'):
        write_query(session)
    if(query_type == 'UPDATE'):
        update_query(session, numRows)

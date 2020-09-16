import argparse
from cassandra.cluster import Cluster
import os
import random

parser = argparse.ArgumentParser()
parser.add_argument("--numRows", help="Number of rows to be inserted", default=100)
parser.add_argument("--numFields", help="Number of fields in the table", default=10)
args = parser.parse_args()

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


def dropTable(session):
    """
    Drop the test table if it exists
    """
    session.execute("DROP TABLE IF EXISTS test;")
    print("Test Table dropped")


def createTable(session, nfields):
    """
    Creating table with specified fields
    """
    query = "CREATE TABLE test(col1 int PRIMARY KEY"

    for i in range(2, nfields + 1):
            query += ", col" + str(i) + " int"
    query += ");"

    table = session.execute(query)
    print("Created Table")

def populateTable(session, nfields, nrows):
    """
    Populate table with nrows
    """
    insertion = 'INSERT INTO test('
    fields = ['col' + str(x) for x in range(1, nfields + 1)]
    insertion += ','.join(fields) + ') VALUES('

    for i in range(1, nrows + 1):
        query = insertion + str(i)
        values = [str(random.randint(1, 100000)) for x in range(1, nfields + 1)]
        query += ','.join(values) + ');'
        x = session.execute(query)


if __name__ == "__main__": 
    session, cluster = cassandra_connection()
    dropTable(session)
    createTable(session, int(args.numFields))
    populateTable(session, int(args.numFields), int(args.numRows))


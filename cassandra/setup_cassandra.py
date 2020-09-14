from dse.cluster import Cluster
import argparse
from cassandra.cluster import Cluster
import os

parser = argparse.ArgumentParser()
parser.add_argument("--numRows", help="Number of rows to be inserted", default=1000)
parser.add_argument("--numFields", help="Number of fields in the table", default=10)
args = parser.parse_args()

def cassandra_connection():
    """
    Connection object for Cassandra
    :return: session, cluster
    """
    cluster = Cluster(['cassandra'], port=9042)
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

if __name__ == "__main__": 
    session, cluster = cassandra_connection()
    dropTable(session)
    createTable(session, args.numFields)

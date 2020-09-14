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

session, cluster = cassandra_connection()
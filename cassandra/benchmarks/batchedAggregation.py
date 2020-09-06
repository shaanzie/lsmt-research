from cassandra.cluster import Cluster
from cassandra.auth import PlainTextAuthProvider
import random
import lorem
import sys

cloud_config = {
    'secure_connect_bundle': 'ccbd-db.zip'
}

auth_provider = PlainTextAuthProvider(username='ubuntu', password='qwerty')
cluster = Cluster(cloud=cloud_config, auth_provider=auth_provider)
session = cluster.connect()

for i in range(sys.argv[1]):
    rows = session.execute("SELECT COUNT(*) FROM table WHERE text1=%s", (lorem.sentence))
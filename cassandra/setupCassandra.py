from cassandra.cluster import Cluster
from cassandra.auth import PlainTextAuthProvider
import lorem
import sys

cloud_config = {
    'secure_connect_bundle': 'ccbd-db.zip'
}

auth_provider = PlainTextAuthProvider(username='ubuntu', password='qwerty')
cluster = Cluster(cloud=cloud_config, auth_provider=auth_provider)
session = cluster.connect()

session.execute(
    """
    CREATE TABLE table (
        number_id int,
        text1 str,
        text2 str,
        text3 str,
        text4 str
    )
    """
)

for i in range(sys.argv[1]):
    session.execute(
        """
        INSERT INTO table (number_id, text1, text2, text3, text4)
        VALUES (%s, %s, %s, %s, %s)
        """,
        (i, lorem.sentence, lorem.sentence, lorem.sentence, lorem.sentence)
    )
from cassandra.cluster import Cluster
from cassandra.auth import PlainTextAuthProvider
import uuid
import lorem

cloud_config = {
    'secure_connect_bundle': 'ccbd-db.zip'
}

auth_provider = PlainTextAuthProvider(username='ubuntu', password='qwerty')
cluster = Cluster(cloud=cloud_config, auth_provider=auth_provider)
session = cluster.connect()

session.execute(
    """
    INSERT INTO table (id, text1, text2, text3, text4)
    VALUES (%s, %s, %s, %s, %s)
    """,
    (uuid.uuid1(), lorem.sentence, lorem.sentence, lorem.sentence, lorem.sentence)
)
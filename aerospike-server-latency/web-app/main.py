# import the module
from flask import Flask
from time import gmtime, strftime
import aerospike
import json

# Configure the client
config = {
  'hosts': [('127.0.0.1', 3000)]
}
# Records are addressable via a tuple of (namespace, set, key)
read_key = ('test', 'demo', 'foo')
write_key = ('test', 'demo', 'foo')
app = Flask(__name__)


@app.route("/write")
def write():
    # Create a client and connect it to the cluster
    try:
        client = aerospike.client(config).connect()
    except Exception as e:
        import sys
        error = "failed to connect to the cluster with {0} and {1}".format(
            config['hosts'], e)
        return json.dumps({"error": error}, sort_keys=True, indent=2)
        sys.exit(1)

    try:
        # Write a record
        data = {
            'name': 'John Doe',
            'age': 32,
            'timestamp': strftime("%Y-%m-%d %H:%M:%S", gmtime())
        }
        client.put(write_key, data)
    except Exception as e:
        import sys
        error = "{0}".format(e)
        return json.dumps({"error": error}, sort_keys=True, indent=2)

    # Close the connection to the Aerospike cluster
    client.close()
    return json.dumps({"record": data}, sort_keys=True, indent=2)


@app.route("/read")
def read():
    # Create a client and connect it to the cluster
    try:
        client = aerospike.client(config).connect()
    except Exception as e:
        import sys
        error = "failed to connect to the cluster with {0} and {1}".format(
            config['hosts'], e)
        return json.dumps({"error": error}, sort_keys=True, indent=2)
        sys.exit(1)

    # Read a record
    (key, metadata, record) = client.get(read_key)
    data = {
        "key": str(key),
        "metadata": metadata,
        "record": record,
        "timestamp": strftime("%Y-%m-%d %H:%M:%S", gmtime())
    }
    # Close the connection to the Aerospike cluster
    client.close()
    return json.dumps({"0": data}, sort_keys=True, indent=2)


if __name__ == "__main__":
    app.run()

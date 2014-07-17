# Seafile Network Configurations (ccnet.conf)

You may change Seafile's network options by modifying `ccnet/ccnet.conf` file. Let's walk through the options by an example.

<pre>
[General]

# This option is not used by Seafile server
USER_NAME=example

# Please don't change this ID.
ID=eb812fd276432eff33bcdde7506f896eb4769da0

# This is the name of this Seafile server. It'll be displayed on Seafile client program.
NAME=example

# This is outside URL for Seahub(Seafile Web). It'll be displayed on Seafile client program.
# The domain part (i.e., www.example.com) will also be used by the client sync files with server.
# Note: Outside URL means "if you use Nginx, it should be the Nginx's address"
SERVICE_URL=http://www.example.com:8000


[Network]

# Ccnet waits for client connections on this port. If it's used by other services, please change it.
# This is only useful for the seafile server.
PORT=10001

[Client]
# Ccnet listens to this port on localhost for local clients' request (e.g. seahub website).
# If it's been used by other services, ccnet and seafile would not be able to run.
# If you want to run seafile client and server on the same machine, change this port for the client.
PORT=13419

</pre>

**Note**: You should restart seafile so that your changes take effect.

<pre>
cd seafile-server
./seafile.sh restart
</pre>

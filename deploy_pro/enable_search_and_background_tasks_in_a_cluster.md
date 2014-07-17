# Enable search and background tasks in a cluster
In the seafile cluster, only one server should run the background tasks, including:

- indexing files for search
- email notification


You need to choose one node to run the background tasks. 

Let's assume you have three nodes in your cluster, namely A, B, and C, and you decide that:

* Node A would run the background tasks
* Node B and Node C are normal nodes


## Configuring Node A (the background-tasks node)

On this node, you need:

### Install Java

On Ubuntu/Debian:
```
sudo apt-get install default-jre
```

On CentOS/Red Hat:
```
sudo yum install java-1.6.0-openjdk
```

### Edit pro-data/seafevents.conf

REMOVE the line:

```
external_es_server = true
```

### Edit the firewall rules

In your firewall rules for node A, you should open the port 9500 (for search requests).

## Configure Other Nodes

On nodes B and C, you need to:

* Edit pro-data/seafevents.conf, add the following lines:
```
[INDEX FILES]
external_es_server = true
es_host = <ip of node A>
es_port = 9500
```

## Start the background tasks

On node A (the background tasks node), you can star/stop background tasks by:

```
./seafile-background-tasks.sh { start | stop | restart }
```

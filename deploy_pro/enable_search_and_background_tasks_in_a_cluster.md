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
sudo apt-get install openjdk-7-jre
```

On CentOS/Red Hat:
```
sudo yum install java-1.7.0-openjdk
```

*提示*：您也可以使用 Oracle JRE.

*注意*：Seafile 专业版需要 java 1.7 以上版本, 请用 `java -version` 命令查看您系统中的默认 java 版本. 如果不是 java 7, 那么, 请 [更新默认 java 版本](./change_default_java.md).

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

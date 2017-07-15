# MariaDB 集群, Memcached 集群的构建

按照[Seafile 集群文档](deploy_in_a_cluster.md)中给出的推荐架构，Seafile 集群需要使用一个分布式、高可用的数据库和缓存集群。在本文档中，我们给出一个在 3 台服务器上部署 MariaDB 和 Memcached 集群的案例。

## 硬件和操作系统需求

最少使用3台服务器部署来集群，每台机器都应该有：

* 2核、4GB内存。
* 1个SATA磁盘用来存储操作系统。
* 1个SATA磁盘用来存储MariaDB数据。也可以把 MariaDB 的数据保存在默认的系统目录下，这样就无需一个独立的磁盘。

具体的硬件配置可以根据管理员的经验和需求来调整。

我们使用 CentOS 7 操作系统，在下面，我们将3个服务器称为node1、node2、和node3。

## 部署 MariaDB 集群

MariaDB 集群的实现选择采用 MariaDB 官方推荐的集群部署方案：`MariaDB Galera Cluster`。MariaDB Galera Cluster 是MariaDB的一个同步多主集群架构。它只在Linux上可用，并且只支持XtraDB/InnoDB存储引擎。为了避免“脑裂”，MariaDB Galera Cluster 要求使用最少三个节点来构建集群，推荐SST(快照状态转移)使用`rsync`方式；推荐使用`HAproxy`对外部请求做负载均衡。如果你的 Seafile 集群是采用[集群文档](deploy_in_a_cluster.md)中介绍的 3 节点最小化部署，则不需要用 HAProxy 来负载均衡，每个节点使用本地的 MariaDB 实例即可。

为保证集群正常工作，请务必在所有集群节点开放以下防火墙端口：

- 3306 (mysql)
- 4444 (rsync / SST)
- 4567 (galera)
- 4568 (galera IST)
- 9200 (clustercheck)

关于MariaDB Galera Cluster在CentOS下的部署详情请参考文档 [MariaDB Galera Cluster](https://mariadb.com/resources/blog/setting-mariadb-enterprise-cluster-part-2-how-set-mariadb-cluster)

HAproxy做MariaDB集群负载均衡的配置过程请参考文档 [Setup HAProxy Load Balancer](https://mariadb.com/resources/blog/setup-mariadb-enterprise-cluster-part-3-setup-ha-proxy-load-balancer-read-and-write-pools)

## 部署 memcached 集群

与其他一般的集群不同，memcached 的集群机制不是是现在 memcached 服务器内部的，而是由使用 memcached 的客户端（即 Seafile 服务器）来实现 key 的分布。所以，部署 memcached 集群其实只需要在各个服务器节点上安装好 memcached 服务器程序即可。所有 Seafile 服务器，包括前端和后端服务器，都必须共享同一个 memcached 集群。

在每个节点上安装好 memcached 之后，还需要稍微修改其配置文件，以对外提供服务。

```
# 在Ubuntu系统下
vi /etc/memcached.conf

# Start with a cap of 64 megs of memory. It's reasonable, and the daemon default
# Note that the daemon will grow to this size, but does not start out holding this much
# memory
# -m 64
-m 256

# Specify which IP address to listen on. The default is to listen on all IP addresses
# This parameter is one of the only security measures that memcached has, so make sure
# it's listening on a firewalled interface.
-l 0.0.0.0

service memcached restart
```

```
# 在CentOS 7系统下
vim /etc/sysconfig/memcached

PORT="11211"
USER="memcached"
MAXCONN="1024"
CACHESIZE="64"
OPTIONS="-l 0.0.0.0 -m 256"

systemctl restart memcached
systemctl enable memcached
```
注意：为了避免重启服务后出现不必要的麻烦，请设置 memcached 服务开机自启。

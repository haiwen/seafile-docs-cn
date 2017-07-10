# MariaDB 集群, Memcached 集群的构建

按照[Seafile 集群文档](deploy_in_a_cluster.md)中给出的推荐架构，Seafile 集群需要使用一个分布式、高可用的数据库和缓存集群。在本文档中，我们给出一个在 3 台服务器上部署 MariaDB 和 Memcached 集群的案例。

## 背景知识

Seafile 将文件组织到库中，每一个库都是一个类似于树状文件系统的GIT仓库，其中的每一个文件和文件夹都是由唯一的hash值标识的。在同步算法中使用这些唯一的ID，无需在数据库中为每个文件存储同步状态。传统的数据库像MySQL，无法扩展到数千万条记录，而ceph和swift等对象存储是高度可扩展的。因此，在理论上，seafile能够存储数十亿的文件进行同步和共享。

当文件保存到对象式存储中时，其他类似共享和权限的信息必须存储在数据库中。MariaDB可用于提供可扩展和可靠的数据库存储。

## 硬件和操作系统需求

最少使用3台服务器部署来集群，每台机器都应该有：

* 2核、4GB内存。
* 1个SATA磁盘用来存储操作系统。
* 1个SATA磁盘用来存储MariaDB数据。也可以把 MariaDB 的数据保存在默认的系统目录下，这样就无需一个独立的磁盘。

具体的硬件配置可以根据管理员的经验和需求来调整。

我们使用 CentOS 7 操作系统，在下面，我们将3个服务器称为node1、node2、和node3。

## 部署 MariaDB 集群

#### 安装 MariaDB 和 Galera

首先，为MariaDB和Galera配置apt源，在[MariaDB](https://downloads.mariadb.org/mariadb/repositories)页面中选择一个5.5的仓库。然后安装MariaDB和Galera。

```
sudo apt-get install mariadb-galera-server galera
sudo apt-get install rsync
```

#### 配置 MariaDB

在 `/etc/mysql/conf.d/cluster.cnf`

```
[mysqld]

query_cache_size=0
binlog_format=ROW
default-storage-engine=innodb
innodb_autoinc_lock_mode=2
query_cache_type=0
bind-address=0.0.0.0

# Galera Provider Configuration
wsrep_provider=/usr/lib/galera/libgalera_smm.so
#wsrep_provider_options="gcache.size=32G"

# Galera Cluster Configuration
wsrep_cluster_name="test_cluster"
wsrep_cluster_address="gcomm://first_ip,second_ip,third_ip

# Galera Synchronization Congifuration
wsrep_sst_method=rsync
#wsrep_sst_auth=user:pass

# Galera Node Configuration
wsrep_node_address="this_node_ip"
wsrep_node_name="this_node_name"
```

这里的 first_ip，second_ip和third_ip 对应 node1、node2和node3的IP地址。

#### 更改 MariaDB 的数据目录（可选）

我们想要把数据存储到一个独立的磁盘中。假设该磁盘已经被挂载到了 `/mysql`。

停止 MariaDB 使用以下命令：

```
sudo /etc/init.d/mysql stop
```
复制已经存在的数据目录(默认位置在 /var/lib/mysql),使用以下命令：

```
sudo cp -R -p /var/lib/mysql/* /mysql
```

编辑 /etc/mysql/my.cnf，更新 `datadir` 配置项到 `/mysql`。

使用以下命令重启 MariaDB：

```
sudo /etc/init.d/mysql restart
```

#### 启动

启动 MariaDB 集群之前，确保在所有数据库节点上打开3456端口和4444端口。

在node1：

```
node1# sudo service mysql start --wsrep-new-cluster
```

在node2和node3：

```
node2# sudo service mysql start
node3# sudo service mysql start
```

#### 参考

https://www.digitalocean.com/community/tutorials/how-to-configure-a-galera-cluster-with-mariadb-on-ubuntu-12-04-servers

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

## 部署 Seafile 集群

请按照 http://manual-cn.seafile.com/deploy_pro/setup_with_ceph.html 在Ceph下安装seafile，并按照 http://manual-cn.seafile.com/deploy_pro/deploy_in_a_cluster.html 部署seafile集群。
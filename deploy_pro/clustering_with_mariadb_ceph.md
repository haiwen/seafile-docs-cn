# 基于 MariaDB 和 Ceph 的 Seafile 集群部署

在本文档中，将介绍部署具有MariaDB和Ceph的高扩展seafile集群的详细解决方案。该文档不是完整的，随着我们的知识和几个正在进行的项目的开展，我们将不断改进它。

## 后端节点

Seafile 将文件组织到库中，每一个库都是一个类似于树状文件系统的GIT仓库，其中的每一个文件和文件夹都是由唯一的hash值标识的。在同步算法中使用这些唯一的ID，无需在数据库中为每个文件存储同步状态。传统的数据库像MySQL，无法扩展到数千万条记录，而ceph和swift等对象存储是高度可扩展的。因此，在理论上，seafile能够存储数十亿的文件进行同步和共享。

当文件保存到对象式存储中时，其他类似共享和权限的信息必须存储在数据库中。MariaDB可用于提供可扩展和可靠的数据库存储。

## 硬件和操作系统需求

最少使用3台服务器部署来集群，每台机器都应该有：

* 4核、8GB内存或更高。
* 1个SSD磁盘用来存储Ceph日志。
* 1个SATA磁盘用来存储操作系统。
* 1个SATA磁盘用来存储MariaDB数据。
* 4个或更多的SATA磁盘来存储Ceph数据。

我们使用Ubuntu 14.04 操作系统，在下面，我们将3个服务器称为node1、node2、和node3。

## 部署 Ceph 集群

#### 准备

选择一个节点(例如，node1)作为管理节点安装。在其上部署Ceph。

* 添加key：

```
wget -q -O- 'https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc' | sudo apt-key add -
```

* 添加ceph包到仓库中，使用一个稳定的Ceph版本(例如 emperor, firefly, giant etc.)替代 {ceph-stable-release}，'giant'是最稳定的版本。

```
echo deb http://ceph.com/debian-{ceph-stable-release}/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list
```

* 更新安装包仓库并安装 Ceph：

```
sudo apt-get update && sudo apt-get install ceph-deploy
```

在所有的节点上安装 ntp，并重启 ntp

```
sudo apt-get install ntp
sudo service ntp restart
```

在所有的节点上安装openssh

```
sudo apt-get install openssh-server
```

将使用非root用户安装，请确保该用户拥有空密码的sudo权限。

```
echo "{username} ALL = (root) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/{username}
sudo chmod 0440 /etc/sudoers.d/{username}
```

在node1上为安装用户生成ssh公钥，然后拷贝该公钥到其他节点下 `~/.ssh/authorized_keys`。

#### 创建 Ceph 集群

在node1主机上创建一个名为 `ceph-cluster` 的目录用来存储生成的配置文件。所有的命令要在该目录下运行。

在所有的节点上安装 Ceph：

```
ceph-deploy install node1 node2 node3
```

创建集群

```
ceph-deploy new node1 node2 node3
```

创建 Ceph 监视器，要在所有的节点上打开6789端口。

```
ceph-deploy mon create node1 node2 node3
```

收集密钥

```
ceph-deploy gatherkeys node1
```

#### 添加 OSDs

在Ceph中，每一个OSDs守护进程管理一个磁盘。OSDs可以共享一个SSD磁盘给日志。
假设给日志分配的SSD磁盘是 `/dev/sdb` 并且SATA磁盘是 `/dev/sdc`，`/dev/sdd`，etc. 使用以下命令添加 OSDs：

```
ceph-deploy osd create node1:/dev/sdc:/dev/sdb
ceph-deploy osd create node2:/dev/sdc:/dev/sdb
ceph-deploy osd create node3:/dev/sdc:/dev/sdb
ceph-deploy osd create node1:/dev/sdd:/dev/sdb
ceph-deploy osd create node2:/dev/sdd:/dev/sdb
ceph-deploy osd create node3:/dev/sdd:/dev/sdb
```

**注意** 默认情况下，Ceph使用的日志分区大小为5GB。如果磁盘太小，创建OSD将会失败。你可以将以下配置添加到 `/etc/ceph/ceph.conf`：

```
[osd]
	# set journal size to 4GB
		osd journal size = 4000
```

#### 检查集群状态

Ceph集群安装已经完成。你可以通过 `sudo ceph -s` 来检查集群状态。

#### 参考

http://ceph.com/docs/master/rados/deployment/

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

#### 更改 MariaDB 的数据目录

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

## 部署 Seafile 集群

请按照 http://manual-cn.seafile.com/deploy_pro/setup_with_ceph.html 在Ceph下安装seafile，并按照 http://manual-cn.seafile.com/deploy_pro/deploy_in_a_cluster.html 部署seafile集群。
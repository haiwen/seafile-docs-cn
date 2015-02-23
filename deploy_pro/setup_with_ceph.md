# Ceph 下安装

Ceph 是一种可扩展的分布式存储系统。Seafile 可以使用 Ceph 的 RADOS 对象存储层作为存储后端。

## 拷贝 ceph 的配置文件和客户端的密钥环

Seafile 可以看作 Ceph/RADOS 的客户端，所以它需要访问 ceph 集群的配置文件和密钥环。您必须将 ceph 管理员节点 /etc/ceph 目录下的文件拷贝到 seafile 的机器上。

```
seafile-machine# sudo scp user@ceph-admin-node:/etc/ceph/ /etc
```

## 编辑 Seafile 配置文件

编辑 `seafile-data/seafile.conf` 文件，添加以下几行：

```
[block_backend]
name = ceph
ceph_config = /etc/ceph/ceph.conf
pool = seafile-blocks
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100

[commit_object_backend]
name = ceph
ceph_config = /etc/ceph/ceph.conf
pool = seafile-commits
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100

[fs_object_backend]
name = ceph
ceph_config = /etc/ceph/ceph.conf
pool = seafile-fs
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100
```

建议您为 commit， fs 和 block objects 分别创建连接池：

```
ceph-admin-node# rados mkpool seafile-blocks
ceph-admin-node# rados mkpool seafile-commits
ceph-admin-node# rados mkpool seafile-fs
```

## 安装并启用 memcached

为了最佳性能，强烈建议您安装 memcached 并为 objects 启用 memcache。

我们建议您为 memcached 分配 128MB 的内存空间。编辑 /etc/memcached.conf 文件如下：

```
# Start with a cap of 64 megs of memory. It's reasonable, and the daemon default
# Note that the daemon will grow to this size, but does not start out holding this much
# memory
# -m 64
-m 128
```

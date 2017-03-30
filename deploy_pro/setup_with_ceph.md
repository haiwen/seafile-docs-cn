# Ceph 下安装

**Note**: Seafile 服务器 5.0.0 之后，所有配置文件都移动到了统一的 **conf** 目录下。 [了解详情](../deploy/new_directory_layout_5_0_0.md).

Ceph 是一种可扩展的分布式存储系统。Seafile 可以使用 Ceph 的 RADOS 对象存储层作为存储后端。

## 拷贝 ceph 的配置文件和客户端的密钥环

Seafile 可以看作 Ceph/RADOS 的客户端，所以它需要访问 ceph 集群的配置文件和密钥环。您必须将 ceph 管理员节点 /etc/ceph 目录下的文件拷贝到 seafile 的机器上。

```
seafile-machine# sudo scp user@ceph-admin-node:/etc/ceph/ /etc
```

## 安装 Python Ceph 客户端库

WebDAV 访问和文件检索服务依赖于 python ceph 客户端库，因此需要在系统中安装。

在 Debian/Ubuntu 上

```
sudo apt-get install python-ceph
```

在 CentOS/RHEL 上

```
sudo yum install python-rados
```

## 编辑 Seafile 配置文件

编辑 `seafile.conf` 文件，添加以下几行：

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

## 删除安装包中自带的 C++ 库

由于 Seafile 的发布包是在比较老版本的 CentOS 上面编译的，所以自带的 C++ 库以及 ceph 客户端库和新的操作系统不兼容。因此，在比较新的系统上（比如 CentOS 7, Ubuntu 16.04）需要把发布包里面几个自带的库删除掉，以保证 seafile 会使用安装在系统中的库。

```
cd seafile-server-latest/seafile/lib
rm librados.so.2 libstdc++.so.6 libnspr4.so
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

### 使用 memcached 集群

在集群环境中，你可能会使用多个 memcached 服务器组成一个集群。你需要在 seafile.conf 中列出所有服务器的地址。加入一下选项：

```
memcached_options = --SERVER=192.168.1.134 --SERVER=192.168.1.135 --SERVER=192.168.1.136 --POOL-MIN=10 --POOL-MAX=100 --RETRY-TIMEOUT=3600
```

注意最后有一个 `--RETRY-TIMEOUT=3600` 选项。这个选项对于处理 memcached 服务器宕机的情况非常重要。在一个 memcached 服务器宕机之后，Seafile 服务器会在 `RETRY-TIMEOUT` 秒之内不再尝试使用这个服务器。你需要把这个超时设置到一个相对较大的值，以防止由于频繁重试一个不可用服务器而导致经常给客户端返回错误。

## 使用其他 Ceph 用户

上述的配置会使用默认的Ceph用户（client.admin）来访问 Ceph。从安全性的角度考虑，你可能想使用其他用户来为 Seafile 提供Ceph访问。假设你创建的 Ceph 用户 id 为 seafile，加入以下配置：

```
[block_backend]
name = ceph
ceph_config = /etc/ceph/ceph.conf
# Sepcify Ceph user for Seafile here
ceph_client_id = seafile
pool = seafile-blocks
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100

[commit_object_backend]
name = ceph
ceph_config = /etc/ceph/ceph.conf
# Sepcify Ceph user for Seafile here
ceph_client_id = seafile
pool = seafile-commits
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100

[fs_object_backend]
name = ceph
ceph_config = /etc/ceph/ceph.conf
# Sepcify Ceph user for Seafile here
ceph_client_id = seafile
pool = seafile-fs
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100
```

你可以通过以下命令创建 ceph 用户：

```
ceph auth add client.seafile \
  mds 'allow' \
  mon 'allow r' \
  osd 'allow rwx pool=seafile-blocks, allow rwx pool=seafile-commits, allow rwx pool=seafile-fs'
```

你还需要把这个用户的 keyring 路径写入 /etc/ceph/ceph.conf 中：

```
[client.seafile]
keyring = <path to user's keyring file>
```

# OpenStack Swift 下安装

**注意**: 从 Seafile Server 5.0.0 开始，所有的配置文件被统一移动到 **conf** 目录下。[更多](../deploy/new_directory_layout_5_0_0.md)。

从 5.1.0 开始，Seafile 支持使用 OpenStack Swift 作为存储后端。这个后端使用原生的 Swift 接口。以前用户只能使用S3接口兼容Swift的方式已经过时了。这个旧的文档也依然可用。[这里](setup_with_openstackswift.md)。

## 准备

为了在 Swift 下安装Seafile Pro：

- 根据Seafile Pro安装指南 [下载和安装Seafile Pro](download_and_setup_seafile_professional_server.md) 安装基础的 Seafile Pro。
- 安装并配置 memcached. 为了获取最佳性能, Seafile 要求安装 memcached 并启用。我们建议允许 memcached 最大可以使用128M以上的内存空间。编辑 /etc/memcached.conf

```
# Start with a cap of 64 megs of memory. It's reasonable, and the daemon default
# Note that the daemon will grow to this size, but does not start out holding this much
# memory
# -m 64
-m 128
```

## 更改 Seafile.conf

编辑 `seafile.conf`，添加以下配置行：

```
[block_backend]
name = swift
tenant = yourTenant
user_name = user
password = secret
container = seafile-blocks
auth_host = 192.168.56.31:5000
auth_ver = v2.0
region = yourRegion
memcached_options = --SERVER=192.168.1.134:11211 --POOL-MIN=10 --POOL-MAX=100

[commit_object_backend]
name = swift
tenant = yourTenant
user_name = user
password = secret
container = seafile-commits
auth_host = 192.168.56.31:5000
auth_ver = v2.0
region = yourRegion
memcached_options = --SERVER=192.168.1.134:11211 --POOL-MIN=10 --POOL-MAX=100

[fs_object_backend]
name = swift
tenant = yourTenant
user_name = user
password = secret
container = seafile-fs
auth_host = 192.168.56.31:5000
auth_ver = v2.0
region = yourRegion
memcached_options = --SERVER=192.168.1.134:11211 --POOL-MIN=10 --POOL-MAX=100
```

以上配置只是一个示例。你应该根据你的实际环境替换相应的配置项。

Seafile 支持以Keystone为认证机制的Swift。`auth_host` 选项是 Keystone 服务的访问地址和端口。`region` 选项被用来选择 publicURL，如果你没有配置它, 在返回身份验证信息时使用第一个 publicURL。

从专业版6.2.1开始，seafile也支持Tempauth 和 Swauth。`auth_ver` 选项应该被设置为 `v1.0`，`tenant` 和 `region` 选项不再需要。

建议为 commit, fs, 和 block 对象分别创建独立的容器。

### 使用 memcached 集群

在集群环境中，你可能还想配置一个memcached集群。我们建议采用keepalived + memcached服务高可用的方式。请参考[Memcached 集群](mariadb_memcached_cluster.md)

### 使用 HTTPS 访问 Swift

从 Pro 5.0.4 开始，你可以使用HTTPS加密连接访问 Swift。 添加以下配置项到 seafile.conf：

```
[commit_object_backend]
name = swift
......
use_https = true

[fs_object_backend]
name = swift
......
use_https = true

[block_backend]
name = swift
......
use_https = true
```

由于程序包是在CentOS 6上构建的，如果你使用的服务器操作系统是 Debian/Ubuntu，你必须将系统CA复制到CentOS CA路径下。否则将无法创建SSL连接。

```
sudo mkdir -p /etc/pki/tls/certs
sudo cp /etc/ssl/certs/ca-certificates.crt /etc/pki/tls/certs/ca-bundle.crt
sudo ln -s /etc/pki/tls/certs/ca-bundle.crt /etc/pki/tls/cert.pem
```

## 运行和测试 ##

现在你可以启动Seafile，通过命令`./seafile.sh start` 和 `./seahub.sh start`。并且访问web站点。

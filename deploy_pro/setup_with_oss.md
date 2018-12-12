# 使用阿里云开放存储（OSS）作为后端存储

## 准备工作

为了安装 Seafile 专业版服务器并使用阿里云OSS，您需要：

- 按照 [下载安装 Seafile 专业版服务器](download_and_setup_seafile_professional_server.md) 指南安装基本的 Seafile 专业版服务器。
- 安装 oss2 软件包： `sudo pip install oss2==2.3.0` ，更多安装帮助可以参考[这个文档](https://help.aliyun.com/document_detail/32026.html?spm=5176.doc32171.2.1.g3y7pa)。
- 安装和使用 Memcached。Seafile 会将部分对象缓存在 memcached 中，以提高性能。建议至少给 memcached 分配 128MB 内存。请修改 memcached 的配置文件（Ubuntu 上在 /etc/memcached.conf）：

```
# Start with a cap of 64 megs of memory. It's reasonable, and the daemon default
# Note that the daemon will grow to this size, but does not start out holding this much
# memory
# -m 64
-m 128

```

## 修改 seafile.conf

编辑 `/data/haiwen/conf/seafile.conf` 文件，添加下面几行：

```
[commit_object_backend]
name = oss
bucket = <your-seafile-commits-bucket>
key_id = <your-key-id>
key = <your-key>
region = beijing
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100

[fs_object_backend]
name = oss
bucket = <your-seafile-fs-bucket>
key_id = <your-key-id>
key = <your-key>
region = beijing
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100

[block_backend]
name = oss
bucket = <your-seafile-blocks-bucket>
key_id = <your-key-id>
key = <your-key>
region = beijing
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100
```

关于上面配置的几点说明：
* 建议您为 commit，fs 和 block objects 分别创建 buckets。为了性能和节省网络流量成本，您应该在 seafile 服务器运行的区域内创建 bucket。
* key_id 和 key 用来提供 OSS 的身份认证。您可以在 OSS 管理界面上找到它们。
* region 是您创建的 bucket 所在的区域，比如 beijing, hangzhou, shenzhen 等。

### 在 VPC 中使用 OSS

在 6.0.9 版本之前，Seafile 仅支持使用经典网络环境下的 OSS 服务。VPC （虚拟私有网络）环境下的 OSS 服务地址不同于经典网络，因此需要在配置环境中指定 OSS 访问地址。6.0.9 版本后开始支持配置 OSS 访问地址，从而实现了对 VPC OSS 服务的支持。

使用如下的配置：

```
[commit_object_backend]
name = oss
bucket = <your-seafile-commits-bucket>
key_id = <your-key-id>
key = <your-key>
endpoint = vpc100-oss-cn-beijing.aliyuncs.com
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100

[fs_object_backend]
name = oss
bucket = <your-seafile-fs-bucket>
key_id = <your-key-id>
key = <your-key>
endpoint = vpc100-oss-cn-beijing.aliyuncs.com
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100

[block_backend]
name = oss
bucket = <your-seafile-blocks-bucket>
key_id = <your-key-id>
key = <your-key>
endpoint = vpc100-oss-cn-beijing.aliyuncs.com
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100
```

与经典网络下的配置相比，上述配置使用 `endpoint` 选项替换了 `region` 选项。相应的 `endpoint` 地址可以在 https://help.aliyun.com/document_detail/31837.html 上面找到。

`endpoint` 是一个通用选项，你也可以把它设置为经典网络下的 OSS 访问地址，一样可以工作。

## 使用 memcached 集群

在集群环境中，你可能会使用多个 memcached 服务器组成一个集群。你需要在 seafile.conf 中列出所有服务器的地址。加入一下选项：

```
memcached_options = --SERVER=192.168.1.134 --SERVER=192.168.1.135 --SERVER=192.168.1.136 --POOL-MIN=10 --POOL-MAX=100 --RETRY-TIMEOUT=3600
```

注意最后有一个 `--RETRY-TIMEOUT=3600` 选项。这个选项对于处理 memcached 服务器宕机的情况非常重要。在一个 memcached 服务器宕机之后，Seafile 服务器会在 `RETRY-TIMEOUT` 秒之内不再尝试使用这个服务器。你需要把这个超时设置到一个相对较大的值，以防止由于频繁重试一个不可用服务器而导致经常给客户端返回错误。

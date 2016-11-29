# 使用阿里云开放存储（OSS）作为后端存储

## 准备工作

为了安装 Seafile 专业版服务器并使用阿里云OSS，您需要：

- 按照 [下载安装 Seafile 专业版服务器](download_and_setup_seafile_professional_server.md) 指南安装基本的 Seafile 专业版服务器。
- 按照 [这个文档](https://docs.aliyun.com/?spm=5176.383663.9.4.fTwNdK#/pub/oss/sdk/sdk-download&python) 安装 OSS Python SDK `0.4.6`（或者 `0.4.*` 最新版）。
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


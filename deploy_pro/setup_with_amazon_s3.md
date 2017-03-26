# Amazom S3 下安装

**Note**: Seafile 服务器 5.0.0 之后，所有配置文件都移动到了统一的 **conf** 目录下。 [了解详情](../deploy/new_directory_layout_5_0_0.md).

## 准备工作

为了安装 Seafile 专业版服务器并使用亚马逊 S3，您需要：

- 按照 [下载安装 Seafile 专业版服务器](download_and_setup_seafile_professional_server.md) 指南安装基本的 Seafile 专业版服务器。
- 安装 python 的 `boto` 库。它可以用来访问 S3 服务。

```
sudo easy_install boto
```

- 安装和使用 Memcached. 为了提高性能，Seafile 会将部分小对象缓存在 memcached 里面。我们推荐给 memcached 分配128MB内存。修改 `/etc/memcached.conf`

```
# Start with a cap of 64 megs of memory. It's reasonable, and the daemon default
# Note that the daemon will grow to this size, but does not start out holding this much
# memory
# -m 64
-m 128
```

## 修改 seafile.conf

编辑 `/data/haiwen/conf/seafile.conf` 文件

```
[commit_object_backend]
name = s3
# bucket 的名字只能使用小写字母，数字，短划线
bucket = my-commit-objects
key_id = your-key-id
key = your-secret-key
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100

[fs_object_backend]
name = s3
# bucket 的名字只能使用小写字母，数字，短划线
bucket = my-fs-objects
key_id = your-key-id
key = your-secret-key
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100

[block_backend]
name = s3
# bucket 的名字只能使用小写字母，数字，短划线
bucket = my-block-objects
key_id = your-key-id
key = your-secret-key
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100
```
建议您为 commit，fs 和 block objects 分别创建 buckets。
key_id 和 key 用来提供 S3 的身份认证。您可以在您的 AWS 账户页面的"安全证书"段找到 key_id 和 key。

当您在 S3 上创建 buckets 时，请先阅读 [S3 bucket 命名规则][1]。注意， 尤其不要在 bucket 的名字中使用**大写**字母（不要使用骆驼式命名法，比如 MyCommitOjbects）。

为了获得最佳性能，强烈建议您安装 memcached 并且为 objects 启用 memcache。 

### 使用新的 S3 服务区

自2014年一月起，新的 AWS 服务区只对 S3 提供版本 4 的认证签名协议支持。这包括中国区。

要在新的服务区使用 S3，在 commit_object_backend, fs_object_backend, block_backend 相关选项中加入一下额外的选项：

```
use_v4_signature = true
# eu-central-1 for Frankfurt region
aws_region = eu-central-1
```

为了让搜索等服务也能在新的 AWS 服务区工作，你还需要在 `~/.boto` 文件中加入一下几行：

```
[s3]
use-sigv4 = True
```

### 使用 memcached 集群

在集群环境中，你可能会使用多个 memcached 服务器组成一个集群。你需要在 seafile.conf 中列出所有服务器的地址。加入一下选项：

```
memcached_options = --SERVER=192.168.1.134 --SERVER=192.168.1.135 --SERVER=192.168.1.136 --POOL-MIN=10 --POOL-MAX=100 --RETRY-TIMEOUT=3600
```

注意最后有一个 `--RETRY-TIMEOUT=3600` 选项。这个选项对于处理 memcached 服务器宕机的情况非常重要。在一个 memcached 服务器宕机之后，Seafile 服务器会在 `RETRY-TIMEOUT` 秒之内不再尝试使用这个服务器。你需要把这个超时设置到一个相对较大的值，以防止由于频繁重试一个不可用服务器而导致经常给客户端返回错误。

## 使用与 S3 兼容的对象存储产品

目前已经有很多对象存储产品兼容 S3 的协议，比如 OpenStack Swift 和 Ceph 的 RGW。你可以通过以下配置使用 S3 兼容的对象存储：

```
[commit_object_backend]
name = s3
bucket = my-commit-objects
key_id = your-key-id
key = your-secret-key
host = 192.168.1.123:8080
path_style_request = true
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100

[fs_object_backend]
name = s3
bucket = my-fs-objects
key_id = your-key-id
key = your-secret-key
host = 192.168.1.123:8080
path_style_request = true
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100

[block_backend]
name = s3
bucket = my-block-objects
key_id = your-key-id
key = your-secret-key
host = 192.168.1.123:8080
path_style_request = true
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100
```

`host` is the address and port of the S3-compatible service. You cannot prepend "http" or "https" to the `host` option. By default it'll use http connections. If you want to use https connection, please set `use_https = true` option.

其中，`host` 是存储服务的地址加端口。你不能在前面添加 http 或者 https 选项。`path_style_request` 选项让 Seafile 使用形如 `https://192.168.1.123:8080/bucketname/object` 去访问对象。在亚马逊的 S3 服务中，默认的 URL 格式是虚拟主机格式，比如 `https://bucketname.s3.amazonaws.com/object`。但是一般的对象存储并不支持这种格式。

  [1]: http://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.html "the bucket naming rules"

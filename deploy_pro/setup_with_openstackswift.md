# OpenStackSwift 下安装

从专业版服务器的 2.0.5 版本开始，Seafile 可以使用兼容 S3 的云存储（比如 OpenStack/Swift）作为后端。这篇文档将以使用 Swift 为例。 

## 准备工作

首先您需要为 Swift 启用 S3 的模拟中间件。有关说明可以参考以下链接： 

* http://www.buildcloudstorage.com/2011/11/s3-apis-on-openstack-swift.html
* http://docs.openstack.org/grizzly/openstack-compute/admin/content/configuring-swift-with-s3-emulation-to-use-keystone.html

成功安装设置 S3 中间件后，您就可以用任何 S3 的客户端访问它了。在 Swift 中，访问的 key id 作为用户名 secret key 作为用户的密码。下一步您要做的就是为 Seafile 创建 buckets。使用 Python 的 boto 库您可以这样做：

```
import boto
import boto.s3.connection

connection = boto.connect_s3(
    aws_access_key_id='swifttest:testuser',
    aws_secret_access_key='testing',
    port=8080,
    host='swift-proxy-server-address',
    is_secure=False,
    calling_format=boto.s3.connection.OrdinaryCallingFormat())
connection.create_bucket('seafile-commits')
connection.create_bucket('seafile-fs')
connection.create_bucket('seafile-blocks')
```

## 修改 seafile.conf 文件

将下面几行追加到 `seafile-data/seafile.conf` 文件中

```
[block_backend]
name = s3
bucket = seafile-blocks
key_id = swifttest:testuser
key = testing
host = <swift-proxy-server-address>:8080
path_style_request = true
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100

[commit_object_backend]
name = s3
bucket = seafile-commits
key_id = swifttest:testuser
key = testing
host = <swift-proxy-server-address>:8080
path_style_request = true
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100

[fs_object_backend]
name = s3
bucket = seafile-fs
key_id = swifttest:testuser
key = testing
host = <swift-proxy-server-address>:8080
path_style_request = true
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100
```

为了提高性能，Seafile 会在 memcached 中缓存小的 objects。所以强烈建议您安装并且运行 memcached。最好是为 Seafile 提供一个专门的 memcached 实例并为其分配 128MB 的内存空间。

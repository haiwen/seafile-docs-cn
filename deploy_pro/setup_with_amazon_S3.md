# Amazom S3 下安装

为了安装 Seafile 专业版服务器并使用亚马逊 S3，您需要：

- 按照 [下载安装 Seafile 专业版服务器](download_and_setup_seafile_professional_server.md) 指南安装基本的 Seafile 专业版服务器。
- 安装 python 的 `boto` 库。它可以用来访问 S3 服务。

```
sudo easy_install boto
```

- 安装和使用 Memcached.

- 编辑 `/data/haiwen/seafile-data/seafile.conf` 文件，添加下面几行：

```
[commit_object_backend]
name = s3
# bucket 的名字只能使用小写字母，数字，点号，短划线
bucket = my.commit-objects
key_id = your-key-id
key = your-secret-key
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100

[fs_object_backend]
name = s3
# bucket 的名字只能使用小写字母，数字，点号，短划线
bucket = my.fs-objects
key_id = your-key-id
key = your-secret-key
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100

[block_backend]
name = s3
# bucket 的名字只能使用小写字母，数字，点号，短划线
bucket = my.block-objects
key_id = your-key-id
key = your-secret-key
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100
```
建议您为 commit，fs 和 block objects 分别创建 buckets。
key_id 和 key 用来提供 S3 的身份认证。您可以在您的 AWS 账户页面的"安全证书"段找到 key_id 和 key。

当您在 S3 上创建 buckets 时，请先阅读 [S3 bucket 命名规则][1]。注意， 尤其不要在 bucket 的名字中使用**大写**字母（不要使用骆驼式命名法，比如 MyCommitOjbects）。

为了获得最佳性能，强烈建议您安装 memcached 并且为 objects 启用 memcache。 


  [1]: http://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.html "the bucket naming rules"

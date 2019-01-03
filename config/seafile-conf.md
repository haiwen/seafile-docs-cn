# seafile.conf 配置

**Note**: Seafile 服务器 5.0.0 之后，所有配置文件都移动到了统一的 **conf** 目录下。 [了解详情](../deploy/new_directory_layout_5_0_0.md).

## 存储空间容量设置

用户默认空间上限

    [quota]
    # 单位为 GB
    default = 2

这个设置对所有用户生效. 如果你想对某一特定用户进行容量分配, 请以管理员身份登陆 Seahub 网站,
在**System Admin**页面中进行设置.

## 默认历史记录设置

对所有的资料库设置一个默认的文件历史保留天数：

    [history]
    keep_days = days of history to keep

## Seafile fileserver

Seafile 监听的端口号 (不要修改该设置)

    [fileserver]
    # Seafile tcp 端口 (不要修改该设置)
    port = 8082
    
从社区版 6.2 和企业版 6.1.9 开始，你可以设置用于服务 http 请求的线程数。默认值是10个线程。这个默认值适用于大多数应用场景。

```
[fileserver]
worker_threads = 15
```

上传/下载大小限制：

    [fileserver]
    # 上传文件最大为200M.
    max_upload_size=200

    # 最大下载目录限制为200M.
    max_download_dir_size=200

通过Web界面或客户端中的云端浏览器上传文件后，需要将其分成固定大小的块并存储到后端存储。我们称这个过程为“索引”。默认情况下，文件服务器使用1个线程顺序索引文件并逐个存储块。这适用与大多数情况。但是如果您使用的是 S3/Ceph/Swift 后端，则在存储后端可能会有更多带宽来并行存储多个块。我们提供了一个选项来定义索引中并发线程的数量；

```
[fileserver]
max_indexing_threads = 10
```

当用户在Web界面上传文件时，文件服务器将文件分割成固定大小的块。Web上传文件的默认块大小为1MB。块大小可以在这里设置。

```
[fileserver]
#Set block size to 2MB
fixed_block_size=2
```

当用户上传文件时，文件服务器分配一个令牌来授权上传操作。该令牌默认有效期1小时。通过WAN上传大型文件时，上传时间可能会超过1小时，您可以将令牌到期时间更改为更大的值。

```
[fileserver]
#Set uploading time limit to 3600s 
web_token_expire_time=3600
```

您可以从Web界面下载文件夹为zip存档，但是Windows上的一些zip软件不支持UTF-8，在这种情况下，您可以使用"windows_encoding"设置来解决此问题。

```
[zip]
# The file name encoding of the downloaded zip file.
windows_encoding = iso-8859-1
```

## 更改MySQL连接池大小

当您将seafile服务器配置为使用MySQL时，默认连接池大小为100，这对于大多数用例应该是足够的。您可以通过在seafile.conf中添加以下选项来更改此值：

```
[database]
......
# Use larger connection pool
max_connections = 200
```

## 开启 Slow Log

Seafile-pro-6.3.10 开始，Seafile增加了 seaf-server 的 RPC 慢请求查询日志，便于管理员更好的做性能分析。

该功能是默认开启的，如果您想要自主配置相关选项，可以在 seafile.conf 中添加如下配置：

```
[slow_log]
# 默认为 true
enable_slow_log = true
# 所有慢请求日志阈值的单位为毫秒。
# 默认为5000毫秒，这意味着只有处理超过5000毫秒的RPC查询才会被记录。
rpc_slow_threshold = 5000
```

在 `logs/slow_logs` 目录下，可以找到 `seafile_slow_rpc.log`；并且该日志文件支持使用 [log-rotate](../deploy/using_logrotate.md) 做日志切割，只需要向 seaf-server 进程发送 `SIGUSR2` 信号，进程就会关闭并重新打开日志文件。

## 注意

请重启 Seafile 和 Seahub 以使修改生效：

    ./seahub.sh restart
    ./seafile.sh restart

## 更改文件锁定自动过期时间(仅限Pro版本)

Seafile Pro服务在一段时间后自动过期文件锁，以防止锁定的文件被锁定太久。可以在seafile.conf文件中调整到期时间。

```
[file_lock]
default_expire_hours = 6
```

默认时间是12小时。

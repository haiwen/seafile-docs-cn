# ccnet.conf 配置

**Note**: Seafile 服务器 5.0.0 之后，所有配置文件都移动到了统一的 **conf** 目录下。 [了解详情](../deploy/new_directory_layout_5_0_0.md).

```
[General]
# 该设置不再使用
USER_NAME=example

# 请不要改变这个 ID.
ID=eb812fd276432eff33bcdde7506f896eb4769da0

# 该设置不再使用
NAME=example

# Seahub (Seafile Web) 外部 URL，如果该值没有设对，会影响文件的上传下载。
# 注意: 外部 URL 意味着"如果你使用 Nginx, 请使用 Nginx 对外的 URL"
# 5.0 版开始，建议通过 Web 界面来修改，不要直接修改 ccnet.conf 中的值
SERVICE_URL=http://www.example.com:8000


[Network]
# 该设置不再使用
PORT=10001

[Client]
# 该设置不再使用
PORT=13419
```

## 开启 Slow Log

Seafile-pro-6.3.10 开始，Seafile增加了一些配置，用来开启 ccnet-server 的 RPC 慢请求查询日志，便于管理员更好的做性能分析。

在 ccnet.conf 中添加如下配置：

```
[Slow_log]
# 设置为 true，开启该功能
ENABLE_SLOW_LOG = true
# 所有慢请求日志阈值的单位为毫秒。
# 默认为5000毫秒，这意味着只有处理超过5000毫秒的RPC查询才会被记录。
RPC_SLOW_THRESHOLD = 5000
```

重启服务后，在 `logs/slow_logs` 目录下，会创建 `ccnet_slow_rpc.log`；并且该日志文件支持使用 log rotate 做日志切割，只需要向 ccnet-server 进程发送 `SIGUSR2` 信号，进程就会关闭并重新打开日志文件。

## 注意

为使更改生效，请重启 Seafile

    ./seafile.sh restart

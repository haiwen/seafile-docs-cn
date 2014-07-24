Seafile 的搜索模块使用 elasticsearch 服务器，捆绑在 Seafile 专业版服务器的压缩包里。然而，很有可能您已经拥有一个 Elasitcsearch 服务器或者集群运行在您的公司内部。在这种情况下，您可以通过修改配置文件来使用您已经存在的 ES 服务器或者集群。


## 注意事项

- 您的 ES 集群必须已经安装了 thrift 的传输模块插件。如果没有，执行以下命令安装：

```
bin/plugin -install elasticsearch/elasticsearch-transport-thrift/1.6.0
```

安装完成后重启您的 ES 服务器。

- 目前 Seafile 的搜索模块在您的 ES 服务器设置中使用的是默认的分析器。


## 修改配置文件

- 编辑 `pro-data/seafevents.conf` 文件，添加 **[INDEX FILES]** 段的设置以指定您的 ES 服务器的主机和端口：

```
vim pro-data/seafevents.conf
```

```
[INDEX FILES]
...
es_host = 192.168.1.101
es_port = 9500
external_es_server = true
```

- `es_host`: 您的 ES 服务器的 IP 地址
- `es_port`: Thrift 传输模块的监听端口。默认为 `9500`
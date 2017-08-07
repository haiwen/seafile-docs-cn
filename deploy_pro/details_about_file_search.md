# 文件搜索的详细信息

**注意**：自从 Seafile Professional Server 5.0.0版本以后，所有配置文件都移动到 conf 目录下。[了解详情](/deploy/new_directory_layout_5_0_0.md)。

## 搜索选项

可以在seafevents.conf中设置以下选项来控制文件搜索的行为。你需要重新启动seafile和seahub使它们生效。

```
[INDEX FILES]
## must be "true" to enable search
enabled = true

## The interval the search index is updated. Can be s(seconds), m(minutes), h(hours), d(days)
interval=10m

## If true, indexes the contents of office/pdf files while updating search index
## Note: If you change this option from "false" to "true", then you need to clear the search index and update the index again.
index_office_pdf=false
```

## 启用 Office/PDF 文件的全文搜索

全文搜索默认情况下不启用以保存系统资源。如果要启用它，您需要按照以下说明进行操作。

首先，您必须在 `seafevents.conf` 中将 `index_office_pdf` 选项的值设置为 `true` 。

然后重新启动seafile服务。

```
cd /data/haiwen/seafile-pro-server-1.7.0/
./seafile.sh restart
```

你需要删除现有的搜索索引并重建它。

```
./pro/pro.py search --clear
./pro/pro.py search --update
```

## 使用现有的 ElasticSearch 服务

搜索模块使用与Seafile Professional Server捆绑在一起的ElasticSearch服务。但是，您可能在您的公司中运行了一个现有的ElasticSearch服务器或集群。在这种情况下，您可以更改配置文件以使用现有的ES服务器或集群。

此功能在Seafile Professional Server 2.0.5中已添加。

### 注意

- 您的ES群集必须安装transport插件。如果没有，请安装：

```
bin/plugin -install elasticsearch/elasticsearch-transport-thrift/1.6.0
```

然后重启您的 ES 服务。

- 目前，seafile 服务的搜索模块在您的 ES 服务上使用默认的analyzer。

### 更改配置文件

- 编辑 `seafevents.conf`，添加 **[INDEX FILES]** 配置段中的配置来指定您的 ES 服务器地址和端口

```
[INDEX FILES]
...
external_es_server = true
es_host = 192.168.1.101
es_port = 9500
```

- `external_es_server`：设置为 `true` 告知 seafile 将不再启动它自己的 elasticsearch 服务。
- `es_host`：是您的 ES 服务器的IP地址。
- `es_port`：Thrift transport 模块监听的地址，默认应该是 `9500`。

## <a id="wiki-faq"></a>常见问题

### <a id="how-to-rebuild-search-index"></a>如果出现问题，请重建索引

您可以通过执行以下命令重建搜索索引:

```
./pro/pro.py search --clear
./pro/pro.py search --update
```

如果这样不能解决问题，可以尝试以下步骤：

1. 停止 Seafile 服务
2. 删除旧的搜索索引 `rm -rf pro-data/search`
3. 重启 Seafile 服务
4. 稍等片刻，然后执行 `./pro/pro.py search --update`

### <a id="wiki-search-no-result"></a>当我搜索关键字时，没有返回结果

搜索索引默认每10分钟更新一次，所以在执行第一次搜索更新之前，无论你搜索什么都没有结果。

为了能立即搜索：

- 确保您已经启动 Seafile Server
- 手动更新搜索索引：

```
cd haiwen/seafile-pro-server-2.0.4
./pro/pro.py search --update
```

### <a id="wiki-cannot-search-encrypted-files"></a>无法搜索加密文件

这是因为服务器无法对加密文件进行索引，因为它们被加密了。

### <a id="how-to-increase-search-process-memory"></a>增加用于搜索的Java进程堆大小

搜索功能基于弹性搜索，这是一个Java进程。要增加Java堆大小，可以使用 `ES_HEAP_SIZE` 环境变量，例如：

```sh
export ES_HEAP_SIZE=4g # default is 1g
./seafile.sh restart
```

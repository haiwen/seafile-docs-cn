- [FAQ](#wiki-faq)
  - [我不能搜索 office/PDF 文档](#wiki-search-office-pdf)
  - [当我搜索一个关键词时，没有返回结果](#wiki-search-no-result)
  - [不能搜索加密的文件](#wiki-cannot-search-encrypted-files)


## <a id="wiki-faq"></a>常见问题


### <a id="wiki-search-office-pdf"></a>我不能搜索 office/PDF 文档


首先，确认在 **seafevents.conf** 文件中，已经设置 `index_office_pdf = true`：

```
[INDEX FILES]
...
index_office_pdf = true

```

然后，检查是否安装 **pdftotext**

如果 **pdftotext** 没有安装，就不能从 PDF 文件中提取文本。

```
which pdftotext
```

执行上面的命令，如果没有输出，那么您需要安装它：

```
sudo apt-get install poppler-utils
```

**pdftotext** 安装完成后，您需要重新构建您的搜索索引。

```
./pro/pro.py search --clear
./pro/pro.py search --update
```


### <a id="wiki-search-no-result"></a>当我搜索一个关键词时，没有返回结果

默认情况下，搜索索引每 10 分钟更新一次。所以，在第一次索引更新前，无论您搜索什么都不会返回结果。

  为了使搜索能够立即生效，您可以手动更新搜索索引：

  - 确保您已经启动了 Seafile 服务器
  - 手动更新搜索索引：
```
      cd haiwen/seafile-pro-server-2.0.4
     ./pro/pro.py search --update
```

### <a id="wiki-cannot-search-encrypted-files"></a>不能搜索加密的文件

这是因为服务器不能索引加密的文件，因为它们被加密了。
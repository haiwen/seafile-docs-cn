- [关于搜索功能的 FAQ](#wiki-search-faq)
- [Office/PDF 文档预览 FAQ](#wiki-doc-preview)

## <a id="wiki-search-faq"></a>关于搜索功能的 FAQ ##

- 无论我怎样尝试，加密资料库中的文件都不会出现在搜索结果中 

  这是因为服务器不能索引加密文件，因为它们是加密的。

- 我从社区版服务器切换到专业版服务器后，无论我搜索什么，都不会得到结果

默认情况下，搜索索引每 10 分钟更新一次。所以，在第一次索引更新前，无论您搜索什么都不会返回结果。

  为了使搜索能够立即生效，您可以手动更新索引：

  - 确保您已经启动了 Seafile 服务器
  - 手动更新搜索索引：
```
      cd haiwen/seafile-pro-server-2.1.5
     ./pro/pro.py search --update
```

  如果您的文件很多，这个过程会花费很长一段时间。

- 我想启用对 office/pdf 文档的全文搜索功能，所以我在配置文件中将 `index_office_pdf` 的值设置为 `true`，但它没起作用。

  在这种情况下，您需要做以下几步：
  1. 编辑 `/data/haiwen/pro-data/seafevents.conf` 文件，将 `index_office_pdf` 的值设置为 `true`
  2. 重启 Seafile 服务器：
  ```
  cd /data/haiwen/seafile-pro-server-2.1.5
  ./seafile.sh restart
  ```
  3. 删除已经存在的搜索索引：
  ```
  ./pro/pro.py search --clear
  ```
  4. 创建并且再次更新搜索索引：
  ```
  ./pro/pro.py search --update
  ```


## <a id="wiki-doc-preview"></a>Office/PDF 文档预览 FAQ

### 怎么修改可预览最大文件大小和页面数?

在 `/data/haiwen/pro-data/seafevents.conf` 中的 `OFFICE CONVERTER` 配置部分添加配置选项

```
# the max size of documents to allow to be previewed online, in MB. Default is 2 MB
max-size = 2
# how many pages are allowed to be previewed online. Default is 50 pages
max-pages = 50
```
 
然后重启 Seafile 服务

```
cd /data/haiwen/seafile-pro-server-1.7.0/
./seafile.sh restart
./seahub.sh restart
```

### 文档预览在 Ubuntu 14.04 上无法工作?

目前文档预览只能在 libreoffice 4.1 或 4.0 版本工作。Ubuntu 14.04 上的版本是 4.2。解决方法:

先删除 libreoffice 4.2:
```
sudo apt-get remove libreoffice* python3-uno
```

从 libreoffice 官网下载 4.1 版:
```
wget http://ftp.jaist.ac.jp/pub/tdf/libreoffice/stable/4.1.6/deb/x86_64/LibreOffice_4.1.6_Linux_x86-64_deb.tar.gz
```

安装:
```
tar xf LibreOffice_4.1.6_Linux_x86-64_deb.tar.gz
cd LibreOffice_4.1.6.2_Linux_x86-64_deb
cd DEBS
sudo dpkg -i *.deb
```

重启 Seafile 服务器
```
./seafile.sh restart
```
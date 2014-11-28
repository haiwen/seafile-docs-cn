- [限制条件](#wiki-restriction)
- [准备工作](#wiki-preparation)
- [迁移](#wiki-do-migration)
- [切换回社区版服务器](#wiki-switch-back)

## <a id="wiki-restriction"></a>限制条件 ##

您可能已经部署过 Seafile 社区版服务器，并想要切换到专业版，或者反过来从专业版迁移到社区版。但是有一些限制条件需要您注意：

- 您只能在相同大版本的社区版服务器和专业版服务器之间进行切换。

这意味着，如果您正在使用 2.0 版本的社区版服务器， 并且想要切换到 2.1 版本的专业版服务器，您必须先将您的社区版服务器升级到 2.1 版本， 然后按照以下指南切换到 2.1 版本的专业版服务器。(版本号 2.1.x 中的最后一位没有关系)

## <a id="wiki-preparation"></a>准备工作 ##

### 安装 Java 运行时环境 (JRE) ###

如果您的系统环境是 Ubuntu 或者 Debian，执行以下命令：
```
sudo apt-get install openjdk-7-jre
```

如果您的系统环境是 CentOS 或者 Red Hat，执行以下命令：
```
sudo yum install java-1.7.0-openjdk
```

*注意*：您也可以使用 Oracle JRE.

*注意*：Seafile 专业版需要 java 1.7 以上版本, 请用 `java -version` 命令查看您系统中的默认 java 版本. 如果不是 java 7, 那么, 请 [更新默认 java 版本](./change_default_java.md).

### 安装 poppler-utils ###

poppler-utils 提供对 pdf 文件的全文检索功能。

如果您的系统环境是 Ubuntu 或者 Debian，执行以下命令：
```
sudo apt-get install poppler-utils
```

如果您的系统环境是 CentOS 或者 Red Hat，执行以下命令：
```
sudo yum install poppler-utils
```


### 安装 Libreoffice 和 UNO 库 ###

Libreoffice 和 Python-uno 库提供对办公文件的在线预览功能。如果它们没有安装，办公文件就不能在线预览。

如果您的系统环境是 Ubuntu 或者 Debian，执行以下命令：
```
sudo apt-get install libreoffice python-uno
```

如果您的系统环境是 CentOS 或者 RHEL，执行以下命令：
```
sudo yum install libreoffice libreoffice-headless libreoffice-pyuno
```

对于其他的 Linux 发行版您可以参考：[Linux 下 LibreOffice 的安装](http://www.libreoffice.org/get-help/installation/linux/)

一般地，您还需要为您的使用语言安装字体，特别是在亚洲地区，否则 office 文件和 pdf 文件不能正确地显示。 

比如， 中国的用户可能希望安装文泉驿系列的 TrueType 字体：

```
# 如果您的系统环境是 Ubuntu 或者 Debian，执行以下命令：
sudo apt-get install ttf-wqy-microhei ttf-wqy-zenhei xfonts-wqy
```

## <a id="wiki-do-migration"></a>迁移 ##

我们假定您已经在 `/data/haiwen/seafile-server-2.1.0` 目录下部署了 Seafile 社区版服务器的 2.1.0 版本。 


### 获得许可证书 ###


将您获得的许可证书放在 Seafile 安装位置的顶层目录下。在我们的例子中，顶层目录是 `/data/haiwen/` 。


### <a id="wiki-download-and-uncompress"></a>下载与解压 Seafile 专业版服务器 ###

- 32 位
- [64 位](https://cloud.seafile.com/repo/4cbf838a-bbb7-4106-a6b5-27f6d382dc90/)


您应该将压缩包解压到您的 Seafile 安装位置的顶层目录，在我们的例子中，顶层目录是 `/data/haiwen` 。

```
tar xf seafile-pro-server_2.1.0_x86-64.tar.gz
```

现在您的目录结构像如下这样：

```
haiwen
├── seafile-license.txt
├── seafile-pro-server-2.1.0/
├── seafile-server-2.1.0/
├── ccnet/
├── seafile-data/
├── seahub-data/
├── seahub.db
└── seahub_settings.py


```

-----------

您应该已经注意到社区版服务器和专业版服务器名字的不同。以 64 位的 2.1.0 版本为例：

- Seafile 社区版服务器压缩包叫作 `seafile-server_2.1.0_x86-86.tar.gz`；解压后，文件夹名叫作  `seafile-server-2.1.0`
- Seafile 专业版服务器压缩包叫作 `seafile-pro-server_2.1.0_x86-86.tar.gz`；解压后，文件夹名叫作 `seafile-pro-server-2.1.0`
    
-----------


### 迁移 ###

- 如果 Seafile 社区版服务器正在运行，请先停止它：
```
cd haiwen/seafile-server-2.1.0
./seafile.sh stop
./seahub.sh stop
```
- 运行迁移脚本 
```
cd haiwen/seafile-pro-server-2.1.0/
./pro/pro.py setup --migrate
```

迁移脚本将会为您做以下的工作：

- 确保您满足所有的先决条件
- 创建必要的额外配置选项
- 更新 avatar 目录
- 创建额外的数据库表  


现在您的目录结构像如下这样：

<blockquote>
haiwen<br/>
├── seafile-license.txt<br/>
├── seafile-pro-server-2.1.0/<br/>
├── seafile-server-2.1.0/<br/>
├── ccnet/<br/>
├── seafile-data/<br/>
├── seahub-data/<br/>
├── seahub.db<br/>
├── seahub_settings.py<br/>
└── <span style="color:green;font-weight:bold;">pro-data/</span><br/>
</blockquote>

### 启用 Seafile 专业版服务器 ###

```
cd haiwen/seafile-pro-server-2.1.0
./seafile.sh start
./seahub.sh start
```


## <a id="wiki-switch-back"></a>切换回社区版服务器 ##

如果 Seafile 专业版服务器正在运行，请先停止它：

```
cd haiwen/seafile-pro-server-2.1.0/
./seafile.sh stop
./seahub.sh stop
```

更新 avatar 目录的链接，参考[小版本升级](https://github.com/haiwen/seafile/wiki/Upgrading-Seafile-Server#minor-upgrade-like-from-150-to-151)

```
cd haiwen/seafile-server-2.1.0/
./upgrade/minor-upgrade.sh
```

启用 Seafile 社区版服务器

```
cd haiwen/seafile-server-2.1.0/
./seafile.sh start
./seahub.sh start
```

- [准备工作](#wiki-preparation)
- [下载与安装](#wiki-download-and-setup)
- [安装完成](#wiki-done)

## <a id="wiki-preparation"></a>准备工作 ##

以下文档在 Ubuntu 14.04 测试通过。

> 注意: 
> 
> Ubuntu 14.04，可用以下命令安装全部依赖。
> 
> ```
> sudo apt-get install openjdk-7-jre poppler-utils libreoffice libreoffice-script-provider-python libpython2.7 python-pip mysql-server python-setuptools python-imaging python-mysqldb python-memcache
> 
> sudo pip install boto
> ```
> 
> CentOS 6.6 下:
> 
> ```
> wget https://bootstrap.pypa.io/get-pip.py
> sudo python get-pip.py
> sudo yum install java-1.7.0-openjdk poppler-utils libreoffice libreoffice-headless libreoffice-pyuno python-dev python-setuptools python-imaging MySQL-python mysql-server.x86_64
> sudo pip install boto
> sudo /etc/init.d/mysqld start
> ```
> 

### 系统最低配置需求 ###

- 一台至少 2GB 内存的 Linux 服务器

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

poppler-utils 提供对 PDF 文件的全文检索功能。

如果您的系统环境是 Ubuntu 或者 Debian，请执行以下命令：
```
sudo apt-get install poppler-utils
```

如果您的系统环境是 CentOS 或者 Red Hat，请执行以下命令：
```
sudo yum install poppler-utils
```


### 安装 Libreoffice 和 UNO 库 (可选) ###

注意：Office 文件预览安装起来不是很方便，在不同的 Linux 平台上容易出不同的小问题。所以我们不再对这个功能提供官方支持。建议您略过这一安装步骤。

Libreoffice 和 Python-uno 库为 office 文件提供在线预览功能。如果它们没有安装，office 文件就不能在线预览。Seafile 需要 libreoffice 4.0 或者以后的版本。

如果您的系统环境是 Ubuntu 或者 Debian，执行以下命令：
```
sudo apt-get install libreoffice python-uno
```

如果您的系统环境是 CentOS 或者 RHEL，执行以下命令：
```
sudo yum install libreoffice libreoffice-headless libreoffice-pyuno
```

对于其他的 Linux 发行版您可以参考：[Linux 系统下安装 LibreOffice](http://www.libreoffice.org/get-help/installation/linux/)

一般地，您还需要为您的使用语言安装字体，特别是在亚洲地区，否则 office 文件和 pdf 文件不能正确地显示。

比如， 中国的用户可能希望安装文泉驿系列的 TrueType 字体：

```
# 如果您的系统环境是 Ubuntu 或者 Debian，执行以下命令：
sudo apt-get install ttf-wqy-microhei ttf-wqy-zenhei xfonts-wqy
```


### 安装 Python 库 ###

首先确保您已经安装了 python 2.6.5+ 或者 2.7 版本
```
sudo easy_install pip
sudo pip install boto
```

在安装过程中如果您遇到错误："Wheel installs require setuptools >= ..."， 请在以上两条命令之间运行以下命令：
```
sudo pip install setuptools --no-use-wheel --upgrade
```

## <a id="wiki-download-and-setup"></a>下载与安装 Seafile 专业版服务器 ##

### 获得许可证书 ###

将您得到的许可证书放在顶层目录下。比如，在这篇文档页面里，我们把 `/data/haiwen/` 作为顶层目录。


### <a id="wiki-download-and-uncompress"></a>下载与解压 Seafile 专业版服务器 ###


```
tar xf seafile-pro-server_2.1.5_x86-64.tar.gz
```

现在您的目录结构应该像如下这样：

```
haiwen
├── seafile-license.txt
└── seafile-pro-server-2.1.5/
```


-----------

您应该已经注意到社区版服务器和专业版服务器名字的不同。以 64 位的 2.1.5 版本为例：

- Seafile 社区版服务器压缩包叫作 `seafile-server_2.1.5_x86-86.tar.gz`；解压后，文件夹名叫作  `seafile-server-2.1.5`
- Seafile 专业版服务器压缩包叫作 `seafile-pro-server_2.1.5_x86-86.tar.gz`；解压后，文件夹名叫作 `seafile-pro-server-2.1.5`

-----------


### 安装 ###

Seafile 专业版服务器的安装步骤与Seafile 社区版服务器安装步骤相同。请参考社区维基：[下载与安装 Seafile 服务器并使用 MySQL 数据库](https://github.com/haiwen/seafile/wiki/Download-and-Setup-Seafile-Server-with-MySQL)

在您成功安装 Seafile 专业版服务器之后，您的目录结构应该像如下这样：

```
#tree haiwen -L 2
haiwen
├── seafile-license.txt # license file
├── ccnet               # configuration files
│   ├── ccnet.conf
│   ├── mykey.peer
│   ├── PeerMgr
│   └── seafile.ini
├── pro-data            # data specific for professional version
│   └── seafevents.conf
├── seafile-data
│   └── seafile.conf
├── seafile-pro-server-2.1.5
│   ├── reset-admin.sh
│   ├── runtime
│   ├── seafile
│   ├── seafile.sh
│   ├── seahub
│   ├── seahub-extra
│   ├── seahub.sh
│   ├── setup-seafile.sh
│   ├── setup-seafile-mysql.py
│   ├── setup-seafile-mysql.sh
│   └── upgrade
├── seahub-data
│   └── avatars         # for user avatars
├── seahub.db
├── seahub_settings.py   # seahub config file
```

## <a id="wiki-done"></a>安装完成

到此，Seafile 专业版服务器的基本安装已经完成。

您可能想要了解更多关于 Seafile 专业版服务器的信息：


- [Seafile 专业版服务器的 FAQ](faq_for_seafile_pro_server.md)

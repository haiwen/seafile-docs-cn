- [准备工作](#wiki-preparation)
- [下载与安装](#wiki-download-and-setup)

## <a id="wiki-preparation"></a>准备工作 ##

安装依赖库。

Ubuntu 14.04，可用以下命令安装全部依赖。

```
sudo apt-get install openjdk-7-jre poppler-utils libpython2.7 python-pip \
mysql-server python-setuptools python-imaging python-mysqldb python-memcache \
python-ldap python-urllib3

sudo pip install boto requests
```

Ubuntu 16.04，可用以下命令安装全部依赖。

```
sudo apt-get install openjdk-8-jre poppler-utils libpython2.7 python-pip \
mysql-server python-setuptools python-imaging python-mysqldb python-memcache python-ldap \
python-urllib3

sudo pip install boto requests
sudo ln -sf /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java /usr/bin/
```

CentOS 7 下:

```
wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
sudo yum install java-1.7.0-openjdk poppler-utils python-dev python-setuptools \
python-imaging MySQL-python mysql-server.x86_64 python-memcached python-ldap \
python-urllib3
sudo pip install boto requests
sudo /etc/init.d/mysqld start
```

### 补充说明： 关于 Java

*注意*：Seafile 专业版需要 java 1.7 以上版本, 请用 `java -version` 命令查看您系统中的默认 java 版本. 如果不是 java 7, 那么, 请 [更新默认 java 版本](./change_default_java.md).


## <a id="wiki-download-and-setup"></a>下载与安装 Seafile 专业版服务器

### 获得许可证书

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

### 安装

Seafile 专业版服务器的安装步骤与Seafile 社区版服务器安装步骤相同。

1. [下载与安装 Seafile 服务器并使用 MySQL 数据库](../deploy/using_mysql.md)
2. [使用 Nginx 为 Web 服务器](../deploy/deploy_with_nginx.md)
3. [配置和使用 Memcached](../deploy/add_memcached.md) (可选，建议用户数超过 50 人的时候配置)
4. [配置和使用 HTTPS](../deploy/https_with_nginx.md) (可选)
5. [配置开机启动脚本](../deploy/start_seafile_at_system_bootup.md) (可选)

在您成功安装 Seafile 专业版服务器之后，您的目录结构应该像如下这样：

```
#tree haiwen -L 2
haiwen
├── seafile-license.txt # license file
├── conf                # configuration files
│   ├── ccnet.conf
│   └── seafile.conf
│   └── seahub_settings.py
│   └── seafdav.conf
├── ccnet
│   ├── mykey.peer
│   ├── PeerMgr
│   └── seafile.ini
├── pro-data            # data specific for professional version
│   └── seafevents.conf
├── seafile-data
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
```

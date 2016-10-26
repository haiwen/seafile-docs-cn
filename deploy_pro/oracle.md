# 使用 Oracle 数据库部署 Seafile 专业版服务器

- [安装依赖库](#wiki-install-libs)
- [数据库配置](#wiki-setup-oracle)
- [下载与安装](#wiki-download-and-setup)
- [启动 Seafile 服务器](#wiki-start-server)

## <a id="wiki-install-libs"></a>安装依赖库 ##

Ubuntu 14.04，可用以下命令安装全部依赖。

```
sudo apt-get install openjdk-7-jre poppler-utils libpython2.7 python-pip \
mysql-server python-setuptools python-imaging python-memcache python-dev \
python-ldap python-urllib3

sudo pip install boto
```

CentOS 7 下:

```
wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
sudo yum install java-1.7.0-openjdk poppler-utils python-dev python-setuptools \
python-imaging python-memcached python-ldap \
python-urllib3
sudo pip install boto
```

**补充说明： 关于 Java**

*注意*：Seafile 专业版需要 java 1.7 以上版本, 请用 `java -version` 命令查看您系统中的默认 java 版本. 如果不是 java 7, 那么, 请 [更新默认 java 版本](./change_default_java.md).

### 安装 Oracle 客户端库

从 [Oracle 官网](http://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html) 下载 `basic`, `sqlplus`, `devel` 三个 rpm 包。

在 CentOS/RedHat 下，

```
sudo rpm -ivh oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm
sudo rpm -ivh oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm
sudo rpm -ivh oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm
```

在 Ubuntu 下，使用 `alien` 程序来安装 rpm 包。

```
sudo apt-get install alien
sudo alien -i oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm
sudo alien -i oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm
sudo alien -i oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm
```

安装之后，相应的文件所在路径：

- 库：/usr/lib/oracle/12.1/client64/lib
- 客户端程序：/usr/lib/oracle/12.1/client64/bin

另外，在 /usr/bin 下面还有一个 sqlplus64 的符号链接指向 /usr/lib/oracle/12.1/client64/bin/sqlplus。

把 Oracle 库的路径加入 `LD_LIBRARY_PATH`:

```
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/oracle/12.1/client64/lib
```

设置 `ORACLE_HOME` 环境变量：

```
export ORACLE_HOME=/usr/lib/oracle/12.1/client64
```

**把上面两个配置加入到 `~/.bashrc` 里面，以便重新登录之后仍然生效。**

测试 sqlplus 客户端是否能工作：

```
sqlplus64 seafile/seafile@192.168.1.178/XE
```

上述命令通过 seafile 用户和密码访问 Oracle 数据库。命令的格式为 `sqlplus64 {user}/{password}@{server_address}/{service_name}`。`service_name` 是 Oracle 数据库在安装的时候设置的，可以咨询 DBA。

最后安装 Oracle python 客户端库 `cx_Oracle`：

```
sudo pip install cx_Oracle
```

## <a id="wiki-setup-oracle"></a>Oracle数据库配置 ##

推荐为 Seafile 服务器专门创建一个 Oracle 数据库用户和相应的 Tablespace，以便于管理。以下命令均在 SQLPlus 命令行里面执行。

创建给用户使用的 tablespace。该 tablespace 从20M开始，自动按需扩大。DBA 可以根据自己的需求和经验调整命令的参数。

```
create tablespace seafile_ts datafile 'seafile_ts.dat' size 20M autoextend on;
```

创建用户（用户名 seafile，示例密码也是 seafile）并给予相应的权限，并关联 tablespace，限定最多使用 5GB 空间。Seafile 中有的表格会随着使用时间的增长而增长，比如用户的 session 表等，为了减少 tablespace 达到空间上限导致服务中断的可能性，我们建议给 tablespace 分配重组的空间。这些较大的表格可以定期清理，以减少空间使用。

```
create user seafile identified by seafile default tablespace seafile_ts quota 5000M on seafile_ts;
```

赋予新用户权限。Seafile 服务器需要使用创建 Sequence 对象的权限。

```
grant connect, create table, create sequence, create trigger to seafile;
```

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

我们先按照使用 SQLite 数据库的方式来完成安装，然后再手工配置使用 Oracle 数据库。

    cd seafile-server-*
    ./setup-seafile.sh  #运行安装脚本并回答预设问题

如果你的系统中没有安装上面的某个软件，那么 Seafile 初始化脚本会提醒你安装相应的软件包。 该脚本会依次询问你一些问题，从而一步步引导你配置 Seafile 的各项参数。

<table>
<tr>
<th>参数</th>
<th>作用</th>
<th>说明</th>
</tr>
<tbody>
<tr class="odd">
<td align="left"><p>seafile server name</p></td>
<td align="left"><p>seafile 服务器的名字，目前该配置已经不再使用</p></td>
<td align="left"><p>3 ~ 15 个字符，可以用英文字母，数字，下划线</p></td>
</tr>
<tr class="even">
<td align="left"><p>seafile server ip or domain</p></td>
<td align="left"><p>seafile 服务器的 IP 地址或者域名</p></td>
<td align="left"><p>客户端将通过这个 IP 或者地址来访问你的 Seafile 服务</p></td>
</tr>
<tr class="even">
<td align="left"><p>seafile data dir</p></td>
<td align="left"><p>seafile 数据存放的目录，用上面的例子，默认将是 /data/haiwen/seafile-data</p></td>
<td align="left"><p>seafile 数据将随着使用而逐渐增加，请把它放在一个有足够大空闲空间的分区上</p></td>
</tr>
<tr class="even">
<td align="left"><p>seafile fileserver port</p></td>
<td align="left"><p>seafile fileserver 使用的 TCP 端口</p></td>
<td align="left"><p>一般使用默认的 8082 端口，如果已经被占用，可以设置为其他的端口</p></td>
</tr>
<tr class="odd">
</tr>
</tbody>
</table>

**如果安装正确完成，会打印成功消息**

现在你的目录结构将会是如下:

    #tree haiwen -L 2
    haiwen
    ├── conf                # configuration files
    │   ├── ccnet.conf
    │   └── seafile.conf
    │   └── seahub_settings.py
    │   └── seafdav.conf
    ├── ccnet
    │   ├── mykey.peer
    │   ├── PeerMgr
    │   └── seafile.ini
    ├── installed
    │   └── seafile-server_1.4.0_x86-64.tar.gz
    ├── seafile-data
    ├── seafile-server-1.4.0  # active version
    │   ├── reset-admin.sh
    │   ├── runtime
    │   ├── seafile
    │   ├── seafile.sh
    │   ├── seahub
    │   ├── seahub.sh
    │   ├── setup-seafile.sh
    │   └── upgrade
    ├── seafile-server-latest  # symbolic link to seafile-server-1.4.0
    ├── seahub-data
    │   └── avatars
    ├── seahub.db

`seafile-server-latest`文件夹是当前 Seafile 服务器文件夹的符号链接.将来你升级到新版本后, 升级脚本会自动更新使其始终指向最新的 Seafile 服务器文件夹。

### 配置 Seafile 使用 Oracle 数据库

修改 `haiwen/conf/ccnet.conf`，加入以下选项：

```
[Database]
ENGINE = oracle
HOST = 192.168.1.178
USER = seafile
PASSWD = seafile
SERVICE_NAME = XE
```

把 `HOST`, `USER`, `PASSWD` 替换成你的环境中具体的值，`SERVICE_NAME` 是 Oracle 数据库实例的 service name，具体请咨询 DBA 并替换成你们的实际名称。

修改 `haiwen/conf/seafile.conf`，加入以下选项：

```
[database]
type = oracle
host = 192.168.1.178
user = seafile
password = seafile
service_name = XE
```

修改 `haiwen/conf/seahub_settings.py`，加入以下选项：

```
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.oracle',
        'NAME': 'xe',
        'USER': 'seafile',
        'PASSWORD': 'seafile',
        'HOST': '192.168.1.178',
        'PORT': '1521',
    },
    'OPTIONS': {
        'threaded': True,
    },
}
```

修改 `haiwen/conf/seafevents.conf`，加入以下选项：

```
[DATABASE]
type = oracle
host = 192.168.1.178
username = seafile
password = seafile
service_name = XE
```

### 在 Oracle 数据库中创建 Seafile 所需表格

在启动 seafile/ccnet 之前，需要先手工创建表格。创建表格的 SQL 语句在 `seafile-server-latest/create-db/oracle` 目录下面的 `ccnet_db.sql`, `seafile_db.sql`, `seahub_db.sql` 脚本里面。

你可以在 SQLPlus 命令行里面通过如下命令创建表格：

```
SQL> @seafile_db.sql
SQL> @ccnet_db.sql
SQL> @seahub_db.sql
```

## <a id="wiki-start-server"></a>启动 Seafile 服务器

### 启动 Seafile 服务器和 Seahub 网站

在 seafile-server-latest 目录下，运行如下命令

-   启动 Seafile:

<!-- -->

    ./seafile.sh start # 启动 Seafile 服务

-   启动 Seahub

<!-- -->

    ./seahub.sh start <port>  # 启动 Seahub 网站 （默认运行在8000端口上）


**小贴士:** 你第一次启动 seahub 时，`seahub.sh` 脚本会提示你创建一个 seafile 管理员帐号。

服务启动后, 打开浏览器并输入以下地址

    http://192.168.1.111:8000/

你会被重定向到登陆页面. 输入管理员用户名和密码即可。

**恭喜!** 现在你已经成功的安装了 Seafile 服务器.

#### 在另一端口上运行 Seahub

如果你不想在默认的 8000 端口上运行 Seahub, 而是想自定义端口（比如8001）中运行，请按以下步骤操作:

-   关闭 Seafile 服务器

<!-- -->

    ./seahub.sh stop # 停止 Seafile 进程
    ./seafile.sh stop # 停止 Seahub

-   更改`haiwen/conf/ccnet.conf`文件中`SERVICE_URL` 的值(假设你的 ip 或者域名时`192.168.1.100`), 如下 (从 5.0 版本开始，可以直接在管理员界面中设置。注意，如果同时在 Web 界面和配置文件中设置了这个值，以 Web 界面的配置为准。):

<!-- -->

    SERVICE_URL = http://192.168.1.100:8001

-   重启 Seafile 服务器

<!-- -->

    ./seafile.sh start # 启动 Seafile 服务
    ./seahub.sh start 8001 # 启动 Seahub 网站 （运行在8001端口上）



关闭/重启 Seafile 和 Seahub
---------------------------

#### 关闭

    ./seahub.sh stop # 停止 Seahub
    ./seafile.sh stop # 停止 Seafile 进程

#### 重启

    ./seafile.sh restart # 停止当前的 Seafile 进程，然后重启 Seafile
    ./seahub.sh restart  # 停止当前的 Seahub 进程，并在 8000 端口重新启动 Seahub

#### 如果停止/重启的脚本运行失败

大多数情况下 seafile.sh seahub.sh 脚本可以正常工作。如果遇到问题：

-   使用**pgrep**命令检查 seafile/seahub 进程是否还在运行中

<!-- -->

    pgrep -f seafile-controller # 查看 Seafile 进程
    pgrep -f "seahub" # 查看 Seahub 进程

-   使用**pkill**命令杀掉相关进程

<!-- -->

    pkill -f seafile-controller # 结束 Seafile 进程
    pkill -f "seahub" # 结束 Seafile 进程

OK!
---

查看seafile更多信息请访问:

* [Nginx 下配置 Seahub](deploy_with_nginx.md) / [Apache 下配置 Seahub](deploy_with_apache.md)
* [Nginx 下启用 Https](https_with_nginx.md) / [Apache 下启用 Https](https_with_apache.md)
* [Seafile LDAP配置](using_ldap.md)
* [管理员手册](../maintain/README.md)

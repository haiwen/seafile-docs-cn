# 部署 Seafile 服务器（使用 MySQL/MariaDB）

本文档用来说明通过预编译好的安装包来安装并运行基于 MySQL/MariaDB 的 Seafile 服务器。(MariaDB 是 MySQL 的分支)

下载
----

到[下载页面](http://www.seafile.com/download)下载最新的服务器安装包.


部署和目录设计
--------------

假设你公司的名称为 **haiwen**, 你也已经下载 seafile-server\_1.4.0\_\* 到你的
**home** 目录下。 我们建议这样的目录结构:

    mkdir haiwen
    mv seafile-server_* haiwen
    cd haiwen
    #将 seafile-server_* 移动到 haiwen 目录下后
    tar -xzf seafile-server_*
    mkdir installed
    mv seafile-server_* installed

现在，你的目录看起来应该像这样：

    #tree haiwen -L 2
    haiwen
    ├── installed
    │   └── seafile-server_1.8.2_x86-64.tar.gz
    └── seafile-server-1.8.2
        ├── reset-admin.sh
        ├── runtime
        ├── seafile
        ├── seafile.sh
        ├── seahub
        ├── seahub.sh
        ├── setup-seafile.sh
        └── upgrade

**这样设计目录的好处在于**

-   和 seafile 相关的配置文件都可以放在 **haiwen** 目录下，便于集中管理.
-   后续升级时,你只需要解压最新的安装包到 **haiwen** 目录下.


## 安装 Seafile 服务器

### 安装前的准备工作

安装 Seafile 服务器之前，请确认已安装以下软件

- MariaDB 或者 MySQL 服务器 (MariaDB 是 MySQL 的分支)
- python 2.7 (从 Seafile 5.1 开始，python 版本最低要求为2.7）
- python-setuptools
- python-imaging
- python-mysqldb
- python-ldap
- python-urllib3
- python-memcache (或者 python-memcached)

```
# on Debian/Ubuntu 14.04 server
apt-get update
apt-get install python2.7 libpython2.7 python-setuptools python-imaging \
  python-ldap python-mysqldb python-memcache python-urllib3
```

```
# on Ubuntu 16.04 server
# As the default python binary on Ubuntu 16.04 server is python 3, we need to install python (python 2) first.
apt-get update
apt-get install python
apt-get install python2.7 libpython2.7 python-setuptools python-imaging python-ldap python-urllib3 ffmpeg python-pip python-mysqldb python-memcache
pip install pillow moviepy
```

```
# on CentOS 7
yum -y install epel-release
rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
yum -y install python-imaging MySQL-python python-memcached python-ldap python-urllib3 ffmpeg ffmpeg-devel
pip install pillow moviepy
```

### 安装

    cd seafile-server-*
    ./setup-seafile-mysql.sh  #运行安装脚本并回答预设问题

如果你的系统中没有安装上面的某个软件，那么 Seafile初始化脚本会提醒你安装相应的软件包.

该脚本会依次询问你一些问题，从而一步步引导你配置 Seafile 的各项参数:

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
<td align="left"><p>该端口用于文件同步，请使用默认的 8082，不能更改。</p></td>
</tr>
</tbody>
</table>

在这里, 你会被要求选择一种创建 Seafile 数据库的方式:

    -------------------------------------------------------
    Please choose a way to initialize seafile databases:
    -------------------------------------------------------

    [1] Create new ccnet/seafile/seahub databases
    [2] Use existing ccnet/seafile/seahub databases


-   如果选择`1`, 你需要提供根密码. 脚本程序会创建数据库和用户。
-   如果选择`2`, ccnet/seafile/seahub 数据库应该已经被你（或者其他人）提前创建。

如果安装正确完成，你会看到下面这样的输出 (新版本可能会有所不同)

![server-setup-succesfully](../images/Server-setup-successfully.png)

现在你的目录结构看起来应该是这样:

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
    │   └── seafile-server_1.8.2_x86-64.tar.gz
    ├── seafile-data
    ├── seafile-server-1.8.2  # active version
    │   ├── reset-admin.sh
    │   ├── runtime
    │   ├── seafile
    │   ├── seafile.sh
    │   ├── seahub
    │   ├── seahub.sh
    │   ├── setup-seafile.sh
    │   └── upgrade
    ├── seafile-server-latest  # symbolic link to seafile-server-1.8.2
    ├── seahub-data
    │   └── avatars

`seafile-server-latest`文件夹为指向当前 Seafile 服务器文件夹的符号链接.
将来你升级到新版本后, 升级脚本会自动更新使其始终指向最新的 Seafile 服务器文件夹.

# 启动 Seafile 服务器

### 启动 Seafile 服务器和 Seahub 网站

在 seafile-server-1.8.2 目录下，运行如下命令

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

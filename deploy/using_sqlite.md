# 部署 Seafile 服务器（使用 SQLite）

这份文档用来说明如何使用预编译好的文件包来安装和运行 Seafile 服务器。

下载
----

到[下载页面](http://www.seafile.com/download)下载最新的服务器安装包.


部署和目录结构
--------------

注意:如果你把 Seafile文件放在一个外部存储的目录里（比如NFS，CIFS）,你应该使用 MySQL 而不是SQLite来作为数据库。请参考[下载和安装Seafile服务器（使用MySQL）](using_mysql.md)。

假设你公司的名称为"haiwen",你也已经下载 seafile-server\_1.4.0\_\* 到你的home 目录下。 我们建议这样的目录结构:

    mkdir haiwen  
    mv seafile-server_* haiwen
    cd haiwen
    #将 seafile-server_* 移动到 haiwen 目录下后
    tar -xzf seafile-server_*
    mkdir installed
    mv seafile-server_* installed

现在，你的目录看起来应该像这样：

    # tree . -L 2
    .
    ├── installed
    │   └── seafile-server_1.4.0_x86-64.tar.gz
    └── seafile-server-1.4.0
        ├── reset-admin.sh
        ├── runtime
        ├── seafile
        ├── seafile.sh
        ├── seahub
        ├── seahub.sh
        ├── setup-seafile.sh
        └── upgrade

**这样设计目录的好处在于**

-   和 seafile 相关的配置文件都可以放在 haiwen 目录下，便于集中管理.
-   后续升级时,你只需要解压最新的安装包到"haiwen"目录下.

*这样你可以重用"haiwen"目录下已经存在的配置文件，而不用重新配置*.

安装 Seafile 服务器
-------------------

### 安装前的准备工作

安装 Seafile 服务器之前，请确认已安装以下软件

-   python 2.7
-   python-setuptools
-   python-imaging
-   sqlite3

<!-- -->

    #Debian系统下
    apt-get update
    apt-get install python2.7 python-setuptools python-imaging sqlite3

### 安装

    cd seafile-server-*
    ./setup-seafile.sh  #运行安装脚本并回答预设问题

如果你的系统中没有安装上面的某个软件，那么 Seafile 初始化脚本会提醒你安装相应的软件包. 该脚本会依次询问你一些问题，从而一步步引导你配置 Seafile 的各项参数

<table>
<tr>
<th>参数</th>
<th>作用</th>
<th>说明</th>
</tr>
<tbody>
<tr class="odd">
<td align="left"><p>seafile server name</p></td>
<td align="left"><p>seafile 服务器的名字，将来在客户端会显示为这个名字</p></td>
<td align="left"><p>3 ~ 15 个字符，可以用英文字母，数字，下划线</p></td>
</tr>
<tr class="even">
<td align="left"><p>seafile server ip or domain</p></td>
<td align="left"><p>seafile 服务器的 IP 地址或者域名</p></td>
<td align="left"><p>客户端将通过这个 IP 或者地址来访问你的 Seafile 服务</p></td>
</tr>
<tr class="odd">
<td align="left"><p>ccnet server port</p></td>
<td align="left"><p>ccnet 使用的 TCP 端口</p></td>
<td align="left"><p>一般使用默认的10001 端口，如果已经被占用，可以设置为其他的端口</p></td>
</tr>
<tr class="even">
<td align="left"><p>seafile data dir</p></td>
<td align="left"><p>seafile 数据存放的目录，用上面的例子，默认将是 /data/haiwen/seafile-data</p></td>
<td align="left"><p>seafile 数据将随着使用而逐渐增加，请把它放在一个有足够大空闲空间的分区上</p></td>
</tr>
<tr class="odd">
<td align="left"><p>seafile server port</p></td>
<td align="left"><p>seafile 服务器 使用的 TCP 端口</p></td>
<td align="left"><p>一般使用默认的 12001 端口，如果已经被占用，可以设置为其他的端口</p></td>
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
    ├── ccnet               # configuration files
    │   ├── ccnet.conf
    │   ├── mykey.peer
    │   ├── PeerMgr
    │   └── seafile.ini
    ├── installed
    │   └── seafile-server_1.4.0_x86-64.tar.gz
    ├── seafile-data        
    │   └── seafile.conf
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
    ├── seahub_settings.py   # optional config file
    └── seahub_settings.pyc

`seafile-server-latest`文件夹是当前 Seafile 服务器文件夹的符号链接.将来你升级到新版本后, 升级脚本会自动更新使其始终指向最新的 Seafile 服务器文件夹.

启动运行 Seafile 服务器
-----------------------

### 启动之前

因为 Seafile 在客户端和服务器之间使用持续连接，如果你的客户端**数量巨大**, 你应该在启动 Seafile 之前修改你的 Linux 文件最大打开数，如下:

    ulimit -n 30000

### 启动 Seafile 服务器和 Seahub 网站

在 seafile-server-1.4.0 目录下，运行如下命令：

-   启动 Seafile:

<!-- -->

    ./seafile.sh start # 启动 Seafile 服务

-   启动 Seahub

<!-- -->

    ./seahub.sh start <port> # 启动 Seahub 网站 （默认运行在8000端口上）

**小贴士:** 你第一次启动 seahub 时，`seahub.sh` 脚本会提示你创建一个 seafile 管理员帐号。

服务启动后, 打开浏览器并输入以下地址

    http://192.168.1.111:8000/

你会被重定向到登陆页面. 输入你在安装 Seafile 时提供的用户名和密码后，你会进入 Myhome 页面，新建资料库.

**恭喜!** 现在你已经成功的安装了 Seafile 服务器.

#### 在另一端口上运行 Seahub

如果你不想在默认的 8000 端口上运行 Seahub, 而是想自定义端口（比如8001）中运行，请按以下步骤操作:

-   关闭 Seafile 服务器

<!-- -->

    ./seahub.sh stop # 停止 Seafile 进程
    ./seafile.sh stop # 停止 Seahub

-   更改`haiwen/ccnet/ccnet.conf`文件中`SERVICE_URL` 的值(假设你的 ip
    或者域名时`192.168.1.100`), 如下:

<!-- -->

    SERVICE_URL = http://192.168.1.100:8001

-   重启 Seafile 服务器

<!-- -->

    ./seafile.sh start # 启动 Seafile 服务
    ./seahub.sh start 8001 # 启动 Seahub 网站 （运行在8001端口上）

`ccnet.conf`更多细节请看[[Seafile服务器配置选项]].

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
    pgrep -f "manage.py run_gunicorn" # 查看 Seahub 进程

-   使用**pkill**命令杀掉相关进程

<!-- -->

    pkill -f seafile-controller # 结束 Seafile 进程
    pkill -f "manage.py run_gunicorn" # 结束 Seafile 进程

OK!
---

查看 Seafile 更多信息请移至..

- [管理员手册](../maintain/README.md)

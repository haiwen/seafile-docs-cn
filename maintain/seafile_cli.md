# Seafile
## Seafile CLI

init
----
初始化配置文件

用法: seaf-cli -c <config-dir> -o init

start
-----
启动seafile-applet来运行Seafile客户端

用法: seaf-cli -c <config-dir> -o start

start-ccnet
-----------
启动Ccnet守护进程

用法: seaf-cli -c <config-dir> -o start-ccnet

start-seafile
-------------
启动Seafile守护进程

用法: seaf-cli -c <config-dir> [-w <worktree>] -o start-seafile

clone
-----
从Seafile服务器克隆一个资料库

由于此操作需要用到Seafile web API v2，所以命令需要提供库id和url参数

用法: seaf-cli -c <config-dir> -r <repo-id> -u <url> [-w <worktree>] -o clone

sync
----
试着同步一个资料库

用法: seaf-cli -c <config-dir> -r <repo-id> -o clone

remove
------
试着不同步一个资料库

用法: seaf-cli -c <config-dir> -r <repo-id> -o remove

## 用法

子命令:

    init:           为Seafile客户端创建配置文件
    start:          以守护进程方式启动和运行Seafile客户端
    stop:           退出Seafile客户端
    list:           列举本地资料库
    status:         展示同步状态
    download:       从Seafile服务器下载一个资料库
    sync:           同步本地文件夹与seafile服务器的资料库
    desync:         取消Seafile服务器资料库的同步


##更多细节

Seafile客户端存储其所有的配置信息于配置目录，它默认位于`~/.ccnet`。所有的如下命令均接受`-c <config-dir>`选项。

init
----
初始化Seafile客户端。这个命令初始化配置文件目录，它也同时创建`seafile-data`和`seafile`两个子目录在`parent-dir`下。`seafile-data`用于存储内部数据而`seafile`作为存放下载的资料库的默认位置。

    seaf-cli init [-c <config-dir>] -d <parent-dir>

start
-----
启动Seafile客户端。这个命令启动`ccnet`和`seaf-daemon`, `ccnet`是seafile客户端网络通信部分，`seaf-daemon`用于管理文件。

    seaf-cli start [-c <config-dir>]

stop
----
退出Seafile客户端。

    seaf-cli stop [-c <config-dir>]


Download
--------
从Seafile服务器下载资料库。

    seaf-cli download -l <library-id> -s <seahub-server-url> -d <parent-directory> -u <username> [-p <password>]


sync
----
同步资料库与本地目录。

    seaf-cli sync -l <library-id> -s <seahub-server-url> -d <existing-folder> -u <username> [-p <password>]

desync
------
取消Seafile服务器的一个资料库同步。

    seaf-cli desync -d <existing-folder>

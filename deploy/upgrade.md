# 升级

使用已经预编译的 Seafile 服务器安装包用户请看. 

- 如果你是[build seafile server from source](../build_seafile/server.md)安装 Seafile 服务器的, 请阅读"升级 Seafile 服务器"部分。

- 如果你部署 Seafile 服务器时使用了 MySQL, 你需要手动更新数据库表. 详细请见[部署 Seafile 服务器（使用 MySQL）](using_mysql.md).

- 升级之后, 如果没有正常运行，请清空[ Seahub 缓存](add_memcached.md).

## 主版本连续升级(比如从1.2升级到1.3)

连续升级，是指从 Seafile 服务器某一版本升级到下一版本.例如, 从 1.2.0 升级到 1.3.0 (或者从 1.2.0 升级到 1.3.1 ).

**注意:** 小版本升级, 从 1.3.0 升级到 1.3.1 ,后文也有详细说明.

首先，下载 seafile-server_1.3.0_x86-64.tar.gz 并解压到相关 Seafile 文件目录下，文件结构如下:

<pre>
haiwen
   -- seafile-server-1.2.0
   -- seafile-server-1.3.0
   -- ccnet
   -- seafile-data
</pre>

现在开始升级到 1.3.0 版本.

1. 关掉 Seafile 服务器

```
cd haiwen/seafile-server-1.2.0
./seahub.sh stop
./seafile.sh stop
```

2. 在 seafile-server-1.3.0 目录下运行升级脚本.

```
cd haiwen/seafile-server-1.3.0
upgrade/upgrade_1.2_1.3_server.sh
```
3. 启动新版本服务器程序 

```sh
cd haiwen/seafile-server-1.3.0/
./seafile.sh start
./seahub.sh start
```

## 不连续升级(比如从 1.1.0 升级到 1.3.0 )

如果你想从 1.1.0 直接升级到 1.3.0 .过程如下:

1. 从 1.1.0 升级到 1.2.0.
2. 从 1.2.0 升级到 1.3.0.

按顺序运行升级脚本. (不需要下载 1.2.0 版本的安装包)

## 小版本升级(比如从 1.5.0 升级到 1.5.1 )

这是我们的目录结构

<pre>
haiwen
   -- seafile-server-1.5.0
   -- seafile-server-1.5.1
   -- ccnet
   -- seafile-data
</pre>

1. 在升级前需停止相关服务进程：
```
seafile-server-1.5.0/seahub.sh stop
seafile-server-1.5.0/seafile.sh stop
```
2. 对于小版本升级，你只需要更新avatar链接. 运行以下脚本即可:
```
cd seafile-server-1.5.1
upgrade/minor-upgrade.sh
```
3. 任何升级后都需要重新启动服务器进程:
```
cd ..
seafile-server-1.5.1/seafile.sh start
seafile-server-1.5.1/seahub.sh start
```

4. 如果新版本Seafile运行正常，可以删除旧版本的文件:
```
rm -rf seafile-server-1.5.0
```

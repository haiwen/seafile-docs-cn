# Seafile

## 升级指南

使用预编译 Seafile 服务器安装包的用户请看.

- 如果你是 [源码编译安装 Seafile](../build_seafile/server.md) 的，请参考那篇文档中的 **升级** 部分。
- 升级之后, 如果没有正常运行，请清空 [Seahub 缓存](add_memcached.md)。

## 主版本升级 (比如从 2.x 升级到 3.y)

假设你现在使用 2.1.0 版本，想要升级到 3.1.0 版本，下载、解压新版本安装包后，得到目录结构如下：

<pre>
haiwen
   -- seafile-server-2.1.0
   -- seafile-server-3.1.0
   -- ccnet
   -- seafile-data
</pre>


升级到 3.1.0：

1. 关闭 Seafile 服务（如果正在运行）：

   ```sh
   cd haiwen/seafile-server-2.1.0
   ./seahub.sh stop
   ./seafile.sh stop
   ```
2. 查看 *seafile-server-3.1.0* 目录下的升级脚本：

   ```sh
   cd haiwen/seafile-server-3.1.0
   ls upgrade/upgrade_*
   ```

   可以看到升级脚本文件如下:

   ```
   ...
   upgrade/upgrade_2.0_2.1.sh
   upgrade/upgrade_2.1_2.2.sh
   upgrade/upgrade_2.2_3.0.sh
   upgrade/upgrade_3.0_3.1.sh
   ```

3. 从当前版本（2.1.0）开始，按顺序运行以下脚本：

   ```
   upgrade/upgrade_2.1_2.2.sh
   upgrade/upgrade_2.2_3.0.sh
   upgrade/upgrade_3.0_3.1.sh
   ```

4. 启动新版本 Seafile 服务器，完成升级：

   ```sh
   cd haiwen/seafile-server-3.1.0/
   ./seafile.sh start
   ./seahub.sh start
   ```

## 小版本升级 (比如从 3.0.x 升级到 3.2.y)

假设你现在使用 3.0.0 版本，想要升级到 3.2.2 版本，下载、解压新版本安装包，得到目录结构如下：


<pre>
haiwen
   -- seafile-server-3.0.0
   -- seafile-server-3.2.2
   -- ccnet
   -- seafile-data
</pre>


升级到 3.2.2：

1. 关闭 Seafile 服务（如果正在运行）：

   ```sh
   cd haiwen/seafile-server-3.0.0
   ./seahub.sh stop
   ./seafile.sh stop
   ```
2. 查看 *seafile-server-3.2.2* 目录下的升级脚本：

   ```sh
   cd haiwen/seafile-server-3.2.2
   ls upgrade/upgrade_*
   ```

   可以看到升级脚本文件如下:

   ```
   ...
   upgrade/upgrade_2.2_3.0.sh
   upgrade/upgrade_3.0_3.1.sh
   upgrade/upgrade_3.1_3.2.sh
   ```

3. 从当前版本（3.0.0）开始，按顺序运行以下脚本：

   ```
   upgrade/upgrade_3.0_3.1.sh
   upgrade/upgrade_3.1_3.2.sh
   ```

4. 启动新版本 Seafile 服务器，完成升级：

   ```sh
   cd haiwen/seafile-server-3.2.2/
   ./seafile.sh start
   ./seahub.sh start
   ```


## 微升级 (比如从 3.1.0 升级到 3.1.2)

类似从 3.1.0 升级到 3.1.2，为微升级。

1. 关闭 Seafile 服务（如果正在运行）；
2. 对于此类升级，只需更新头像链接，直接运行升级脚本即可(因为历史原因，此升级脚本命名为 `minor-upgrade.sh`):

   ```sh
   cd seafile-server-3.1.2
   upgrade/minor-upgrade.sh
   ```

3. 运行升级脚本之后，启动新版本 Seafile 服务器，完成升级；

4. 如果新版本运行正常，可以删除旧版本 Seafile 文件。

   ```sh
   rm -rf seafile-server-3.1.0
   ```

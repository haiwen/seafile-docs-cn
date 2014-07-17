# Seafile
## Seafile 服务器端软件升级指南

## 从 1.0.0 升级到 1.1.0

### 升级准备

* 请到 [http://www.seafile.com/download 这里] 下载最新的服务器 seafile-server_1.1.0_x86-64.tar.gz 压缩包。

### 开始升级

如果你在安装 Seafile 服务器软件 1.0.0 版本时，是按照 [[Seafile 服务器端软件的下载、初始化配置|Seafile 服务器初始化]]中的步骤来安装的，那么在升级之前，
<br/>你的目录结构如下:

<pre>
haiwen
   -- seafile-server-1.0.0
   -- ccnet
   -- seafile-data
</pre>

你需要按以下步骤来升级:

<ol>
<li>
如果你的 1.0.0 版本的 Seafile 服务器软件正在运行，必须先到 1.0.0 的目录下，运行脚本来停止其运行。
<pre>
$ cd haiwen/seafile-server-1.0.0
$ ./seahub.sh stop
$ ./seafile.sh stop
</pre>
</li>
<li>
把 seafile-server_1.1.0_x86-64.tar.gz (到 [http://www.seafile.com/download 这里] 下载) 解压缩到 haiwen/ 目录下。
<br/>这时你的目录结构如下:

<pre>
haiwen
   -- seafile-server-1.0.0
   -- seafile-server-1.1.0
   -- ccnet
   -- seafile-data
</pre>
</li>
<li>
到 seafile-server-1.1.0 目录下，运行 upgrade_1.0.0_1.1.0_server.sh 脚本
<pre>
$ cd haiwen/seafile-server-1.1.0
$ ./upgrade_1.0.0_1.1.0_server.sh
</pre>
</li>
</ol>

运行完毕之后，你就可以启动新版的 Seafile 服务器了。确认正常后，你就可以删除 haiwen/seafile-server-1.0.0 目录了。


## 不连续升级

如果您需要进行不连续的升级，比如，从 0.9.4 版本 升级到 1.0.0 版本，请按照一下步骤进行。

这中间一共经历了下版本:

* 0.9.4
* 0.9.5
* 1.0.0

你需要到 seafile-server-1.0.0/ 目录下，依次运行这些脚本：

* upgrade_0.9.4_0.9.5_server.sh
* upgrade_0.9.5_1.0.0_server.sh

upgrade_x.x.x_y.y.y_server.sh 的脚本命名方式为：

* x.x.x 是你当前的版本号
* y.y.y 是你要升级到的版本号

'''总之，你需要'''

* 到最新的版本的目录下
* 把从 你当前的版本 到 最新的版本 之间的所有脚本都顺序执行一遍

## 小版本升级

小版本升级是指形如 1.0.1 到 1.0.2 这样的升级。 需要做的是：

<pre>
cd haiwen/seafile-server-1.3.1/seahub/media
cp -rf avatars/* ../../../seahub-data/avatars/
rm -rf avatars
ln -s ../../../seahub-data/avatars
</pre>

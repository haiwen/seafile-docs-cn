#Seafile
##Seafile 服务器端软件的下载、初始化配置

## 下载

* 请到 [http://www.seafile.com/download 这里] 下载最新的服务器 seafile-server.tar.gz 压缩包。

## 解压

比如你的公司/组织 名叫 haiwen，下载了 0.9.4 版本的 64 位服务器端软件。那么，

* 新建一个 haiwen 的文件夹
* 把下载的 seafile-server_0.9.4_x86-64.tar.gz 包解压到 haiwen 目录下。

<pre>
    mkdir haiwen
    cd haiwen
    wget http://www.gonggeng.org/~gonggeng/seafile-server_0.9.4_x86-64.tar.gz
    tar xzf seafile-server_0.9.4_x86-64.tar.gz
</pre>

此时你的目录结构如下：
<pre>
  haiwen
     -- seafile-server-0.9.4
</pre>

'''这样的好处是''':

* 和 seafile 相关的配置文件都可以放在 haiwen 目录下，便于集中管理
* 后续升级时，只需要先删除原来的 seafile-server 文件夹，再把最新的服务器端 seafile-server.tar.gz 包解压到 haiwen 下就行了。
''这样你在升级之后仍然可以继续使用之前的配置和数据''，无需重新配置。

## 配置

#### 配置前提

首先要保证你的服务器上已经安装了以下软件：

* python 2.6 或 2.7
* python-setuptools
* python-simplejson
* python-imaging
* sqlite3

如果你的系统中没有安装上面的某个软件，那么 seafile 初始化脚本会提醒你安装相应的软件包。

#### 开始配置

进入到 seafile-server-0.9.4 目录下，运行该目录下的 setup-seafile.sh 脚本
<pre>
$ ./setup-seafile.sh
</pre>

[[images/server-setup.png|运行 setup-seafile.sh 脚本时，你将会看到这样的过程 ]]

该脚本会依次询问你一些问题，从而一步步引导你配置 seafile 的各项参数

{| border="1" cellspacing="0" cellpadding="5" align="center"
|+ Seafile 配置参数
! 参数
! 作用
! 说明
|-
| seafile server name
| seafile 服务器的名字，将来在客户端会显示为这个名字
| 3 ~ 15 个字符，可以用英文字母，数字，下划线
|-
| seafile server ip or domain
| seafile 服务器的 IP 地址或者域名
| 客户端将通过这个 IP 或者地址来访问你的 Seafile 服务
|-
| ccnet server port
| ccnet 使用的 TCP 端口
| 一般使用默认的10001 端口，如果已经被占用，可以设置为其他的端口
|-
| seafile data dir
| seafile 数据存放的目录，用上面的例子，默认将是 /data/haiwen/seafile-data
| seafile 数据将随着使用而逐渐增加，请把它放在一个有足够大空闲空间的分区上
|-
| seafile server port
| seafile 服务器 使用的 TCP 端口
| 一般使用默认的 12001 端口，如果已经被占用，可以设置为其他的端口
|-
| seafile fileserver port
| seafile fileserver 使用的 TCP 端口
| 一般使用默认的 8082 端口，如果已经被占用，可以设置为其他的端口
|-
| seahub admin email
| sehaub管理员的登录帐户名
| 使用一个 email 地址
|-
| seahub admin password
| seahub 管理员的密码
|
|-
|}

如果配置成功，setup-seafile.sh 会打印成功的消息。

[[images/server-setup-successfully.png|如果配置成功，你将会看到这张图片]]

此时你的目录结构将会是如下：

<pre>
   haiwen
     --seafile-server # 由 tar.gz 包解压而来
     --seafile-data   # seafile 的配置和数据
     --seahub-data    # seahub 的数据
     --ccnet          # ccnet 的配置和数据
     --seahub.db      # seahub 使用的 sqlite3 数据库
     --seahub_settings.py # seahub 的可选配置文件
</pre>

## 运行

#### 启动 seafile 服务器及 seahub 网站

在 seafile-server 目录下，执行以下命令：

<pre>
./seafile.sh start # 启动 seafile 服务
./seahub.sh start  # 启动 seahub 网站 （默认运行在8000端口上）
</pre>

服务启动之后，你可以打开浏览器，访问你的 Seahub 站点，检查是否工作正常。

接下来你可以看看[[Seafile 服务器管理|如何管理服务器]]了。

## 附录：停止及重启 Seafile，Seahub

#### 停止

<pre>
./seafile.sh stop # 停止 seafile 进程
./seahub.sh stop # 停止 seahub
</pre>

#### 重启

<pre>
./seafile.sh restart # 停止当前的 seafile 进程，然后重启 seafile
./seahub.sh restart  # 停止当前运行的 seahub 进程，并在 8000 端口重新启动 seahub
</pre>

#### 如果停止/重启的脚本运行失败

大多数情况下 seafile.sh seahub.sh 脚本可以正常工作。如果遇到问题：

* 可以通过 '''pgrep''' 命令 来检查 seafile/seahub 的进程是否在运行:

<pre>
$ pgrep -f seafile-controller # 检查 seafile 进程是否在运行
$ pgrep -f "manage.py run_gunicorn" # 检查 seahub 进程是否在运行
</pre>

* 要强行杀死 seafile/seahub 进程，把上面的 pgrep 换成 '''pkill''' 命令即可。

<pre>
$ pkill -f seafile-controller
$ pkill -f "manage.py run_gunicorn"
$ pkill -f fileserver
</pre>

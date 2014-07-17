#Seafile
##Seafile Windows 版服务器端软件的下载、初始化配置

## 使用前的准备
* 下载安装 [http://www.python.org/download/releases/2.7/ python2.7] 。
* 将python.exe所在的目录加到系统环境变量PATH中去。

## 下载
* 请到 [http://www.seafile.com/download 这里] 下载最新的服务器 seafile-server.tar.gz 压缩包。

## 解压
软件下载后解压到任一目录即可。此时软件包的目录结构如下：

<pre>
   seafile-server
     --seafile     # 程序
     --seahub      # web服务器
     --upgrade     # 服务器升级脚本
</pre>

## 配置
首先保证服务器上python已经安装配置完成。然后下载 Windows 服务器的试用 Licence 文件 seafserv.lic， 将文件 seafserv.lic拷入seafile/bin 目录或当前用户主目录。

进入 seafile/bin
目录，双击运行程序seafserv-applet.exe。 第一次运行会弹出一个对话框用于选择 seafile 服务器数据存放的磁盘，选择一个容量较大的磁盘。然后seafile即会自动启动所有相关的服务, 并在操作系统右下角出现一个小图标。右键单击小图标后在菜单中选择 "添加管理员" ,创建管理员账户。 然后登录 [http://127.0.0.1:8080 http://127.0.0.1:8080], 即可以管理员访问相关服务。

若需要修改配置，参考 [[Seafile 服务器配置详细说明|Seafile 服务器配置详细说明]]

## Seafile 的数据库配置
Windows 服务器目前仅支持 SQLITE 和 MySQL，默认使用SQLITE，MySQL的配置参考[[Deploy Seafile with MySQL|Deploy Seafile with MySQL]]。

## 使用Nginx/Apache配置Seafile Web服务器
先修改配置文件seafile-data/seafile.conf,
<pre>
    [seahub]
    port=8000
    fastcgi=true
</pre>

然后参考 [[Deploy Seafile with Nginx]] / [[Deploy Seafile with Apache]] 配置 Nginx/Apache。
https 的配置参考[[Enable Https on Seafile Web with Nginx]] / [[Enable Https on Seafile Web with Apache]] 。

- [配置 Seafile Server](#wiki-config)
- [安装 Seafile Server 为 Windows 服务](#wiki-install-service)

# <a id="wiki-config"></a>配置 Seafile Server #

**特别说明：** 请不要在同一台 Windows 系统中同时使用 Seafile 客户端和服务器端。如果已经安装 Seafile 客户端，请将 Seafile 客户端退出或者卸载。

## 下载/解压 ##

### 安装  Python 2.7 ###

- 先下载安装 python 2.7, [下载地址](http://python.org/ftp/python/2.7.4/python-2.7.4.msi)
- 把 python2.7 的目录添加到系统 PATH 环境变量中。例如你安装了 python 2.7 到 `C:\Python27` 路径下，则把 `C:\Python27` 添加到系统 PATH 环境变量中

### 下载 /解压 Seafile Server ###
- 获取 Seafile Server 程序 [seafile-server_1.7.0_win32.tar.gz](http://cloud.seafile.com/repo/4cbf838a-bbb7-4106-a6b5-27f6d382dc90/732158cb0a6199b3fc1cdf682f6faf5df7c1c2d3/?file_name=seafile-server_1.7.0_win32.tar.gz&op=download)
- 新建一个文件夹，如 `C:\SeafileProgram\`,  用以存放 Seafile Server 程序。请牢记这个文件夹的位置，在后面的配置中都会用到它
- 把 **seafile-server_1.7.0_win32.tar.gz** 解压缩到 `C:\SeafileProgram\` 文件夹下

此时你的目录结构为:
```
C:\SeafileProgram
         |__ seafile-server-1.7.0
```

## 许可证 ##

把获得的许可证文件 **seafile-license.txt** 复制到 `C:\SeafileProgram` 目录下

30天试用版的许可证文件可以[点此下载](https://cloud.seafile.com/downloads/seafile-license.txt)

此时你的目录结构为:
```
C:\SeafileProgram
         |__ seafile-server-1.7.0
         |__ seafile-license.txt
```


## 启动/初始化 ##

### 启动服务器 ###

进入文件夹 `C:\SeafileProgram\seafile-server-1.7.0\`, 双击 **run.bat** 文件即可启动 Seafile Server。这时你能在系统托盘区看到一个 Seafile 图标

### 选择一个磁盘分区来存放 Seafile Server 数据 ###

此时会弹出一个对话框，你需要从中选择一个磁盘分区来存放 Seafile Server 产生的数据。

- 请选择一个足够大的磁盘
- 点击 "确定”按钮，Seafile 会在你所选择的分区下建立一个名为 `seafile-server` 的文件夹，此文件夹即为 Seafile Server 的数据文件夹。例如你选择了 D 盘，那么你的 Seafile Server 数据文件夹即为 `D:\seafile-server`

### 添加管理员 ###

右键点击 Seafile Server 托盘图标，选择 “**添加管理员**”，在弹出的对话框里输入管理员的帐号和密码。成功添加管理员后，托盘图标会弹出气泡提示 “添加管理员成功”

### 访问 Seahub ###

打开浏览器，在地址栏里输入 *http://127.0.0.1:8000*， 用管理员帐号登录。如果能成功登录，说明初始化成功。

## 配置 Seafile Server ##

初始化完成后，有一些基本设置需要修改。

- 右键点击托盘图标，选择 “**打开 seafile-server 目录**”，此时你的 seafile-server 数据文件夹会被打开
- 进入 seafile-server 目录下的 *ccnet* 目录，编辑该目录下的 *ccnet.conf* 文件。修改 *ccnet.conf* 中以下两行
```
NAME = XXXXX
SERVICE_URL = XXX
```
    - **NAME** 的值改为你的 Seafile Server 的名字，比如 `NAME = my-company-seafile`。这个名字会在 seafile 客户端显示出来。
    - **SERVICE_URL** 的值改为 *http://<你的 IP 地址>:8000*, 比如你的 windows 服务器的 IP 地址是 *192.168.1.100,* 那么就改为 `SERVICE_URL = http://192.168.1.101:8000`

修改完成之后，右键点击托盘图标，选择 “**重启 seafile**”

## 配置完成 ##

至此 Seafile Server 配置已经完成。关于客户端的的使用，请查看 [Seafile 客户端使用帮助](http://www.seafile.com/help/)

# <a id="wiki-install-service"></a> 安装 Seafile Server 为 Windows 服务 #

## 把 Seafile Server 安装为 Windows 服务的好处 ##

-  所有用户注销后, Seafile Server 仍能继续运行
-  开机时即使没有用户登录， Seafile Server 也会开始运行

## 安装为服务 ##

- 右键点击托盘图标菜单中的 “安装为 Windows 服务”
- 在弹出的确认对话框中选择 “是”

成功安装后，会弹出对话框显示 "已经成功安装 Seafile 服务 "。 

## 验证 Seafile Server 已经成功运行为 Windows 服务 ##

- 注销当前用户
- 从另一台电脑上访问 seahub，如果能成功打开 seahub 网站，说明已经成功

## 安装为服务后，如何启动托盘图标 ##

安装为服务后，下次开机时，Seafile Server 会作为系统服务自动在后台运行。但用户登录后， Seafile Server 的托盘图标不会出现。

要启动托盘图标，和上面一样，双击 “C:\SeafileProgram\seafile-server-1.7.0” 文件夹中的 “run.bat” 文件即可。

## <a id="wiki-uninstall-service"></a> 删除 Seafile Server Windows 服务 ##

如果要从系统中删除 Seafile Server 服务：

- 右键点击托盘图标菜单中的 “卸载 Windows ”
- 在弹出的确认对话框中选择 “是”

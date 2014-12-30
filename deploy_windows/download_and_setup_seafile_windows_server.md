# 下载安装 Windows 版 Seafile 服务器

### 安装 Python 2.7.4 32 位版本 ###

- 下载并安装 [python 2.7.4 32 位版本](http://python.org/ftp/python/2.7.4/python-2.7.4.msi)
- 将 python2.7 的安装路径添加到系统的环境变量中 (PATH 变量)。比如：如果您将 python 2.7.4 安装在`C:\Python27`路径下，那么就将`C:\Python27`添加到环境变量中。

### 下载并解压 Seafile 服务器 ###
- 获取 [Seafile 服务器](http://seafile.com/download/)的最新版本。
- 为 Seafile 服务器程序创建一个新的文件夹，比如`C:\SeafileProgram\`。请记住此文件夹的位置，我们将在以后用到它。
- 将**seafile-server_1.7.0_win32.tar.gz**解压到`C:\SeafileProgram\`目录下。

现在，您的目录结构应该像如下这样：
```
C:\SeafileProgram
         |__ seafile-server-1.7.0
```

## 启动与初始化 ##

### 启动 Seafile 服务器 ###

在`C:\SeafileProgram\seafile-server-1.7.0\`文件夹下，找到**run.bat**文件并双击，以启动 Seafile 服务器。此时，您应该注意到 Seafile 服务器的图标已经出现在您的系统托盘中。

### 选择一个磁盘作为 Seafile 服务器数据的存储位置 ###

现在，您可以在弹出的对话框中选择一个磁盘，以便存储 Seafile 服务器的数据：  

- 请确保选择的磁盘拥有足够的剩余空间
- 点击*确认*按钮后， Seafile 将会在您选择的磁盘下为您创建一个名为`seafile-server`的文件夹。这个文件夹就是  Seafile 服务器的数据文件夹。如果您选择*D*盘，那么数据文件夹为`D:\seafile-server`

### 添加管理员帐号 ###

右击 Seafile 服务器的系统托盘图标， 选择"**添加管理员帐号**"选项。在弹出的对话框中输入您的管理员用户名和密码。

如果操作成功， Seafile 服务器托盘图标处会弹出一个气泡提示您"添加 Seahub 管理员账户成功"

### 配置 Seafile 服务器 ###

初始化服务器之后，还需配置以下选项:

- 右击 Seafile 托盘图标，选择"**打开 seafile-server 文件夹**"选项。您的 seafile-server 数据文件夹将会打开。
- 编辑*ccnet/ccnet.conf*文件。在*ccnet.conf*文件中更改以下两行：
```
NAME = XXXXX
SERVICE_URL = XXX
```

- 将**NAME**的值配置成您的 Seafile 服务器的名字，比如`NAME = my-company-seafile`。这个名字将会在您的 Seafile 客户端上显示。
- 将**SERVICE_URL**的值配置成`http://<您的 IP 地址>:8000`。比如您的 Windows 服务器地址为 *192.168.1.100*， 那么配置成`SERVICE_URL = http://192.168.1.100:8000`


编辑完成后，右击 Seafile 服务器托盘图标，选择"**重启 Seafile Server**"选项以重启 Seafile 服务器。

### 访问Seahub ###

打开您的浏览器，访问 *http://127.0.0.1:8000* 网址。用您的管理员账户登录， 如果成功登录，那么说明您的 Seafile 服务器初始化成功。

## 配置完成 ##

Seafile 服务器的配置到此已经完成。如果您想了解如何使用 Seafile 客户端，请参考 [Seafile 客户端手册](http://www.seafile.com/help/)  

您可能还会想要了解以下信息：  

- [Seafile LDAP配置](../deploy/using_ldap.md)
- [安装 Seafile 为 Windows 服务](install_seafile_server_as_a_windows_service.md)
- [所用端口说明](ports_used_by_seafile_windows_server.md)
- [升级](upgrading_seafile_windows_server.md)
- [个性化配置](../deploy/server_configuration.md)

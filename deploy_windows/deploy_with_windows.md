## 安装与升级

我们测试用的系统是 Windows 2008 server R2 SP1。

- [下载安装 Windows 版 Seafile 服务器](download_and_setup_seafile_windows_server.md)
- [安装 Seafile 为 Windows 服务](install_seafile_server_as_a_windows_service.md)
- [所用端口说明](ports_used_by_seafile_windows_server.md)
- [升级](upgrading_seafile_windows_server.md)

注意：默认情况下，Seafile 需要用到 8000, 8082, 10001, 12001 四个端口。

## 服务器管理

- [垃圾回收不再需要的数据块](../maintain/seafile_gc.md)

## 常见问题

如果您安装 Seafile 服务器失败， 请首先查看`seafserv-applet.log`文件。

### 安装完后，本地网页无法打开

确保您使用的是 Python 2.7.4 32位版本。

### "ERROR: D:/seafile-server\seahub.db not found"

此文件是在 Seafile 初始化过程中创建的。请执行下面两步:

1. 检查您的 Python 以及 Python 环境变量是否设置正确。
2. 将您的 Seafile 服务器包放在一个简短的路径下， 比如`C:\seafile-packages`。

### 创建`seahub.db`文件失败

请使用 Python 2.7.4 32 位版本， 不要使用 Python 3.0 及以上版本。

### 不能通过 Web 端上传或下载文件

请先确保您已经更改了`ccnet.conf`配置文件中的`SERVICE_URL`，且更改正确。

### 浏览器不能获得 css 和 javascript 文件

1. 使用 python 2.7.4 32 位版本。如果您已经安装了 python 的其他版本，请先卸载然后安装 python 2.7.4 版本。重启  Seafile 服务器确认此问题是否依然存在。
2. 将注册表路径`HKEY_CLASSES_ROOT\MIME\Database\Content Type`下的非 ASCII 键删除，然后重试。

### 如何移动 seafile-server 文件夹

假设你的 Seafile 服务器程序位置为 `C:/SeafileProgram`, 数据文件夹位置为 `D:/seafile-server`。现在你希望把数据文件夹从 `D:/seafile-server` 移动到 `E:/seafile-server`

1. 先在托盘菜单里选 **"停止并退出 seafile 服务器"**
2. 把数据文件夹 `D:/seafile-server` 移动到新位置 `E:/seafile-server`
3. 打开 `C:/SeafileProgram` 文件夹下的 `seafserv.ini` 这个文件。这个文件记录了数据文件夹的路径。把这个文件的内容改为 `E:/seafile-server`。
**注意：** 如果你的新位置的路径包含非英文字符，那么请用支持 UTF8 格式的文本编辑器来编辑 `seafserv.ini` 文件，并保存为 UTF8 格式。否则 Seafile 服务器程序可能无法正确读取这个文件的内容。
4. 重新启动 Seafile 服务器。

## 更多信息

想了解更多关于 Seafile 服务器的信息， 请访问 https://github.com/haiwen/seafile/wiki

# 升级

- [小版本升级](#wiki-minor-upgrade)
- [大版本升级](#wiki-major-upgrade)
- [升级 Windows 服务](#wiki-upgrade-service)

**注意**：升级之前，你需要先停止 Seafile 服务器

### 解压新版本服务器

假设升级之前，你的目录结构是：

```
C:/SeafileProgram
             |______ seafile-server-1.7.0/
```

那么，升级的第一步是下载新版本的程序包，并解压到文件夹 ｀C:/SeafileProgram` 下面。

```
C:/SeafileProgram
             |______ seafile-server-1.7.0/
             |______ seafile-server-1.8.0/
```


## <a id="wiki-minor-upgrade"></a>小版本升级 (如从 1.7.0 版本升级到 1.7.1 版本)

现在假定您要将 Seafile 服务器的 Windows 服务从 1.7.0 版本升级到 1.7.1 版本

### 迁移 avatars 文件夹的内容

找到**seafile-server-1.7.0/seahub/media/avatars**目录  

在**avatars/**文件夹中包含着所有Seafile用户的头像。

如果您有一个用户名为`foo@foo.com`的用户，那么在**avatars/**文件夹中，您会发现一个叫作`foo@foo.com`的子文件夹。这个子文件夹包含着用户`foo@foo.com`的头像图片。

将所有像`foo@foo.com`的这种子文件夹拷贝到`seafile-server-1.7.1/seahub/media/avatars`目录下。这样，当您启动新的 1.7.1 版本的 Seafile 服务器时，这些头像可以正确加载。  

## <a id="wiki-major-upgrade"></a>大版本升级 (如从 1.7.0 版本升级到 1.8.0 版本)

现在假定您要将 Seafile 服务器的 Windows 服务从 1.7.x 版本升级到 1.8.y 版本

### 运行数据库升级脚本 ###

- 找到seafile-server-1.8.y/upgrade目录
- 在这个目录下，右击`upgrade_1.7_1.8.bat`文件
- 选择**"以管理员身份运行"**

### 拷贝头像 ###

将在**seafile-server-1.7.0/seahub/media/avatars**目录下的所有子文件夹拷贝到**seafile-server-1.8.0/seahub/media/avatars**目录下


## <a id="wiki-upgrade-service"></a>升级 Windows 服务

   如果您已经将 Seafile 服务器作为 Windows 服务安装，您需要做以下几步： 

   - 运行老版本的 Seafile Windows 服务器，右击托盘图标，在菜单中选择**卸载 Windows 服务**
   - 退出老版本的 Seafile Windows 服务器
   - 启动新版本的 Seafile Windows 服务器，右击托盘图标，在菜单中选择**安装为 Windows 服务**

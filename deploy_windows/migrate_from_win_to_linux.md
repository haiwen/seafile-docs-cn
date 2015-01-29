# 服务器从 Windows 迁移到 Linux

假设你当前已经在使用 Windows 服务器(使用 SQLite 数据库)，现在希望把服务器迁移到 Linux 下。

### 1. 安装 Linux 服务器

第一步你需要安装全新一个 Linux 服务器。同样使用 SQLite 数据库。下面假设你把 Seafile 服务器默认安装在 `/home/haiwen/` 目录下。

### 2. 替换数据和配置文件

#### 删除 Linux 的配置文件和数据

```
rm /home/haiwen/seahub_settings.py
rm /home/haiwen/seahub.db
rm -r /home/haiwen/seafile-data
cp /home/haiwen/ccnet/seafile.ini /home/haiwen/seafile.ini
rm -r /home/haiwen/ccnet
```

其中 seafile.ini 指向 seafile-data 目录所在位置，等会需要用到，这里先拷贝出来。

#### 拷贝配置文件和数据

- 将 Windows 中 **seafile-server** 文件夹下的 `seahub_settings.py` 文件，拷贝到 linux `/home/haiwen/` 目录下

- 将 Windows 中 **seafile-server** 文件夹下的 `seahub.db` 文件，拷贝到 linux `/home/haiwen/` 目录下；

- 将 Windows 中 **seafile-server** 的子文件夹 `seafile-data`，拷贝到 linux `/home/haiwen/` 目录下；

- 将 Windows 中 **seafile-server** 的子文件夹 `ccnet`，拷贝到 linux `/home/haiwen/` 目录下；

- 将  `/home/haiwen/seafile.ini` 拷贝到新 **ccnet** 目录中




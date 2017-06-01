# 集群升级

## 主版本和次版本升级

Seafile 在主版本和次版本中添加了新功能。有可能需要修改一些数据库表，或者需要更新搜素索引。一般来说升级集群包含以下步骤：

1. 更新数据库
2. 更新前端和后端节点上的符号链接以指向最新版本。
3. 更新每个几点上的配置文件。
4. 更新后端节点上的搜索索引。

一般来说，升级集群，您需要：

1. 在一个前端节点上运行升级脚本(例如：./upgrade/upgrade_4_0_4_1.sh)
2. 在其他所有节点上运行次版本升级脚本(./upgrade/minor_upgrade.sh)，以更新符号链接
3. 根据每个版本的文档更新每个节点上的配置文件。
4. 必要的话，在后端节点上删除旧的搜索索引。

## 维护升级

维护升级很简单，您只需要在每一个节点运行脚本 `./upgrade/minor_upgrade.sh` 来更新符号链接。

## 每个版本的具体说明

### 从 5.1 到 6.0

在 6.0 版本中，文件夹下载机制已经更新，这要求在集群部署中，`seafile-data/httptemp` 文件夹必须在一个NFS共享中。您可以使该文件夹作为NFS共享的符号链接。

```
cd /data/haiwen/
ln -s /nfs-share/seafile-httptemp seafile-data/httptemp
```

httptmp文件夹仅包含用于在 Web UI 上下载/上传文件的临时文件。因此NFS共享没有任何可靠性要求，您可以从集群中的任意节点导出它。

### 从 v5.0 到 v5.1

由于 Django 升级到了 1.8，需要对 `COMPRESS_CACHE_BACKEND` 做修改：

```
   -    COMPRESS_CACHE_BACKEND = 'locmem://'
   +    COMPRESS_CACHE_BACKEND = 'django.core.cache.backends.locmem.LocMemCache'
```

### 从 v4.4 到 v5.0

v5.0 引入了一些数据库模式更改并且所有配置文件(ccnet.conf, seafile.conf, seafevents.conf, seahub_settings.py)被移动到了统一的配置文件目录下。

执行以下步骤做升级：

- 在一个前端节点上运行升级脚本以更新数据库。
```
./upgrade/upgrade_4.4_5.0.sh
```
- 然后，在所有的前端和后端节点上运行带有 "SEAFILE_SKIP_DB_UPGRADE" 环境变量的升级脚本：
```
SEAFILE_SKIP_DB_UPGRADE=1 ./upgrade/upgrade_4.4_5.0.sh
```

升级之后，您应该查看一下配置文件已经全都被移动到 `conf/` 目录下了。

```
conf/
  |__ ccnet.conf
  |__ seafile.conf
  |__ seafevent.conf
  |__ seafdav.conf
  |__ seahub_settings.conf
```

### 从 v4.3 到 v4.4

从 v4.3 到 v4.4 没有数据库和搜索索引升级。根据以下步骤做升级：

1. 在前端和后端节点上运行次版本升级脚本。

### 从 v4.2 到 v4.3

从 v4.2 到 v4.3 不包含数据库的变化，但是旧的搜索索引将被删除并重新生成。

一个新的配置项 `COMPRESS_CACHE_BACKEND = 'django.core.cache.backends.locmem.LocMemCache'` 需要被添加到 `seahub_settings.py` 中。

根据以下步骤升级：

1. 在一个前端节点上运行升级脚本来修改 seahub_settings.py

2. 在每一个节点上修改 seahub_settings.py 用新的密钥替换旧密钥，并添加配置项项 `COMPRESS_CACHE_BACKEND`
3. 在前端和后端节点上运行次版本升级脚本。
4. 删除后端节点上的旧的索引(目录 pro_data/search)。
5. 在后端节点上删除旧的 office 文件预览输出目录(/tmp/seafile-office-output)。





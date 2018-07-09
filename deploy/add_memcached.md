# 使用 memcached

安装 Memcached 能够显著提高系统性能。

首先你需要保证 `libmemcached` 库已经安装在你的系统中。要想使用memcached集群，我们要求使用 1.0.16 或者更新的版本。

## 使用单节点memcached

在CentOS 7 上

```
sudo yum install gcc libffi-devel python-devel openssl-devel libmemcached libmemcached-devel
sudo pip install pylibmc
sudo pip install django-pylibmc
```

将以下配置添加到 `seahub_settings.py` 中：

```
CACHES = {
    'default': {
        'BACKEND': 'django_pylibmc.memcached.PyLibMCCache',
        'LOCATION': '127.0.0.1:11211',
    },
    'locmem': {
        'BACKEND': 'django.core.cache.backends.locmem.LocMemCache',
    },
}
COMPRESS_CACHE_BACKEND = 'locmem'

```

最后重启 Seahub 以使更改生效：

    ./seahub.sh restart

如果更改没有生效，请删除`seahub_setting.pyc`缓存文件.

## 使用memcached集群

### 部署memcached集群
如何部署一个memcached集群，请查阅[部署memcached集群](../deploy_pro/mariadb_memcached_cluster.md)

### 将memcached集群添加到seafile中

按照上述方式配置好一个memcached集群之后，您应该有一个可以访问memcached集群的虚拟IP(MEMCACHED_VIP)地址；将该地址连同以下配置信息添加到`seahub_settings.py`中：

```
CACHES = {
    'default': {
        'BACKEND': 'django_pylibmc.memcached.PyLibMCCache',
        'LOCATION': '<MEMCACHED_VIP>:11211',
    },
    'locmem': {
        'BACKEND': 'django.core.cache.backends.locmem.LocMemCache',
    },
}
COMPRESS_CACHE_BACKEND = 'locmem'

```

最后重启 Seahub 以使更改生效：

    ./seahub.sh restart

如果更改没有生效，请删除`seahub_setting.pyc`缓存文件.
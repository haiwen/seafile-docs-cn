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
    }
}

```

最后重启 Seahub 以使更改生效：

    ./seahub.sh restart

如果更改没有生效，请删除`seahub_setting.pyc`缓存文件.

## 使用memcached集群

请查阅[使用memcached集群](../deploy_pro/mariadb_memcached_cluster.md)
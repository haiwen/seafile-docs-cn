# 使用 memcached

安装 Memcached 能够显著提高系统性能。

首先你需要保证 `libmemcached` 库已经安装在你的系统中。要想使用memcached集群，我们要求使用 1.0.18 或者更新的版本。

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

在 Ubuntu 16.04 或者更新的系统上，可以直接使用 apt-get 来安装。

```
sudo apt-get install libmemcached-dev
```

在其他比较老的系统，比如 CentOS 7 或者 Ubuntu 14.04 上，你需要从源代码编译安装这个库。

```
sudo apt-get install build-essential # or sudo yum install gcc gcc-c++ make openssl-devel libffi-devel python-devel
wget https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz
tar zxf libmemcached
cd libmemcached-1.0.18
./configure
make
sudo make install
```

然后安装相关的 Python 库。

```
sudo pip install pylibmc
sudo pip install django-pylibmc
```

使用的是 memcached 集群（即同时使用多台 memcached 服务器），`CACHES` 变量应该设置如下。这个配置使用一致性哈希的方式把 key 分布在多个 memcached 服务器上。更多的信息可以参考 [pylibmc 文档](http://sendapatch.se/projects/pylibmc/behaviors.html) 和 [django-pylibmc 文档](https://github.com/django-pylibmc/django-pylibmc)

```
CACHES = {
    'default': {
        'BACKEND': 'django_pylibmc.memcached.PyLibMCCache',
        'LOCATION': ['192.168.1.134:11211', '192.168.1.135:11211', '192.168.1.136:11211',],
        'OPTIONS': {
            'ketama': True,
            'remove_failed': 1,
            'retry_timeout': 3600,
            'dead_timeout': 3600
        }
    }
}
```

最后重启 Seahub 以使更改生效：

    ./seahub.sh restart

如果更改没有生效，请删除`seahub_setting.pyc`缓存文件.

# 使用 memcached

安装 Memcached 能够显著提高系统性能，首先安装 memcached 和相应的库：

* memcached
* python memcached module (python-memcache or python-memcached)

然后在 **seahub_settings.py** 中加入以下配置信息.

```
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
        'LOCATION': '127.0.0.1:11211',
    }
}
```

最后重启 Seahub 以使更改生效：

    ./seahub.sh restart

如果更改没有生效，请删除`seahub_setting.pyc`缓存文件.

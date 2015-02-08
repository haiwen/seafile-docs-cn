# 使用 memcached

Seahub 将默认在 `/tmp/seahub_cache/` 中缓存文件(avatars, profiles, etc)，但是可以使用 memcached 更改缓存设置。
首先安装 **python-memcached**, 并在 **seahub_settings.py** 中加入以下配置信息.

```
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
        'LOCATION': '127.0.0.1:11211',
    }
}
```
**注意**:

-   请重启 Seahub 以使更改生效.
-   如果更改没有生效，请删除`seahub_setting.pyc`缓存文件.

<!-- -->

    ./seahub.sh restart

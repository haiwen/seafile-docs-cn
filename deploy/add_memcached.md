# 使用 memcached

Seahub 将默认在 `/tmp/seahub_cache/` 中缓存文件(avatars, profiles, etc)，但是可以使用 memcached 更改缓存设置。
首先安装 **python-memcache**, 并在 **seahub_settings.py** 中加入以下配置信息.

```
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
	'LOCATION': '127.0.0.1:11211',
    }
}
```

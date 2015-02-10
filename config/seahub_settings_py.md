# Seahub 配置

### Seahub 下发送邮件提醒

邮件提醒会使某些功能有更好的用户体验, 比如发送邮件提醒用户新消息到达.
请在`seahub_settings.py`中加入以下语句以安装邮件提醒功能
(同时需要对你的邮箱进行设置).

    EMAIL_USE_TLS = False
    EMAIL_HOST = 'smtp.domain.com'        # smpt 服务器
    EMAIL_HOST_USER = 'username@domain.com'    # 用户名和域名
    EMAIL_HOST_PASSWORD = 'password'    # 密码
    EMAIL_PORT = '25'
    DEFAULT_FROM_EMAIL = EMAIL_HOST_USER
    SERVER_EMAIL = EMAIL_HOST_USER

Gmail 用户请加入以下语句:

    EMAIL_USE_TLS = True
    EMAIL_HOST = 'smtp.gmail.com'
    EMAIL_HOST_USER = 'username@gmail.com'
    EMAIL_HOST_PASSWORD = 'password'
    EMAIL_PORT = 587
    DEFAULT_FROM_EMAIL = EMAIL_HOST_USER
    SERVER_EMAIL = EMAIL_HOST_USER

**注意1**:如果邮件功能不能正常使用，请在`logs/seahub.log`日志文件中查看问题原因.
更多信息请见 [Email notification
list](Email notification list "wikilink").

**注意2**:
如果你想在非用户验证情况下使用邮件服务，请将 `EMAIL_HOST_PASSWORD` 置为**blank** (`''`).

### 缓存

Seahub 在默认文件系统(/tmp/seahub\_cache/)中缓存文件(avatars, profiles,
etc) . 你可以通过 Memcached 进行缓存操作
(前提是你已经安装了`python-memcache`模块).

    CACHES = {
        'default': {
            'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
            'LOCATION': '127.0.0.1:11211',
        }
    }

### Seahub 设置

通过修改`seahub_settings.py`文件，可以对 Seahub 网站进行更改.


    # 时区设置，更多请见:
    # http://en.wikipedia.org/wiki/List_of_tz_zones_by_name
    # 部分操作系统下有效.
    # 如果是 Windows 用户，请设置为你的系统时区.
    TIME_ZONE = 'UTC'

    # Seahub 网站 URL. 邮件提醒中会包含此地址
    SITE_BASE = 'http://www.example.com/'

    # 网站名称. 邮件提醒中会包含此名称.
    SITE_NAME = 'example.com'

    # 网站标题
    SITE_TITLE = 'Seafile'

    # 若果不想再根路径上运行 Seahub 网站, 请更改此设置.
    # e.g. setting it to '/seahub/' would run seahub on http://example.com/seahub/.
    SITE_ROOT = '/'

    # 是否使用 pdf.js 在线查看 pdf 文件. 默认为 `True`.
    # NOTE: 1.4版本后可用.
    USE_PDFJS = True

    # 是否在网站页面显示注册按钮，默认为 `False`.
    # NOTE: 1.4版本后可用.
    ENABLE_SIGNUP = False

    # 用户注册后是否立刻激活，默认为 `True`.
    # 如设置为 `False`, 需管理员手动激活.
    # NOTE: 1.8版本后可用
    ACTIVATE_AFTER_REGISTRATION = False

    # 管理员新增用户后是否给用户发送邮件. 默认为 `True`.
    # NOTE: 1.4版本后可用.
    SEND_EMAIL_ON_ADDING_SYSTEM_MEMBER = True

     # 管理员重置用户密码后是否给用户发送邮件. 默认为 `True`.
    # NOTE: 1.4版本后可用.
    SEND_EMAIL_ON_RESETTING_USER_PASSWD = True

    # 隐藏 `Organization` 标签 .
    # 如果你希望你的私人 Seafile 像 https://cloud.seafile.com/ 一样运行， 请设置.
    CLOUD_MODE = True

    # 在线查看文件大小限制，默认为 30M.
    FILE_PREVIEW_MAX_SIZE = 30 * 1024 * 1024

    # cookie的保存时限，(默认为 2 周).
    SESSION_COOKIE_AGE = 60 * 60 * 24 * 7 * 2

    # 是否存储每次请求的会话数据.
    SESSION_SAVE_EVERY_REQUEST = False

    # 浏览器关闭后，是否清空用户会话 cookie
    SESSION_EXPIRE_AT_BROWSER_CLOSE = False
    
    # 是否可以把一个群组设为公开.
    ENABLE_MAKE_GROUP_PUBLIC = False

**注意**:

-   请重启 Seahub 以使更改生效.
-   如果更改没有生效，请删除`seahub_setting.pyc`缓存文件.

<!-- -->

    ./seahub.sh restart


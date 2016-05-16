# Seahub 配置

**Note**: Seafile 服务器 5.0.0 之后，所有配置文件都移动到了统一的 **conf** 目录下。 [了解详情](../deploy/new_directory_layout_5_0_0.md).

### Seahub 下发送邮件提醒

请参看 [发送邮件提醒](sending_email.md)

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

### 用户管理选项

The following options affect user registration, password and session.

```python
# 是非开启用户注册功能. 默认为 `False`.
ENABLE_SIGNUP = False

# 用户注册后是否立刻激活，默认为 `True`.
# 如设置为 `False`, 需管理员手动激活.
ACTIVATE_AFTER_REGISTRATION = False

# 管理员新增用户后是否给用户发送邮件. 默认为 `True`.
SEND_EMAIL_ON_ADDING_SYSTEM_MEMBER = True

# 管理员重置用户密码后是否给用户发送邮件. 默认为 `True`.
SEND_EMAIL_ON_RESETTING_USER_PASSWD = True

# 登录记住天数. 默认 7 天
LOGIN_REMEMBER_DAYS = 7

# 用户输入密码错误次数超过改设置后，显示验证码
LOGIN_ATTEMPT_LIMIT = 3

# 如果登录密码输错次数超过 ``LOGIN_ATTEMPT_LIMIT``，冻结账号
# since 5.1.2
FREEZE_USER_ON_LOGIN_FAILED = True

# 用户密码最少长度
USER_PASSWORD_MIN_LENGTH = 6

# 检查用户密码的复杂性
USER_STRONG_PASSWORD_REQUIRED = False

# 用户密码复杂性:
#    数字, 大写字母, 小写字母, 其他符号
# '3' 表示至少包含以上四种类型中的 3 个
USER_PASSWORD_STRENGTH_LEVEL = 3

# 管理员添加／重置用户后，强制用户修改登录密码
# 在版本 5.1.1 加入, 默认开启
FORCE_PASSWORD_CHANGE = True

# cookie 的保存时限，(默认为 2 周).
SESSION_COOKIE_AGE = 60 * 60 * 24 * 7 * 2

# 浏览器关闭后，是否清空用户会话 cookie
SESSION_EXPIRE_AT_BROWSER_CLOSE = False

# 是否存储每次请求的会话数据. 默认为 `False`
SESSION_SAVE_EVERY_REQUEST = False
```

## 资料库设置


```python
# 加密资料库密码最小长度
REPO_PASSWORD_MIN_LENGTH = 8

# 加密外链密码最小长度
SHARE_LINK_PASSWORD_MIN_LENGTH = 8

# 关闭与任意目录同步的功能
DISABLE_SYNC_WITH_ANY_FOLDER = True

# 允许用户设置资料库的历史保留天数
ENABLE_REPO_HISTORY_SETTING = True
```


## 在线文件查看设置

```python
# 是否使用 pdf.js 来在线查看文件. 默认为 `True`
USE_PDFJS = True

# 在线文件查看最大文件大小，默认为 30M.
# 注意, 在专业版中，seafevents.conf 中有另一个选项
# `max-size` 也控制 doc/ppt/excel/pdf 文件在线查看的最大文件大小。
# 您需要同时把这两个选项调大，如果您要允许 30M 以上 doc/ppt/excel/pdf 的查看。
FILE_PREVIEW_MAX_SIZE = 30 * 1024 * 1024

# 开启 thumbnails 功能
ENABLE_THUMBNAIL = True

# 文件缩略图的存储位置
THUMBNAIL_ROOT = '/haiwen/seahub-data/thumbnail/thumb/'
```

## 其他选项

```python

# 时区设置
# 可用的时区参考:
# http://en.wikipedia.org/wiki/List_of_tz_zones_by_name
TIME_ZONE = 'UTC'

# 系统默认语言设置
# 可用的设置值参考
# http://www.i18nguy.com/unicode/language-identifiers.html
LANGUAGE_CODE = 'en'

# 站点名, 用在 Email 中.
SITE_NAME = 'example.com'

# 站点 Title
SITE_TITLE = 'Seafile'
```

## 专业版选项

```python
# 是否允许管理员通过 Web UI 查看用户文件. 默认为 False
ENABLE_SYS_ADMIN_VIEW_REPO = True

# 允许管理员查看用户非加密资料库。
# 默认为 False
ENABLE_SYS_ADMIN_VIEW_REPO = True

# 未登录用户，外链页面下载／上传需要提供邮箱，做审计。
# Since version 5.1.4
ENABLE_SHARE_LINK_AUDIT = True
```

## 注意

-  请重启 Seahub 以使更改生效.
-  如果更改没有生效，请删除 `seahub_setting.pyc` 缓存文件.
-  如果需要在 `seahub_settings.py` 里添加中文注释，请把 `# -*- coding: utf-8 -*-` 写入文件第一行，并单独为一行。

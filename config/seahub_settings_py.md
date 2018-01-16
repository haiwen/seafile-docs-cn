# Seahub 配置

**Note**: Seafile 服务器 5.0.0 之后，所有配置文件都移动到了统一的 **conf** 目录下。 [了解详情](../deploy/new_directory_layout_5_0_0.md).
**提示**：您还可以通过Web界面修改多说配置项。这些配置项会被保存在数据库表(seahub_db/constance_config)中。他们的优先级高于配置文件中的项目。如果要禁用Web界面设置，可以添加 `ENABLE_SETTINGS_VIA_WEB = False` 到 `seahub_settings.py`。

### Seahub 下发送邮件提醒

请参看 [发送邮件提醒](sending_email.md)

### Memcached

Seahub 默认缓存文件系统上的缓存项(avatars,profiles,等)到(/tmp/seahub_cache)。您可以用Memcached替换。

请参考 ["添加Memcached"](../deploy/add_memcached.md)

### 用户管理选项

以下选项影响用户注册，密码和会话。

```python
# 是否开启用户注册功能. 默认为 `False`.
ENABLE_SIGNUP = False

# 用户注册后是否立刻激活，默认为 `True`.
# 如设置为 `False`, 需管理员手动激活.
ACTIVATE_AFTER_REGISTRATION = False

# 管理员新增用户后是否给用户发送邮件. 默认为 `True`.
SEND_EMAIL_ON_ADDING_SYSTEM_MEMBER = True

# 管理员重置用户密码后是否给用户发送邮件. 默认为 `True`.
SEND_EMAIL_ON_RESETTING_USER_PASSWD = True

# 新用户注册后，给管理员发送通知邮件。默认为 `False`。
NOTIFY_ADMIN_AFTER_REGISTRATION = True

# 登录记住天数. 默认 7 天
LOGIN_REMEMBER_DAYS = 7

# 用户输入密码错误次数超过改设置后，显示验证码
LOGIN_ATTEMPT_LIMIT = 3

# 如果登录密码输错次数超过 ``LOGIN_ATTEMPT_LIMIT``，冻结账号
# since 5.1.2
FREEZE_USER_ON_LOGIN_FAILED = False

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

# 是否开启个人wiki和群组wiki。默认是 `False`
# Since 6.1.0
ENABLE_WIKI = True
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

# 是否允许普通用户创建组织资料库
# Since version 5.0.5
ENABLE_USER_CREATE_ORG_REPO = True
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

# 扩展预览文本文件
# 注意：Since version 6.1.1
TEXT_PREVIEW_EXT = """ac, am, bat, c, cc, cmake, cpp, cs, css, diff, el, h, html,
htm, java, js, json, less, make, org, php, pl, properties, py, rb,
scala, script, sh, sql, txt, text, tex, vi, vim, xhtml, xml, log, csv,
groovy, rst, patch, go"""

# 开启 thumbnails 功能
# 注意: since version 4.0.2
ENABLE_THUMBNAIL = True

# 对于小于以下尺寸的图片，seafile只能生成缩略图
THUMBNAIL_IMAGE_SIZE_LIMIT = 30 # MB

# 文件缩略图的存储位置
THUMBNAIL_ROOT = '/haiwen/seahub-data/thumbnail/thumb/'

# 开启或禁用视频缩略图，ffmpeg 和 moviepy 应该事先被安装
# 详情,请参阅https://manual.seafile.com/deploy/video_thumbnails.html
# NOTE: since version 6.1
ENABLE_VIDEO_THUMBNAIL = False

# 使用第5秒的图片作为缩略图
THUMBNAIL_VIDEO_FRAME_TIME = 5 

# 图片预览的默认大小。放大这个尺寸可以提高预览的质量。
# 注意: since version 6.1.1
THUMBNAIL_SIZE_FOR_ORIGINAL = 1024
```

## Cloud 模式

如果您使用的是一个基于未知用户的seafile，那么您应该启用 Cloud 模式。它禁用了seafile网站上的"组织"标签，以确保用户不能访问用户列表。Cloud 模式提供了一些不错的功能，比如与未注册用户共享内容，并向他们发送邀请。因此，您还需要启用用户注册。通过全局通讯录(从4.2.3版本后)，您可以搜索每个用户账户。所以您可能想要禁用它。

```python
# Enable cloude mode and hide `Organization` tab.
CLOUD_MODE = True

# Disable global address book
ENABLE_GLOBAL_ADDRESSBOOK = False
```

## 外部认证

```python
# Enable authentication with ADFS
# Default is False
# Since 6.0.9
ENABLE_ADFS_LOGIN = True

# Enable authentication wit Kerberos
# Default is False
ENABLE_KRB5_LOGIN = True

# Enable authentication with Shibboleth
# Default is False
ENABLE_SHIBBOLETH_LOGIN = True
```

## 其他选项

```python
# Disable settings via Web interface in system admin->settings
# Default is True
# Since 5.1.3
ENABLE_SETTINGS_VIA_WEB = False

# Choices can be found here:
# http://en.wikipedia.org/wiki/List_of_tz_zones_by_name
# although not all choices may be available on all operating systems.
# If running in a Windows environment this must be set to the same as your
# system time zone.
TIME_ZONE = 'UTC'

# Language code for this installation. All choices can be found here:
# http://www.i18nguy.com/unicode/language-identifiers.html
# Default language for sending emails.
LANGUAGE_CODE = 'en'

# Set this to your website/company's name. This is contained in email notifications and welcome message when user login for the first time.
SITE_NAME = 'Seafile'

# Browser tab's title
SITE_TITLE = 'Private Seafile'

# If you don't want to run seahub website on your site's root path, set this option to your preferred path.
# e.g. setting it to '/seahub/' would run seahub on http://example.com/seahub/.
SITE_ROOT = '/'

# Max number of files when user upload file/folder.
# Since version 6.0.4
MAX_NUMBER_OF_FILES_FOR_FILEUPLOAD = 500

# Control the language that send email. Default to user's current language.
# Since version 6.1.1
SHARE_LINK_EMAIL_LANGUAGE = ''

# Interval for browser requests unread notifications
# Since PRO 6.1.4 or CE 6.1.2
UNREAD_NOTIFICATIONS_REQUEST_INTERVAL = 3 * 60 # seconds

```

## 专业版选项

```python
# Whether to show the used traffic in user's profile popup dialog. Default is True
SHOW_TRAFFIC = True

# Allow administrator to view user's file in UNENCRYPTED libraries
# through Libraries page in System Admin. Default is False.
ENABLE_SYS_ADMIN_VIEW_REPO = True

# For un-login users, providing an email before downloading or uploading on shared link page.
# Since version 5.1.4
ENABLE_SHARE_LINK_AUDIT = True

# Check virus after upload files to shared upload links. Defaults to `False`.
# Since version 6.0
ENABLE_UPLOAD_LINK_VIRUS_CHECK = True

# Enable system admin add T&C, all users need to accept terms before using. Defaults to `False`.
# Since version 6.0
ENABLE_TERMS_AND_CONDITIONS = True

# Enable two factor authentication for accounts. Defaults to `False`.
# Since version 6.0
ENABLE_TWO_FACTOR_AUTH = True

# Enable user select a template when he/she creates library.
# When user select a template, Seafile will create folders releated to the pattern automaticly.
# Since version 6.0
LIBRARY_TEMPLATES = {
    'Technology': ['/Develop/Python', '/Test'],
    'Finance': ['/Current assets', '/Fixed assets/Computer']
}

# Send email to these email addresses when a virus is detected.
# This list can be any valid email address, not necessarily the emails of Seafile user.
# Since version 6.0.8
VIRUS_SCAN_NOTIFY_LIST = ['user_a@seafile.com', 'user_b@seafile.com']
```

## RESTful API

```
# API throttling 相关配置。如果api的返回码为429，可以调高下面的数值。
REST_FRAMEWORK = {
    'DEFAULT_THROTTLE_RATES': {
        'ping': '600/minute',
        'anon': '5/minute',
        'user': '300/minute',
    },
    'UNICODE_JSON': False,
}

# Throtting 白名单，用来忽略特定IP。
# e.g. REST_FRAMEWORK_THROTTING_WHITELIST = ['127.0.0.1', '192.168.1.1']
# 请确保 `REMOTE_ADDR` 头部在 Nginx 配置了，具体参考 https://manual.seafile.com/deploy/deploy_with_nginx.html 
REST_FRAMEWORK_THROTTING_WHITELIST = []
```

## 注意

-  请重启 Seahub 以使更改生效.
-  如果更改没有生效，请删除 `seahub_setting.pyc` 缓存文件.
-  如果需要在 `seahub_settings.py` 里添加中文注释，请把 `# -*- coding: utf-8 -*-` 写入文件第一行，并单独为一行。

```bash
./seahub.sh restart
```

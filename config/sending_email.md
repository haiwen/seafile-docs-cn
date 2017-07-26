# 发送邮件提醒

邮件提醒会使某些功能有更好的用户体验, 比如发送邮件提醒用户新消息到达. 请在`seahub_settings.py`中加入以下语句以开启邮件提醒功能
(同时需要对你的邮箱进行设置).

    EMAIL_USE_TLS = False
    EMAIL_HOST = 'smtp.domain.com'        # smpt 服务器
    EMAIL_HOST_USER = 'username@domain.com'    # 用户名和域名
    EMAIL_HOST_PASSWORD = 'password'    # 密码
    EMAIL_PORT = '25'
    DEFAULT_FROM_EMAIL = EMAIL_HOST_USER
    SERVER_EMAIL = EMAIL_HOST_USER

Gmail 邮箱示例:

    EMAIL_USE_TLS = True
    EMAIL_HOST = 'smtp.gmail.com'
    EMAIL_HOST_USER = 'username@gmail.com'
    EMAIL_HOST_PASSWORD = 'password'
    EMAIL_PORT = '587'
    DEFAULT_FROM_EMAIL = EMAIL_HOST_USER
    SERVER_EMAIL = EMAIL_HOST_USER

QQ 邮箱示例：

    EMAIL_USE_SSL = True
    EMAIL_HOST = 'smtp.exmail.qq.com'
    EMAIL_HOST_USER = 'username@domain.com'
    EMAIL_HOST_PASSWORD = 'password'
    EMAIL_PORT = '465'
    DEFAULT_FROM_EMAIL = EMAIL_HOST_USER
    SERVER_EMAIL = EMAIL_HOST_USER

163 邮箱未测试成功 (有些国内公共邮箱做了限制的，是不能配置成功的.)

126 邮箱:

```
EMAIL_USE_TLS = True
EMAIL_HOST = 'smtp.vip.126.com'
EMAIL_HOST_USER = 'test@vip.126.com'
EMAIL_HOST_PASSWORD = 'password'
EMAIL_PORT = '587'
DEFAULT_FROM_EMAIL = EMAIL_HOST_USER
SERVER_EMAIL = EMAIL_HOST_USER
```

**注意1**:关于如何正确使用465端口和587端口
如果使用587端口，需要建立TLS连接，所以需要配置 `EMAIL_USE_TLS = True`;
如果使用465端口，需要建立SSL连接，所以要替换为 `EMAIL_USE_SSL = True`。
**注意2**:如果邮件功能不能正常使用，请在`logs/seahub.log`日志文件中查看问题原因.
更多信息请见 [Email notification
list](Email notification list "wikilink").

推荐以下调试方法：

- 在管理员界面添加一个用户
- 如果界面上报告邮件发送出错，检查下 logs/seahub.log
- 如果日志中有这样的错误 `seahub.views.sysadmin:1334 user_add [Errno 111] Connection refused`，那么是邮件服务器地址或端口号配置有问题。可以参考 http://stackoverflow.com/questions/5802189/django-errno-111-connection-refused

**注意2**:
如果你想在非用户验证情况下使用邮件服务，请将`EMAIL_HOST_USER`和
`EMAIL_HOST_PASSWORD` 置为**blank** (`''`).
(但是注意一点，这种情况下，邮件将不会记录发件人`From:`信息.)

**注意3**:

-   请重启 Seahub 以使更改生效.
-   如果更改没有生效，请删除`seahub_setting.pyc`缓存文件.

<!-- -->

    ./seahub.sh restart

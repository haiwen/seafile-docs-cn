# 发送邮件提醒

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
如果你想在非用户验证情况下使用邮件服务，请将`EMAIL_HOST_USER`和
`EMAIL_HOST_PASSWORD` 置为**blank** (`''`).
(但是注意一点，这种情况下，邮件将不会记录发件人`From:`信息.)

**注意3**:

-   请重启 Seahub 以使更改生效.
-   如果更改没有生效，请删除`seahub_setting.pyc`缓存文件.

<!-- -->

    ./seahub.sh restart

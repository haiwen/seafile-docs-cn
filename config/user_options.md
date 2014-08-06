# 用户管理

在 `seahub_settings.py` 配置文件中可以个性化用户管理

    # 是否开启用户注册功能，默认为 `False`，不开启.
    ENABLE_SIGNUP = False

    # 用户注册后是否立即激活，默认为 `True`，立即激活。
    # 如果设置为 `False`，需管理员在系统管理界面激活用户。
    ACTIVATE_AFTER_REGISTRATION = False

    # 管理员添加新用户后，是否给此用户发送邮件提醒。默认为 `True`，发送邮件提醒。
    # 此功能只支持 1.4 及之后版本。
    SEND_EMAIL_ON_ADDING_SYSTEM_MEMBER = True

    # 用户登录时，输入几次错误后，显示验证码。
    LOGIN_ATTEMPT_LIMIT = 3

    # 关闭浏览器后，是否保存 Session Cookie，默认为 `False`，不保存。
    SESSION_EXPIRE_AT_BROWSER_CLOSE = False



# 两步认证

从6.0版本开始，增加了两步身份认证以增强账号安全。

有两种方法启用这个功能：

* 系统管理员可以在系统设置页面的“密码”部分勾选复选框，或者

* 只添加 `ENABLE_TOW_FACTOR_AUTH = True` 到 `seahub_settings.py` 并且重启服务。

之后，用户个人资料页面将会出现“两步认证”部分。

用户可以在智能手机上使用Google 身份验证器扫描二维码。

## Twilio 集成

我们也可以通过使用Twilio服务支持短信方式。

首先你需要安装 Twilio python库：

```
sudo pip install twilio
```

然后添加以下配置项到 `seahub_settings.py`：

```
TWO_FACTOR_SMS_GATEWAY = 'seahub_extra.two_factor.gateways.twilio.gateway.Twilio'
TWILIO_ACCOUNT_SID = '<your-account-sid>'
TWILIO_AUTH_TOKEN = '<your-auth-token>'
TWILIO_CALLER_ID = '<your-caller-id>'
EXTRA_MIDDLEWARE_CLASSES = (
    'seahub_extra.two_factor.gateways.twilio.middleware.ThreadLocals',
)
```

**注意**：如果你已经定义了 `EXTRA_MIDDLEWARE_CLASSES`,请使用 `EXTRA_MIDDLEWARE_CLASSES += (` 替换掉 `EXTRA_MIDDLEWARE_CLASSES = (` 

然后重启，当用户为其帐户启用两步认证时，将会显示“短信”方法。
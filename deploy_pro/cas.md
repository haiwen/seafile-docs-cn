# 配置 CAS 登陆

自从 6.3.0 专业版开始，Seafile 支持 CAS 单点登录。您可以通过以下流程完成对接 CAS 的配置。

## 前提条件

此处我们认为您的网络环境中已经部署了可用的 CAS 服务。并假设该服务的访问地址为：`https://<CAS-SERVER-IP>:<PORT>/cas/`。
并且您应该正在使用 Seafile 专业版 6.3.0 以上的版本。

## 配置 seahub_settings.py

- 在 `conf/seahub_settings.py` 中添加以下配置信息：

```
ENABLE_CAS = True
CAS_SERVER_URL = 'https://<CAS-SERVER-IP>:<PORT>/cas/'
CAS_LOGOUT_COMPLETELY = True
# 如果您的 CAS 服务使用的是自签名证书，请将下边一行的配置信息取消注释。
#CAS_SERVER_CERT_VERIFY = False
```

- 重启 seahub 进程，生效以上配置信息：

```
./seahub.sh restart
```

现在您应该可以使用 CAS 单点登陆了。接下来访问 Seafile 时，在登陆菜单栏中的左下角将会出现一个 “单点登陆”，点击该处即可跳转到 CAS 的登陆界面。
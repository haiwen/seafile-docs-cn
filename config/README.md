# 服务器配置

## 配置文件

**注意**: Seafile 服务器 5.0.0 之后，所有配置文件都移动到了统一的 **conf** 目录下，
而且大部分配置选项可以通过 Web 界面 (Admin Panel -> Settings) 来配置，不需要直接修改配置文件。
通过 Web 界面做的配置会保存在数据库中，并且优先级比通过配置文件做的配置的优先级高。

开源版中包括以下三个配置文件:

- [conf/ccnet.conf](ccnet-conf.md): 用来配置网络和 LDAP/AD 连接
- [conf/seafile.conf](seafile-conf.md): 用来配置 Seafile
- [conf/seahub_settings.py](seahub_settings_py.md): 用来配置 Seahub
- [conf/seafevents.conf](seafevents-conf.md):主要用来配置搜索和文件预览

专业版中还包含以下一个配置文件:

- `conf/seafevents.conf`: 包含搜索与文件预览的配置


## 配置项

邮件:

* [发送邮件提醒](sending_email.md)
* [个性化邮件提醒](customize_email_notifications.md)

用户管理：

* 用户管理：请查阅 [seahub_settings.py](seahub_settings_py.md)

用户存储容量和上传/下载文件大小限制：

* 存储容量与文件上传/下载大小限制:请查阅 [seafile.conf](seafile-conf.md)

## 自定义 Web

* [自定义 Web](seahub_customization.md)
* [桌面客户端定制](desktop_customization.md)
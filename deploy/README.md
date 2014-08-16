# Linux 下部署 Seafile 服务器

此文档用来说明如何使用预编译安装包来部署 Seafile 服务器.

### 家庭/个人 环境下部署 Seafile 服务器

* [部署 Seafile 服务器（使用 SQLite）](using_sqlite.md)

### 生产/企业 环境下部署 Seafile 服务器

企业环境下我们建议使用 MySQL 数据库，并将 Seafile 部署在 Nginx 或者 Apache 上，如果对于 Nginx 和 Apache 都不是很熟悉的话，我们建议使用 Nginx，相对于 Apache 来说，Nginx 使用起来比较简单。

基础功能:

* [部署 Seafile 服务器（使用 MySQL）](using_mysql.md)
* [Nginx 下配置 Seahub](deploy_with_nginx.md)
* [Nginx 下启用 Https](https_with_nginx.md)
* [Apache 下配置 Seahub](deploy_with_apache.md)
* [Apache 下启用 Https](https_with_apache.md)

高级功能:

* [Seafile LDAP 配置](using_ldap.md)
* [开机启动 Seafile](start_Seafile_at_system_bootup.md)
* [防火墙设置](using_firewall.md)
* [Logrotate 管理系统日志](using_logrotate.md)
* [使用 Memcached](add_memcached.md)

其他部署事项

* [使用 NAT](deploy_Seafile_behind_NAT.md)
* [非根域名下部署 Seahub](deploy_Seahub_at_Non-root_domain.md)
* [从 SQLite 迁移至 MySQL](migrate_from_sqlite_to_mysql.md)

更多配置选项（比如开启用户注册功能），请查看 [服务器个性化配置](../config/README.md)。

**注意** 如果在部署 Seafile 服务器是遇到困难

1. 阅读 [Seafile 组件](../overview/components.md) 以了解 Seafile 的运行原理。
2. [安装常见问题](common_problems_for_setting_up_server.md)。
3. 通过 [论坛](http://bbs.seafile.com/) 或者 Seafile 服务器管理员 QQ 交流群: 315229116 寻求帮助。

## 升级 Seafile 服务器

* [升级](upgrade.md)

## 个人打包 Seafile 服务器

如果想要自己打包 Seafile 服务器（安装在自己喜欢的 Linux 系统中）, 请务必使用 tags:

* 当 Seafile 客户端发行新版本时，比如 `v3.0.1`， 我们会将 `v3.0.1` 标签打在 **ccnet**, **seafile** 和 **seafile-client** 上。
* 同样，当 Seafile 服务器发行新版本时，比如 `v3.0.1`， 我们会将 `v3.0.1` 标签打在 **ccnet**, **seafile** 和 **seahub** 上。
* 对于 **libsearpc**，会一直使用 `v3.0-latest` 标签。

**注意**: 每个项目的版本号和 tag 名，不存在必然联系。

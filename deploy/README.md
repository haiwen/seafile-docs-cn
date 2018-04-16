# Linux 下部署 Seafile 服务器

此文档用来说明如何使用预编译安装包来部署 Seafile 服务器.

### 使用安装脚本在 Ubuntu 16.04 或 CentOS 7 上快速安装

我们准备了一个安装脚本帮助您在 Ubuntu 16.04 或 CentOS 7 快速的安装部署 Seafile 服务(配置好 MariaDB, Memcached, WebDAV, Ngnix 和开机自动启动脚本)： https://github.com/haiwen/seafile-server-installer-cn

在此基础上，您可以继续根据下面的文档来配置邮箱发送等服务。  

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
* [使用 Memcached](add_memcached.md)

高级功能:

* [开机启动 Seafile](start_Seafile_at_system_bootup.md)
* [防火墙设置](using_firewall.md)
* [Logrotate 管理系统日志](using_logrotate.md)


其他部署事项

* [使用 NAT](deploy_Seafile_behind_NAT.md)
* [非根域名下部署 Seahub](deploy_Seahub_at_Non-root_domain.md)
* [从 SQLite 迁移至 MySQL](migrate_from_sqlite_to_mysql.md)

更多配置选项（比如开启用户注册功能），请查看 [服务器个性化配置](../config/README.md)。

**注意** 如果在部署 Seafile 服务器时遇到困难

1. 阅读 [Seafile 组件](../overview/components.md) 以了解 Seafile 的运行原理。
2. [安装常见问题](common_problems_for_setting_up_server.md)。
3. 通过 Seafile QQ 交流群或者 Seafile 论坛寻求帮助。

## 升级 Seafile 服务器

* [升级](upgrade.md)

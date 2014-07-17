#Seafile
##这篇帮助文档介绍管理员如何通过 Seahub 网站来管理 Seafile 服务器上的用户和同步目录。

## 用户管理及同步目录管理

在 Seahub 网站初始化配置的时候，你已经设置了一个管理员帐号。你以管理员身份登录 Seahub 网站之后，可以在“用户管理”和“目录管理”两个标签下面，添加/删除用户，查看/删除同步目录。

## 重置用户密码

管理员可以到“系统管理”页面重置用户密码。

在私有部署模式下，默认的配置不支持用户通过邮件来重置自己的密码。如果你想要启用这个功能，请先[[Seafile 服务器配置详细说明|配置邮件通知]]。

## 忘记了 seahub 管理员的 帐号/密码 怎么办 ?

* Seafile server 1.4 之前的版本: 可以在 seafile-server 目录下执行 <code>create-seahub-admin.sh</code> 脚本，该脚本会引导你创建新的管理员帐号和密码
[[images/create-seahub-admin.png|运行create-seahub-admin.sh时的截图]]
* Seafile server 1.4 及以后的版本：  可以在 seafile-server 目录下执行 <code>reset-admin.sh</code> 脚本，该脚本会引导你创建新的管理员帐号和密码


# 个性化邮件提醒

**注意:** 不同版本之间有所差异，本文档基于 2.0.1 版本编写。请按提示，自行更改相应代码，以实现个性化功能。重启 Seahub 以使更改生效。

## 用户重置密码 ##

**Subject**

seahub/seahub/auth/forms.py line:103

**Body**

seahub/seahub/templates/registration/password_reset_email.html

注意：你可以复制 password_reset_email.html 到 `seahub-data/custom/templates/registration/password_reset_email.html` 并且修改这个新的文件。通过这个方法，升级之后将维护个性化定制。 

## 管理员添加新用户 ##

**Subject**

seahub/seahub/views/sysadmin.py line:424

**Body**

seahub/seahub/templates/sysadmin/user_add_email.html

注意：你可以复制 user_add_email.html 到 `seahub-data/custom/templates/sysadmin/user_add_email.html` 并且修改这个新的文件。通过这个方法，升级之后将维护个性化定制。

## 管理员重置用户密码 ##

**Subject**

seahub/seahub/views/sysadmin.py line:368

**Body**

seahub/seahub/templates/sysadmin/user_reset_email.html

注意：你可以复制 user_reset_email.html 到 `seahub-data/custom/templates/sysadmin/user_reset_email.html` 并且修改这个新的文件。通过这个方法，升级之后将维护个性化定制。

## 用户发送文件/文件夹外链 ##

**Subject**

seahub/seahub/share/views.py line:668

**Body**

seahub/seahub/templates/shared_link_email.html


# 角色和权限

从 6.2.2 开始，您可以为管理员添加/修改一个角色以及其所拥有的权限。
Seafile 目前有四个内置的管理员角色：

 1. default_admin, 拥有所有权限。

 1. system_admin, 只能查看系统信息和系统配置。

 1. daily_admin, 只能查看系统信息、统计信息、用户日志以及管理资料库/用户/群组。

 1. audit_admin, 只能查看系统信息和管理员日志。

默认所有的管理员账号都拥有 `default_admin` 角色以及所有权限。如果您将一个管理员账号设置为其他管理员角色，那么该管理员账号将 **只拥有配置文件中为其开启(配置项设置为`True`)的权限**。

目前 Seafile 支持八种管理员权限，与普通用户角色配置相同，您可以在`seahub_settings.py`中添加以下配置项。

```
ENABLED_ADMIN_ROLE_PERMISSIONS = {
    'system_admin': {
        'can_view_system_info': True,
        'can_config_system': True,
    },
    'daily_admin': {
        'can_view_system_info': True,
        'can_view_statistic': True,
        'can_manage_library': True,
        'can_manage_user': True,
        'can_manage_group': True,
        'can_view_user_log': True,
    },
    'audit_admin': {
        'can_view_system_info': True,
        'can_view_admin_log': True,
    },
    'custom_admin': {
        'can_view_system_info': True,
        'can_config_system': True,
        'can_view_statistic': True,
        'can_manage_library': True,
        'can_manage_user': True,
        'can_manage_group': True,
        'can_view_user_log': True,
        'can_view_admin_log': True,
    },
}
```

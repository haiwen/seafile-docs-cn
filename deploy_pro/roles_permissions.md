# 用户角色与权限

6.0 版本开始，管理员可以在用户管理界面为一个用户赋予一个角色，不同角色可以配置不同权限，目前支持 10 种权限。

Seafile 内建两种用户角色：`default` 和 `guest`（访客用户）。

`default` 用户实际就是一个普通 Seafile 用户，对应默认权限列表如下：

```
'default': {
    'can_add_repo': True,
    'can_add_group': True,
    'can_view_org': True,
    'can_use_global_address_book': True,
    'can_generate_share_link': True,
    'can_generate_upload_link': True,
    'can_invite_guest': False,
    'can_connect_with_android_clients': True,
    'can_connect_with_ios_clients': True,
    'can_connect_with_desktop_clients': True,
},
```

`guest` 用户对应默认权限列表如下：

```
'guest': {
    'can_add_repo': False,
    'can_add_group': False,
    'can_view_org': False,
    'can_use_global_address_book': False,
    'can_generate_share_link': False,
    'can_generate_upload_link': False,
    'can_invite_guest': False,
    'can_connect_with_android_clients': False,
    'can_connect_with_ios_clients': False,
    'can_connect_with_desktop_clients': False,
},
```

## 编辑内建用户角色的权限

通过在 `seahub_settings.py` 里加入相应配置，可以更改内建用户角色的默认权限。

比如你想让 `default` 用户可以邀请 `guest`，让 `guest` 用户可以查看公共资料库（而不改变其他权限），在 `seahub_settings.py` 里加入以下配置即可：

```
ENABLED_ROLE_PERMISSIONS = {
    'default': {
        'can_add_repo': True,
        'can_add_group': True,
        'can_view_org': True,
        'can_use_global_address_book': True,
        'can_generate_share_link': True,
        'can_generate_upload_link': True,
        'can_invite_guest': True,
        'can_connect_with_android_clients': True,
        'can_connect_with_ios_clients': True,
        'can_connect_with_desktop_clients': True,
    },
    'guest': {
        'can_add_repo': False,
        'can_add_group': False,
        'can_view_org': True,
        'can_use_global_address_book': False,
        'can_generate_share_link': False,
        'can_generate_upload_link': False,
        'can_invite_guest': False,
        'can_connect_with_android_clients': False,
        'can_connect_with_ios_clients': False,
        'can_connect_with_desktop_clients': False,
    }
}
```

注意对比 `default` 用户的 `can_invite_guest` 设置，和 `guest` 用户的 `can_view_org` 设置。

### 关于邀请访客功能

如果想要使用 *邀请访客* 功能，除了赋予用户 `can_invite_guest` 权限外，还需在 `seahub_settings.py` 中加入以下配置：

```
ENABLE_GUEST_INVITATION = True
```

重启 Seafile 后， 可以邀请访客的用户，页面左侧会多出 *邀请* 导航标签。用户提供被邀请人的邮箱后，被邀请人会收到邀请链接。

## 自定义用户角色

如果你想增加一个用户角色，比如 `employee` 角色，而此角色 *不具有 “邀请访客”、“生成上传/下载外链”* 权限，在 `seahub_settings.py` 中加入以下配置:

```
ENABLED_ROLE_PERMISSIONS = {
    'default': {
        'can_add_repo': True,
        'can_add_group': True,
        'can_view_org': True,
        'can_use_global_address_book': True,
        'can_generate_share_link': True,
        'can_generate_upload_link': True,
        'can_invite_guest': False,
        'can_connect_with_android_clients': True,
        'can_connect_with_ios_clients': True,
        'can_connect_with_desktop_clients': True,
    },
    'guest': {
        'can_add_repo': False,
        'can_add_group': False,
        'can_view_org': False,
        'can_use_global_address_book': False,
        'can_generate_share_link': False,
        'can_generate_upload_link': False,
        'can_invite_guest': False,
        'can_connect_with_android_clients': False,
        'can_connect_with_ios_clients': False,
        'can_connect_with_desktop_clients': False,
    },
    'employee': {
        'can_add_repo': True,
        'can_add_group': True,
        'can_view_org': True,
        'can_use_global_address_book': True,
        'can_generate_share_link': False,
        'can_generate_upload_link': False,
        'can_invite_guest': False,
        'can_connect_with_android_clients': True,
        'can_connect_with_ios_clients': True,
        'can_connect_with_desktop_clients': True,
    },
}
```

注意 `employee` 用户的 `can_invite_guest`、`can_generate_share_link`、`can_generate_upload_link` 设置。

# 多机构用户管理

从5.1版本开始，您可以添加不同的机构到Seafile中，并且可以分配用户到指定的机构中。每一个机构中都有一个或多个机构管理员。这个功能是为了简化当多个组织(大学)共享一个Seafile实例时的用户管理机制。与多租户不同，用户并不是孤立的，来自一个机构的用户可以与另一个机构共享文件。

## 开启该功能

在 `seahub_settings.py` 中，添加 `MULTI_INSTITUTION = True` 来开启多机构功能。并且添加以下配置项：

```
EXTRA_MIDDLEWARE_CLASSES += (
    'seahub.institutions.middleware.InstitutionMiddleware',
)
```

或者 `EXTRA_MIDDLEWARE_CLASSES` 事先没有定义过时：

```
EXTRA_MIDDLEWARE_CLASSES = (
    'seahub.institutions.middleware.InstitutionMiddleware',
)
```

## 添加机构和机构管理员

重启Seafile之后，系统管理员可以通过在管理面板中添加机构名来添加机构。系统管理员也可以点击进入某个机构，并将列出该机构中的所有用户。

## 指派用户到机构中

如果您正在使用 Shibboleth，您可以映射一个 Shibboleth的属性到机构中去，例如，以下配置将一个组织属性映射到机构中去：

```
SHIBBOLETH_ATTRIBUTE_MAP = {
    "givenname": (False, "givenname"),
    "sn": (False, "surname"),
    "mail": (False, "contact_email"),
    "organization": (False, "institution"),
}
```
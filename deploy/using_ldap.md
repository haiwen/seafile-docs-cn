# Seafile LDAP 和 Active Directory 配置

LDAP (Light-weight Directory Access Protocol) 是企业广泛部署的用户信息管理服务器，微软的活动目录服务器（Active Directory）完全兼容 LDAP。这个文档假定您已经了解了 LDAP 相关的知识和术语。

在目前的 Seahub，只支持 email 格式的用户名登陆，所以，使用 UNIX 和 Windows Domain 用户名并不能登录到 Seahub，后续版本中会对此进行改进.

Seafile 会通过数据库和 LDAP 来搜寻用户. 默认首先搜寻 LDAP. （请注意，在安装时设置的 Seafile 管理员账户，会始终保存在 SQLite/MySQL 数据库中。）

## LDAP 用户管理

Seafile 如下管理来自 LDAP 中的用户：

* 当一个 LDAP 用户第一次登录的时候，他会被自动导入到 Seafile 的数据库中（ccnet 数据库的 LDAPUser 表）。
* 系统管理员可以对导入的 LDAP 用户进行管理，包括禁用、删除、设置为系统管理员等。
* 对于企业版，系统只会把已经导入系统的 LDAP 用户计算到当前用户数量中。因此企业版客户可以购买比他们 LDAP/AD 服务器中用户数量少的 license。

在 Seafile 企业版 4.2 及以上的版本，我们加入了从 LDAP/AD 服务器定期同步用户到 Seafile 数据库的功能。这项功能有以下好处：

* 除了定期把用户从 LDAP 中导入到数据库，还能把诸如用户的全名、部门名称等额外信息导入。
* 自动检测用户已经从 LDAP 服务器上删除。从 LDAP 服务器删除的用户会在 Seafile 中禁用。

关于这项功能的更详细信息请参考 [这个文档](http://manual.seafile.com/deploy/ldap_user_sync.html)。

## LINUX 下连接LDAP/AD

要通过 LDAP 来认证用户，您需要把下面的配置加入 ccnet.conf。需要注意的是下面的配置只是例子，您需要根据自己的实际情况来进行修改。

    [LDAP]
    HOST = ldap://ldap.example.com
    BASE = ou=users,dc=example,dc=com
    USER_DN = cn=seafileadmin,dc=example,dc=com
    PASSWORD = secret
    LOGIN_ATTR = mail

各个配置选项的含义如下：

* HOST: LDAP 服务器的地址 URL。如果您的 LDAP 服务器监听在非标准端口上，您也可以在 URL 里面包含端口号，如 ldap://ldap.example.com:389。
* BASE: 在 LDAP 服务器的组织架构中，用于查询用户的根节点的唯一名称（Distingushed Name，简称 DN）。这个节点下面的所有用户都可以访问 Seafile。
* USER_DN: 用于查询 LDAP 服务器中信息的用户的 DN。这个用户应该有足够的权限访问 BASE 以下的所有信息。通常建议使用 LDAP/AD 的管理员用户。
* PASSWORD: USER_DN 对应的用户的密码。
* LOGIN_ATTR: 用作 Seafile 中用户登录 ID 的 LDAP 属性。在 LDAP 里面，每个用户都关联了很多属性。默认我们使用 'mail' 作为登录 ID。

如果您使用的是 AD，以下信息将有助于您配置：

* 要确定您的 BASE 属性，您首先需要打开域管理器的图形界面，并浏览您的组织架构。
    * 如果您想要让系统中所有用户都能够访问 Seafile，您可以用 'cn=users,dc=yourdomain,dc=com' 作为 BASE 选项（需要替换成你们的域名）。
    * 如果您只想要某个部门的人能访问，您可以把范围限定在某个 OU （Organization Unit）中。您可以使用 `dsquery` 命令行工具来查找相应 OU 的 DN。比如，如果 OU 的名字是 'staffs'，您可以运行 `dsquery ou -name staff`。更多的信息可以参考[这里](https://technet.microsoft.com/en-us/library/cc770509.aspx)。
* AD 支持使用 'user@domain.com' 格式的用户名作为 `USER_DN`。比如您可以使用 administrator@example.com 作为 `USER_DN`。有些时候 AD 不能正确识别这种格式。此时您可以使用 `dsquery` 来查找用户的 DN。比如，假设用户名是 'seafileuser'，运行 `dsquery user -name seafileuser` 来找到该用户的 DN。更多的信息可以参考[这里](https://technet.microsoft.com/en-us/library/cc725702.aspx)。

针对 AD 的配置例子：

    [LDAP]
    HOST = ldap://192.168.1.123/
    BASE = cn=users,dc=example,dc=com
    USER_DN = administrator@example.local
    PASSWORD = secret
    LOGIN_ATTR = mail

针对 OpenLDAP 或者其他 LDAP 服务器的配置例子：

    [LDAP]
    HOST = ldap://192.168.1.123/
    BASE = ou=users,dc=example,dc=com
    USER_DN = cn=admin,dc=example,dc=com
    PASSWORD = secret
    LOGIN_ATTR = mail

如果您使用 AD 但是没有给用户设置邮件地址（mail 属性），您也可以使用以下的配置：

    [LDAP]
    HOST = ldap://192.168.1.123/
    BASE = cn=users,dc=example,dc=com
    USER_DN = administrator@example.local
    PASSWORD = secret
    LOGIN_ATTR = userPrincipalName

`userPrincipalName` 是一个 AD 支持的特殊属性。它具有 `username@domain-name` 的格式，其中 `username` 是 Windows 用户的登录名。使用上述配置之后，用户可以用 `username@domain-name` 作为用户名登录 Seafile。注意这个登录名并不是真实的邮件地址，因此 Seafile 的邮件通知功能可能不能工作。

注意：

1. 如果配置项包含中文，需要确保配置文件使用 UTF8 编码保存。
2. 这个文档中描述的配置方法经过很多人在不同的 LDAP/AD 环境下试过，肯定是能工作的。

## 通过 Windows 服务器连接到 LDAP/AD

Windows 下的配置语法与 Linux 下的有些不同. **你不需要增加`ldap:// prefix to the HOST field`.**

要通过 LDAP 来认证用户，您需要把下面的配置加入 ccnet.conf。需要注意的是下面的配置只是例子，您需要根据自己的实际情况来进行修改。

    [LDAP]
    HOST = ldap.example.com
    BASE = ou=users,dc=example,dc=com
    USER_DN = cn=seafileadmin,dc=example,dc=com
    PASSWORD = secret
    LOGIN_ATTR = mail

各个配置选项的含义如下：

* HOST: LDAP 服务器的地址 URL。如果您的 LDAP 服务器监听在非标准端口上，您也可以在 URL 里面包含端口号，如 ldap://ldap.example.com:389。
* BASE: 在 LDAP 服务器的组织架构中，用于查询用户的根节点的唯一名称（Distingushed Name，简称 DN）。这个节点下面的所有用户都可以访问 Seafile。
* USER_DN: 用于查询 LDAP 服务器中信息的用户的 DN。这个用户应该有足够的权限访问 BASE 以下的所有信息。通常建议使用 LDAP/AD 的管理员用户。
* PASSWORD: USER_DN 对应的用户的密码。
* LOGIN_ATTR: 用作 Seafile 中用户登录 ID 的 LDAP 属性。在 LDAP 里面，每个用户都关联了很多属性。默认我们使用 'mail' 作为登录 ID。

如果您使用的是 AD，以下信息将有助于您配置：

* 要确定您的 BASE 属性，您首先需要打开域管理器的图形界面，并浏览您的组织架构。
    * 如果您想要让系统中所有用户都能够访问 Seafile，您可以用 'cn=users,dc=yourdomain,dc=com' 作为 BASE 选项（需要替换成你们的域名）。
    * 如果您只想要某个部门的人能访问，您可以把范围限定在某个 OU （Organization Unit）中。您可以使用 `dsquery` 命令行工具来查找相应 OU 的 DN。比如，如果 OU 的名字是 'staffs'，您可以运行 `dsquery ou -name staff`。更多的信息可以参考[这里](https://technet.microsoft.com/en-us/library/cc770509.aspx)。
* AD 支持使用 'user@domain.com' 格式的用户名作为 `USER_DN`。比如您可以使用 administrator@example.com 作为 `USER_DN`。有些时候 AD 不能正确识别这种格式。此时您可以使用 `dsquery` 来查找用户的 DN。比如，假设用户名是 'seafileuser'，运行 `dsquery user -name seafileuser` 来找到该用户的 DN。更多的信息可以参考[这里](https://technet.microsoft.com/en-us/library/cc725702.aspx)。

针对 AD 的配置例子：

    [LDAP]
    HOST = 192.168.1.123
    BASE = cn=users,dc=example,dc=com
    USER_DN = administrator@example.local
    PASSWORD = secret
    LOGIN_ATTR = mail

针对 OpenLDAP 或者其他 LDAP 服务器的配置例子：

    [LDAP]
    HOST = 192.168.1.123
    BASE = ou=users,dc=example,dc=com
    USER_DN = cn=admin,dc=example,dc=com
    PASSWORD = secret
    LOGIN_ATTR = mail

如果您使用 AD 但是没有给用户设置邮件地址（mail 属性），您也可以使用以下的配置：

    [LDAP]
    HOST = 192.168.1.123
    BASE = cn=users,dc=example,dc=com
    USER_DN = administrator@example.local
    PASSWORD = secret
    LOGIN_ATTR = userPrincipalName

`userPrincipalName` 是一个 AD 支持的特殊属性。它具有 `username@domain-name` 的格式，其中 `username` 是 Windows 用户的登录名。使用上述配置之后，用户可以用 `username@domain-name` 作为用户名登录 Seafile。注意这个登录名并不是真实的邮件地址，因此 Seafile 的邮件通知功能可能不能工作。

## 使用多个 BASE DN 以及用户过滤选项

当您想把公司中多个 OU 加入 Seafile 中时，您可以使用在配置中指定多个 BASE DN。您可以在"BASE"配置中指定一个 DN 的列表，标识名由";"分开, 比如： `cn=developers,dc=example,dc=com;cn=marketing,dc=example,dc=com`

当你的公司组织庞大，但是只有一小部分人使用 Seafile 的时候，搜索过滤器（Search filter）会很有用处. 过滤器可以通过修改"FILTER"配置来实现，例如，在 LDAP 配置中增加以下语句:

```
FILTER = memberOf=CN=group,CN=developers,DC=example,DC=com
```

请注意上面的示例只是象征性的简介. `memberOf`只有在活动目录(Active Directory)中才适用.

这里是另一个示例:

```
FILTER = &(!(UserAccountControl:1.2.840.113556.1.4.803:=2))
```

## 把 Seafile 用户限定在 AD 的一个组中

您可以利用用户过滤器选项来只允许 AD 某个组中的用户使用 Seafile。

1. 首先，您需要找到这个组的 DN。我们再次使用 `dsquery` 命令。比如，如果组的名字是 'seafilegroup'，那么您可以运行 `dsquery group -name seafilegroup`。
2. 然后您可以把一下配置加入 ccnet.conf 的 LDAP 配置中：

```
FILTER = memberOf={dsquery 命令的输出}
```

## 企业版提供的高级 LDAP 功能

### 使用结果分页扩展（paged results extension）

LDAP 协议 v3 支持一个称为 "paged results" 的扩展功能。当您在 LDAP 中有大量用户的时候，这个选项能够大大提高列出用户的速度。而且，AD 限制了单次请求中返回的用户条目数量，您需要启用这个选项才能避免查询错误。

在 Seafile 企业版中，在 LDAP 配置中加入以下设置：

```
USE_PAGED_RESULT = true
```

### 从 LDAP 中导入群组

请参考[这个文档](http://manual.seafile.com/deploy/ldap_group_sync.html)。

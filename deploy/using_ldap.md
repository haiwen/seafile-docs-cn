# Seafile LDAP配置

在目前的 Seahub，只支持 email 格式的用户名登陆，所以，使用 UNIX 和 Windows Domain 用户名并不能登录到 Seahub，后续版本中会对此进行改进.

Seafile 会通过数据库和 LDAP 来搜寻用户. 默认首先搜寻 LDAP. （请注意，在安装时设置的 Seafile 管理员账户，会始终保存在 SQLite/MySQL 数据库中。）

## LINUX 下连接LDAP/AD

请在`ccnet.conf`下增加以下语句，以使用 LDAP 进行用户认证。

    [LDAP]
    # 主机的 LDAP URL, 支持ldap://, ldaps:// and ldapi:// 
    # 为了使用 TLS, 请对 LDAP 服务器进行配置使其能够监听 LDAPS
    # 端口， 并在这里指明 ldaps:// 地址.
    HOST = ldap://ldap.example.com
    # 设置所有用户均可访问 base DN
    BASE = ou=users,dc=example,dc=com
    # 管理员用户 DN 绑定 LDAP. 如未设定，使用默认设置.
    USER_DN = cn=seafileadmin,dc=example,dc=com
    # 管理员用户的 DN 密码
    PASSWORD = secret
    # 用户登陆ID, 默认使用邮件格式.
    LOGIN_ATTR = mail

LDAP 配置示例:

    [LDAP]
    HOST = ldap://192.168.1.123/
    BASE = ou=users,dc=example,dc=com
    USER_DN = cn=admin,dc=example,dc=com
    PASSWORD = secret
    LOGIN_ATTR = mail

活动目录(Active Directory)配置示例:

    [LDAP]
    HOST = ldap://192.168.1.123/
    BASE = cn=users,dc=example,dc=com
    USER_DN = cn=admin,cn=users,dc=example,dc=com # or use admin@example.local etc
    PASSWORD = secret
    LOGIN_ATTR = mail

如果你使用活动目录(Active Directory)但并没有向用户提供 Email 地址，可进行如下配置::

    [LDAP]
    HOST = ldap://192.168.1.123/
    BASE = cn=users,dc=example,dc=com
    USER_DN = cn=admin,cn=users,dc=example,dc=com # or use admin@example.local etc
    PASSWORD = secret
    LOGIN_ATTR = userPrincipalName

`userPrincipalName`是 AD 提供的用户名， 通常隶属于`username@domain-name`, 而这里的`username`是指 Windows 用户登录名. 用户可以通过`username@domain-name`登录到 Seahub, 比如`poweruser@example.com`. 注意这样的用户登陆名并不是实际的 email 地址，Seahub 在这种设置下，邮件发送功能会失效.

注意：

1. 如果配置项包含中文，需要确保配置文件使用 UTF8 编码保存。
2. 这个文档中描述的配置方法经过很多人在不同的 LDAP/AD 环境下试过，肯定是能工作的。

## 通过 Windows 服务器连接到 LDAP/AD

Windows 下的配置语法与 Linux 下的有些不同. **你不需要增加`ldap:// prefix to the HOST field`.**

请在`ccnet.conf`下增加以下语句，以使用 LDAP 进行用户认证。

    [LDAP]
    # 在 HOST 域指定 LDAP/AD 服务器端口
    HOST = ldap.example.com[:port]
    # 默认为 'false'. 如果希望 Seafile 可通过 SSL 连接到 LDAP 服务器，请设置为 true.
    USE_SSL = true | false
    # 设置所有用户均可方位 base DN
    BASE = ou=users,dc=example,dc=com
    # 管理员用户 DN 绑定 LDAP. 如未设定，使用默认设置.
    USER_DN = cn=seafileadmin,dc=example,dc=com
    # 管理员用户的 DN 密码
    PASSWORD = secret
    # 用户登陆ID, 默认使用邮件格式.
    LOGIN_ATTR = mail

LDAP 配置示例:

    [LDAP]
    HOST = 192.168.1.123
    BASE = ou=users,dc=example,dc=com
    USER_DN = cn=admin,dc=example,dc=com
    PASSWORD = secret
    LOGIN_ATTR = mail

活动目录(Active Directory)配置示例:

    [LDAP]
    HOST = 192.168.1.123
    BASE = cn=users,dc=example,dc=com
    USER_DN = cn=admin,cn=users,dc=example,dc=com # or use admin@example.local etc
    PASSWORD = secret
    LOGIN_ATTR = mail

如果你使用活动目录(Active Directory)但并没有向用户提供 email 地址，可进行如下配置::

    [LDAP]
    HOST = 192.168.1.123
    BASE = cn=users,dc=example,dc=com
    USER_DN = cn=admin,cn=users,dc=example,dc=com # or use admin@example.local etc
    PASSWORD = secret
    LOGIN_ATTR = userPrincipalName

`userPrincipalName`是 AD 提供的用户名， 通常隶属于`username@domain-name`, 而这里的`username`是指 Windows 用户登录名. 用户可以通过`username@domain-name`登录到 Seahub, 比如`poweruser@example.com`. 注意这样的用户登陆名并不是实际的 email 地址，Seahub 在这种设置下，邮件发送功能会失效.

## 多重基准标识名(Multiple base DN)/可选搜索过滤器(Additional search filter)

当你的公司在使用 Seafile 并且有多于一个 OUs 的时候，多重基准标识名多重基准标识名(Multiple base DN)会很有用处.你可以在"BASE"配置中指定一个基准标识名（base DN）的列表，标识名由";"分开, 比如： `cn=developers,dc=example,dc=com;cn=marketing,dc=example,dc=com`

当你的公司组织庞大,但是只有一小部分人使用 Seafile 的时候，搜索过滤器（Search filter）会很有用处. 过滤器可以通过修改"FILTER"配置来实现，例如，在 LDAP 配置中增加以下语句:

```
FILTER = memberOf=CN=group,CN=developers,DC=example,DC=com
```

请注意上面的示例只是象征性的简介. `memberOf`只有在活动目录(Active Directory)中才适用.

这里是另一个示例:

```
FILTER = &(!(UserAccountControl:1.2.840.113556.1.4.803:=2))
```

## 常见问题及解决方案

### Ubuntu/Debian 下 ldaps(LDAP over SSL)不能正常运行 

请参考[这里](https://github.com/haiwen/seafile/issues/274)

这是因为预编译安装包是在 CentOS 下完成编译与发布的，所以 libldap 会在`/etc/openldap/ldap.conf`查找配置文件. 而Ubuntu/Debian 使用的是`/etc/ldap/ldap.conf`这个配置文件. 所以在客户端中找不到 CA 文件的路径。

解决方法如下

```
mkdir /etc/openldap && ln -s /etc/ldap/ldap.conf /etc/openldap/
```

# Seafile 企业版 LDAP 和 Active Directory 配置

LDAP (Light-weight Directory Access Protocol) 是企业广泛部署的用户信息管理服务器，微软的活动目录服务器（Active Directory）完全兼容 LDAP。这个文档假定您已经了解了 LDAP 相关的知识和术语。

## Seafile 是如何管理 LDAP 用户的

Seafile 中的用户分为两类：

* 保存在 Seafile 内部数据库中的用户。这些用户关联了一些属性，比如是否管理员，是否已激活等。这类用户又分为两个子类别：
    - 系统管理员直接创建的用户。这些用户保存在 ccnet 数据库里面的 EmailUser 表中。
    - 由 LDAP 导入的用户。当 LDAP 里的用户第一次登录 Seafile 时，Seafile 会把该用户的信息导入到内部数据库。
* 在 LDAP 中存在的用户。管理员可以通过配置文件指定 LDAP 中可以使用 Seafile 服务的用户范围。这些用户在第一次登录时被导入到 Seafile 数据库中。Seafile 只会直接操作存在数据库中的用户。

Seafile 会自动从内部数据库和 LDAP 中查找用户，只要用户存在于任何一个来源，他们都能登录。

## 基本的 LDAP/AD 集成配置

Seafile 要求 LDAP/AD 服务器中每个用户都有一个唯一的 ID。这个 ID 只能使用邮箱地址格式。一般来说，AD 有两个用户属性可以用作 Seafile 用户的 ID：

- email 地址：一般的机构都会给每个成员分配唯一的 email 地址，所以这是最常见配置。
- UserPrincipalName (UPN)：这个 AD 赋予给每个用户的一个唯一 ID。它的格式为 `用户登录名@域名`。尽管这个不是真实的 email 地址，但是它也能作为 Seafile 的用户 ID。如果机构的用户没有 email 地址，可以使用这个属性。

### 与 AD 集成

把下面的配置添加到 ccnet.conf 中。

如果你使用 email 地址作为用户唯一 ID：

```
[LDAP]
HOST = ldap://192.168.1.123/
BASE = cn=users,dc=example,dc=com
USER_DN = administrator@example.local
PASSWORD = secret
LOGIN_ATTR = mail
```

如果你使用 UserPrincipalName 作为用户 ID：

```
[LDAP]
HOST = ldap://192.168.1.123/
BASE = cn=users,dc=example,dc=com
USER_DN = administrator@example.local
PASSWORD = secret
LOGIN_ATTR = userPrincipalName
```

各个配置选项的含义如下：

* HOST: LDAP 服务器的地址 URL。如果您的 LDAP 服务器监听在非标准端口上，您也可以在 URL 里面包含端口号，如 ldap://ldap.example.com:389。
* BASE: 在 LDAP 服务器的组织架构中，用于查询用户的根节点的唯一名称（Distingushed Name，简称 DN）。这个节点下面的所有用户都可以访问 Seafile。注意这里必须使用 *OU* 或 *CN*，即 `BASE = cn=users,dc=example,dc=com` 或者 `BASE = ou=users,dc=example,dc=com` 可以工作。但是 `BASE = dc=example,dc=com` 不能工作。`BASE` 中可以填多个 OU, 用 `;` 分隔。
* USER_DN: 用于查询 LDAP 服务器中信息的用户的 DN。这个用户应该有足够的权限访问 BASE 以下的所有信息。通常建议使用 LDAP/AD 的管理员用户。
* PASSWORD: USER_DN 对应的用户的密码。
* LOGIN_ATTR: 用作 Seafile 中用户登录 ID 的 LDAP 属性，可以使用 `mail` 或者 `userPrincipalName`。

**注意：如果配置项包含中文，需要确保配置文件使用 UTF8 编码保存。**

关于如何选定 BASE 和 USER_DN 的一些技巧：

* 要确定您的 BASE 属性，您首先需要打开域管理器的图形界面，并浏览您的组织架构。
    * 如果您想要让系统中所有用户都能够访问 Seafile，您可以用 'cn=users,dc=yourdomain,dc=com' 作为 BASE 选项（需要替换成你们的域名）。
    * 如果您只想要某个部门的人能访问，您可以把范围限定在某个 OU （Organization Unit）中。您可以使用 `dsquery` 命令行工具来查找相应 OU 的 DN。比如，如果 OU 的名字是 'staffs'，您可以运行 `dsquery ou -name staff`。更多的信息可以参考[这里](https://technet.microsoft.com/en-us/library/cc770509.aspx)。
* AD 支持使用 'user@domain.com' 格式的用户名作为 `USER_DN`。比如您可以使用 administrator@example.com 作为 `USER_DN`。有些时候 AD 不能正确识别这种格式。此时您可以使用 `dsquery` 来查找用户的 DN。比如，假设用户名是 'seafileuser'，运行 `dsquery user -name seafileuser` 来找到该用户的 DN。更多的信息可以参考[这里](https://technet.microsoft.com/en-us/library/cc725702.aspx)。

### 与其他 LDAP 服务器集成

把以下配置添加到 ccnet.conf 中：

```
[LDAP]
HOST = ldap://192.168.1.123/
BASE = ou=users,dc=example,dc=com
USER_DN = cn=admin,dc=example,dc=com
PASSWORD = secret
LOGIN_ATTR = mail
```

配置选项的含义与 AD 配置相同。不过，你只能使用 mail 作为用户的 ID，因为其他 LDAP 服务器不支持 UserPrincipalName。

### 测试你的 LDAP 配置

从专业版 5.0.0 开始，我们提供了一个测试你的 LDAP 配置合法性的命令行工具。

使用这个工具之前，请先确定你使用的是专业版而且 Linux 系统中安装了 `python-ldap` 这个包。

```
sudo apt-get install python-ldap
```

然后你可以执行测试：

```
cd seafile-server-latest
./pro/pro.py ldapsync --test
```

测试脚本会检查 ccnet.conf 里面 `[LDAP]` 下面的配置。如果一切正常工作，它会打印出搜索的前十个用户。如果出错，它会打印出可能出错的配置信息。

注意当前这个脚本并不支持测试 `[LDAP_SYNC]` 下面的 LDAP 同步配置。

### 重启 Seafile 服务

***在更新了 ccnet.conf 之后，你必须重启 Seafile 服务以使得配置生效。***

## LDAP 高级配置选项

### 使用多个 BASE DN

当您想把公司中多个 OU 加入 Seafile 中时，您可以使用在配置中指定多个 BASE DN。您可以在"BASE"配置中指定一个 DN 的列表，标识名由";"分开, 比如： `cn=developers,dc=example,dc=com;cn=marketing,dc=example,dc=com`

### 用户过滤选项

当你的公司组织庞大，但是只有一小部分人使用 Seafile 的时候，搜索过滤器（Search filter）会很有用处. 过滤器可以通过修改"FILTER"配置来实现，例如，在 LDAP 配置中增加以下语句:

```
FILTER = memberOf=CN=group,CN=developers,DC=example,DC=com
```

请注意上面的示例只是象征性的简介. `memberOf`只有在活动目录(Active Directory)中才适用.

### 把 Seafile 用户限定在 AD 的一个组中

您可以利用用户过滤器选项来只允许 AD 某个组中的用户使用 Seafile。

1. 首先，您需要找到这个组的 DN。我们再次使用 `dsquery` 命令。比如，如果组的名字是 'seafilegroup'，那么您可以运行 `dsquery group -name seafilegroup`。
2. 然后您可以把一下配置加入 ccnet.conf 的 LDAP 配置中：

```
FILTER = memberOf={dsquery 命令的输出}
```

### 使用结果分页扩展（paged results extension）

LDAP 协议 v3 支持一个称为 "paged results" 的扩展功能。当您在 LDAP 中有大量用户的时候，这个选项能够大大提高列出用户的速度。而且，AD 限制了单次请求中返回的用户条目数量，您需要启用这个选项才能避免查询错误。

在 Seafile 企业版中，在 LDAP 配置中加入以下设置：

```
USE_PAGED_RESULT = true
```

## 【可选】配置 AD 用户同步

在企业版中，你还可以把 AD 中用户的其他信息导入到 Seafile 的内部数据库。这些信息包括：

- 用户的全名，部门等。这些信息可以用户方便地根据人名+部门来查找用户，在共享文件的时候比较有用。
- 用户的 Windows 登录名。导入到数据库之后，用户可以直接使用 Windows 用户名来登录 Seafile。
- 当用户在 AD 中被删除之后（比如离职），Seafile 会自动禁用他的账户。

### AD 用户同步配置

把以下配置添加到 ccnet.conf 里：

```
[LDAP]
......

[LDAP_SYNC]
ENABLE_USER_SYNC = true
DEACTIVE_USER_IF_NOTFOUND = true
SYNC_INTERVAL = 60
USER_OBJECT_CLASS = person
ENABLE_EXTRA_USER_INFO_SYNC = true
FIRST_NAME_ATTR = givenName
LAST_NAME_ATTR = sn
USER_NAME_REVERSE = true
DEPT_ATTR = department
UID_ATTR = sAMAccountName
ACTIVATE_USER_WHEN_IMPORT = true
```

各个选项的含义：

- **ENABLE_USER_SYNC**: 设置为 true 以启用用户同步功能
- **DEACTIVE_USER_IF_NOTFOUND**: 设置为 true 以禁用已经在 AD 中删除的用户
- **SYNC_INTERVAL**: 以分钟为单位的同步间隔。默认为 60 分钟同步一次。
- **USER_OBJECT_CLASS**: 用户对象的 class 名字。在 AD 中一般是 "person"。默认值也是 "person"。
- **ENABLE_EXTRA_USER_INFO_SYNC**: 同步用户的额外信息，包括用户的全名，部门，Windows 登录名。
- **FIRST_NAME_ATTR**: 用户名字对应的属性，默认使用 "givenName" 属性。
- **LAST_NAME_ATTR**: 用户的姓氏属性。默认使用 "sn" 属性。
- **USER_NAME_REVERSE**: 中文的人名里面姓氏和名字与西方的习惯相反，所以对中文名字，需要把这个选项设置为 true。
- **DEPT_ATTR**: 用户的部门属性。默认使用 "department" 属性。
- **UID_ATTR**: 用户的 Windows 登录名属性。一般使用 "sAMAccountName" 属性。
- **ACTIVATE_USER_WHEN_IMPORT**: 导入用户之后是否立即激活，默认是 true，即立即激活该用户。

如果你选择了 "userPrincipalName" 作为用户的唯一 ID，Seafile 不能使用这个 ID 作为 email 地址来发送通知邮件给用户。如果你的 AD 中也有用户的 email 地址属性，你可以把这个属性同步到 Seafile 的内部数据库中。配置的选项是：

- **CONTACT_EMAIL_ATTR**: 一般来说你可以把它设置为 "mail" 属性。

### 手工执行 AD 同步

在配置完成后，你可以手工执行同步来测试配置是否有效。

```
cd seafile-server-lastest
./pro/pro.py ldapsync
```

### 让 AD 同步不要自动导入新用户到数据库中

在默认情况下，AD 同步会把 AD 中检测到的新用户自动同步到 Seafile 的数据库中。这些新创建的用户会被自动设置为“已激活”。这些用户会被算入 license 用户数量中。

我们考虑以下场景：你在 AD 中有很多用户。但是你不想一次购买足够多的 license 把所有用户一次全部加入 Seafile。此时自动导入新用户的功能就会很容易把你的 license 消耗完毕，导致系统不可用。解决方案是：新用户只有在第一次登录的时候创建，而 AD 同步不会自动创建新用户。我们提供了一个选项来满足这种需求：

```
[LDAP_SYNC]
IMPORT_NEW_USER = false
```

## 【可选】导入 AD 中的群组到 Seafile

请参考[英文的文档](http://manual.seafile.com/deploy_pro/ldap_group_sync.html)

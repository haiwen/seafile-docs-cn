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

### 与 Active Directory 集成

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
* BASE: 在 LDAP 服务器的组织架构中，用于查询用户的根节点的唯一名称（Distingushed Name，简称 DN）。这个节点下面的所有用户都可以访问 Seafile。如果您想使用 LDAP 服务器的根节点（比如 dc=example,dc=com）作为查找用户的根节点，您需要添加 `FOLLOW_REFERRALS = false` 到配置中。这个选项的含义将在下面的部分中解释。
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

## 设置LDAP/AD用户同步(可选)

在Seafile Pro中，除了在用户登录时将用户导入到内部数据库之外，还可以配置Seafile来定期将用户信息从LDAP/AD服务器同步到内部数据库。

- 用户的全名，部门和电子邮件地址可以同步到内部数据库。用户使用这些信息可以更容易地搜索特定的用户。
- 用户的Windows或Unix登录id可以同步到内部数据库。这允许用户使用熟悉的登录id登录。
- 当用户从LDAP/AD中删除时，将禁用Seafile中相应的用户。否则，他仍然可以与Seafile客户机同步文件或访问web界面。
 
同步完成后，您可以在它的个人资料页上看到用户的全名、部门和电子邮件。

### Active Directory 用户同步配置

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

如果你选择了 "userPrincipalName" 作为用户的唯一 ID，Seafile 不能使用这个 ID 作为 email 地址来发送通知邮件给用户。如果你的 AD 中也有用户的 email 地址属性，你可以把这个属性同步到 Seafile 的内部数据库中。配置的选项是：

- **CONTACT_EMAIL_ATTR**: 一般来说你可以把它设置为 "mail" 属性。

### 同步其他 LDAP 服务

将以下配置项添加到 `ccnet.conf`:

```
[LDAP]
......

[LDAP_SYNC]
ENABLE_USER_SYNC = true
DEACTIVE_USER_IF_NOTFOUND = true
SYNC_INTERVAL = 60
USER_OBJECT_CLASS = userOfNames
ENABLE_EXTRA_USER_INFO_SYNC = true
FIRST_NAME_ATTR = givenName
LAST_NAME_ATTR = sn
DEPT_ATTR = department
UID_ATTR = uid
```

各配置项含义：

- **ENABLE_USER_SYNC**: 设置为 "true"，开启同步ldap用户功能。
- **DEACTIVE_USER_IF_NOTFOUND**: 如果设置为 "true"，当在LDAP服务器中删除用户时Seafile也将禁用该用户。
- **SYNC_INTERVAL**: 同步周期，单位为分钟，默认为60分钟。
- **USER_OBJECT_CLASS**: 这是用于指定搜索用户时用户类的名称。在OpenLDAP中，您可以使用“userOfNames”。默认值是“person”。
- **ENABLE_EXTRA_USER_INFO_SYNC**: 支持同步其他用户信息，包括用户的全名、部门和Windows/Unix登录名等。
- **FIRST_NAME_ATTR**: 用户名字对应的属性，默认使用 "givenName" 属性。
- **LAST_NAME_ATTR**: 用户的姓氏属性。默认使用 "sn" 属性。
- **USER_NAME_REVERSE**: 中文的人名里面姓氏和名字与西方的习惯相反，所以对中文名字，需要把这个选项设置为 true。
- **DEPT_ATTR**: 用户的部门属性。默认使用 "department" 属性。
- **UID_ATTR**: 用户的 Windows/Unix 登录名属性。 如果同步，用户还可以使用Windows/Unix登录名登录。 对于 OpenLDAP, 可以使用 “uid” 或类似的属性。

### 在不激活用户的情况下导入用户

默认情况下，使用上述配置导入的用户将被自动激活。对于一些拥有大量用户的组织，它们可能希望导入用户信息(例如：用户全名)，而不自动激活导入的用户。因为激活所有导入的用户将需要AD/LDAP中所有用户的许可证。

Seafile为这种情况提供了一组选项。 首先，您必须在`ccnet.conf`的"[LDAP_SYNC]"部分添加以下选项:

```
ACTIVATE_USER_WHEN_IMPORT = false
```

这可以防止Seafile在导入用户的同时激活这些用户。其次，在`seahub_settings.py`中添加以下选项:

```
ACTIVATE_AFTER_FIRST_LOGIN = True
```

而当用户第一次登录到Seafile时，该选项将自动激活用户。

使用这些配置，导入的用户可以被正常搜索到，也可以被共享文件，但是在用户首次登录之前不会占用license中的授权数。

### 手动触发 AD/LDAP 同步

在配置完成后，你可以手工执行同步命令来测试配置是否有效。

```
cd seafile-server-lastest
./pro/pro.py ldapsync
```

## LDAP/AD 集成高级配置选项

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

### 使用TLS连接到LDAP/AD服务器

要使用TLS连接到LDAP/AD服务器，您应该在LDAP/AD服务器上安装有效的SSL证书。

当前版本的Seafile Linux服务器包是在CentOS上编译的。我们在包中包含ldap客户端库，以维护与旧Linux发行版的兼容性。但是由于不同的Linux发行版对于OpenSSL库有不同的路径或配置，所以有时Seafile无法使用TLS连接到AD服务器。

绑定在Seafile包中的ldap库(libldap)是2.4版本的。如果您的Linux发行版足够新(比如CentOS 6、Debian 7或Ubuntu 12.04或更高版本)，则可以使用操作系统中安装的libldap。

在Ubuntu 14.04和Debian 7/8上，将绑定的ldap相关库移出库路径应该可以使TLS连接正常工作。

```
cd ${SEAFILE_INSTALLATION_DIR}/seafile-server-latest/seafile/lib
mkdir disabled_libs_use_local_ones_instead
mv liblber-2.4.so.2 libldap-2.4.so.2 libsasl2.so.2 libldap_r-2.4.so.2 disabled_libs_use_local_ones_instead/
```

在CentOS 6上，您必须移动libnssutil库:

```
cd ${SEAFILE_INSTALLATION_DIR}/seafile-server-latest/seafile/lib
mkdir disabled_libs_use_local_ones_instead
mv libnssutil3.so disabled_libs_use_local_ones_instead/
```

这可以有效地从库搜索路径中删除绑定的库。
当服务器启动时，它将找到并使用操作系统中的库(如果它们已经安装)。
每次升级Seafile时都必须执行这些操作。

### 配置集成多个ldap服务器

从Seafile 5.1.4 pro 开始，我们支持同时对接多个ldap服务器，除了"[ldap]"部分中的基本ldap服务器信息外，还可以在"[LDAP_MULTI_1]、[LDAP_MULTI_2]……[LDAP_MULTI_9]"部分中设置其他ldap服务器信息，因此您可以配置10个ldap服务器来对接Seafile。多ldap服务器意味着，当获取或搜索ldap用户时，它将迭代所有配置的ldap服务器，直到找到匹配的ldap服务器;在列出所有ldap用户时，它将迭代所有ldap服务器以获得所有用户;对于Ldap同步，它将所有配置Ldap服务器中的所有用户/组信息同步到seafile。

此处有一个 `ccnet.conf` 的配置示例如下：

```
[LDAP]
HOST = ldap://192.168.1.123/
BASE = ou=users,dc=example,dc=com
USER_DN = cn=admin,dc=example,dc=com
PASSWORD = secret
LOGIN_ATTR = mail
```
接着可以在`ccnet.conf`添加另一个ldap服务器的配置如下：

```
[LDAP_MULTI_1]
HOST = ldap://192.168.1.124/
BASE = ou=users,dc=example,dc=com
USER_DN = cn=admin,dc=example,dc=com
PASSWORD = secret
```

在6.3.8之前，所有ldap服务器都共享"[ldap]"部分中的"LOGIN_ATTR、USE_PAGED_RESULT、FOLLOW_REFERRALS"属性;对于ldap用户/组同步，所有ldap服务器都共享"[LDAP_SYNC]"部分中与ldap同步相关的所有属性。

从 Seafile 6.3.8 pro 开始，我们为每个ldap服务器支持更多独立的配置部分。可以在每个"[LDAP_MULTI_x]"部分独立设置"LOGIN_ATTR、USE_PAGED_RESULT和FOLLOW_REFERRALS"选项。此外，可以为每个LDAP服务器设置独立的"[LDAP_SYNC_MULTI_x]"部分。也就是说，每个LDAP服务器可以使用不同的LDAP同步选项。

仍然有一些共享配置选项只能在"[LDAP_SYNC]"部分中设置，该部分用于所有LDAP服务器。

* SYNC_INTERVAL
* DEACTIVE_USER_IF_NOTFOUND
* ACTIVATE_USER_WHEN_IMPORT
* IMPORT_NEW_USER
* DEL_GROUP_IF_NOT_FOUND

这些选项用于控制同步行为，因此它们被所有LDAP服务器共享。

注意：对于每个"[LDAP_SYNC_x]"部分，建议使用与之相对应的"[LDAP_SYNC_MULTI_x]"。否则，LDAP同步过程将使用"[LDAP_SYNC]"部分中的选项作为默认选项。

## 【可选】导入 AD 中的群组到 Seafile

请参考[英文的文档](http://manual.seafile.com/deploy_pro/ldap_group_sync.html)

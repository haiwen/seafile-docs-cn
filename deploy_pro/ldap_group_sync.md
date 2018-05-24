# 同步 AD 群组

在 4.1.0 版本之后，专业版开始支持从 LDAP 或者 AD 导入(同步)群组到 seafile。

## 工作原理

导入或同步的过程是从 LDAP 服务器上的组映射到 seafile 的内部数据库中的组。这个过程是单向的。

* 数据库中对组的任何改变都不会回传到 LDAP；
* 除了“设置成员为组管理员” 之外，数据库中对组的任何更改将被下一个LDAP同步操作覆盖。如果要添加或删除成员则只能在LDAP服务器上执行此操作。
* 导入组的创建者将会被设置为系统管理员。

一些LDAP服务器(如ad)允许将组设置为另一个组的成员。这被称为“嵌套”。我们的程序支持同步嵌套的群组。假设B组是A组成员，结果将是：B组的每个成员同时成为A组和B组的成员。

另外，从 6.3.0 版本开始，除了可以将 AD/LDAP 服务器中的群组导入为Seafile群组之外，我们还支持把LDAP服务器的 OU 导入为 Seafile 的组织架构，这会保留OU中各部门及其各群组间的层级关系。

有两种同步模式：

* 周期：同步过程将在固定的时间间隔内执行；
* 手动：可以通过执行一个脚本来触发同步过程；

## 前提条件

您已经在系统中安装了 python-ldap 库。

在 Debian 或 Ubuntu 下：

```
sudo apt-get install python-ldap
```

在 CentOS 或 RedHat 下

```
sudo yum install python-ldap
```

## 配置

在启用 LDAP 组同步之前，您应该已经配置好 LDAP 身份验证。有关详细信息请参考[Seafile 企业版 LDAP 和 Active Directory 配置](using_ldap.md)。

以下是 LDAP 组同步相关选项。它们定义在 [ccnet.conf](../config/ccent-conf.md) 的“[LDAP_SYNC]”配置段中。

* **ENABLE_GROUP_SYNC**：如果要启用 LDAP 组同步请设置为 “true”。
* **IMPORT_GROUP_STRUCTURE**：从OU中导入的群组是否保持其层级关系(组织架构)；仅支持 6.3.0 及其以上版本。
* **DEL_GROUP_IF_NOT_FOUND**：是否删除seafile中存在但AD中已经不存在的群组；仅支持 6.3.0 及其以上版本。
* **CREATE_GROUP_REPO**：从OU中导入群组时是否自动创建出群组资料库；仅支持 6.3.0 及其以上版本。
* **GROUP_OBJECT_CLASS**：这是用于搜索组对象的类的名称。在 Active directory 中，它通常是"group";在OpenLDAP或其他中，可以使用"groupOfNames","groupOfUniqueNames" 或者 "posixGroup",这取决于你使用的LDAP服务器。默认设置为"group"；**从 6.3.0 开始**，这个配置项又多了另一个配置功能，即 "organizationalUnit"，如果您打算从 OU 导入AD中的群组，毫无疑问您应该也只能配置 `GROUP_OBJECT_CLASS=organizationalUnit`
* **SYNC_INTERVAL**：同步周期，单位是分钟，默认设置为60分钟。
* **GROUP_FILTER**：在搜索组对象时使用的附加筛选器。如果设置了，最终用于搜索的筛选器是"(&(objectClass=GROUP_OBJECT_CLASS)(GROUP_FILTER))"，否则使用的筛选器将是"(objectClass=GROUP_OBJECT_CLASS)"。
* **GROUP_MEMBER_ATTR**：在加载组的成员时使用的属性字段。对于大多数directory服务器，属性是“member”，这也是默认值。对于"posixGroup"，它应该被设置为"memberUid"。
* **USER_ATTR_IN_MEMBERUID**：“memberuid”选项中的用户属性集,用于“posixgroup”。默认值为“uid”。

组的搜索基础是 `ccnet.conf` 中设置在"[LDAP]"配置段的"BASE_DN"。

### 同步一般群组为Seafile群组

这有一个关于 Active Directory 同步一般群组的配置示例：

```
[LDAP]
HOST = ldap://192.168.1.123/
BASE = cn=users,dc=example,dc=com
USER_DN = administrator@example.local
PASSWORD = secret
LOGIN_ATTR = mail

[LDAP_SYNC]
ENABLE_GROUP_SYNC = true
SYNC_INTERVAL = 60
```

对于AD，除了"ENABLE_GROUP_SYNC"之外，通常不需要配置其他选项。因为其他选项的默认值是AD的常用值。如果LDAP服务器中有特殊设置，则只设置相应的选项。

这有一个关于 OpenLDAP 同步一般群组的配置示例：

```
[LDAP]
HOST = ldap://192.168.1.123/
BASE = ou=users,dc=example,dc=com
USER_DN = cn=admin,dc=example,dc=com
PASSWORD = secret
LOGIN_ATTR = mail

[LDAP_SYNC]
ENABLE_GROUP_SYNC = true
SYNC_INTERVAL = 60
GROUP_OBJECT_CLASS = groupOfNames
```

### 同步OU为Seafile组织架构(6.3.0及其以上版本)

如果要配置从OU中同步企业的组织架构，除了上述的 `ENABLE_GROUP_SYNC = true` 选项外，您还需要配置以下相关选项：

* **GROUP_OBJECT_CLASS=organizationalUnit**：指明要从OU中导入群组。(必须配置)
* **IMPORT_GROUP_STRUCTURE=true**：要保持从OU中导入的群组间的层级关系。(建议配置)
* **DEL_GROUP_IF_NOT_FOUND=true**：从Seafile数据库中删除AD服务器上已经不存在的群组；当OU中的某部门或群组在AD中取消时，自动从Seafile中删除。(谨慎配置)
* **CREATE_GROUP_REPO=true**：从OU中导入群组时，自动为该群组创建一个部门资料库。(建议配置)

以下是一个关于同步OU组的配置示例：(从 OU 导入群组时，AD 和 OpenLDAP 的配置完全相同)

```
[LDAP]
HOST = ldap://192.168.1.123/
BASE = cn=users,dc=example,dc=com
USER_DN = administrator@example.local
PASSWORD = secret
LOGIN_ATTR = mail

[LDAP_SYNC]
ENABLE_GROUP_SYNC = true
GROUP_OBJECT_CLASS = organizationalUnit
IMPORT_GROUP_STRUCTURE = true
DEL_GROUP_IF_NOT_FOUND = true
CREATE_GROUP_REPO = true
SYNC_INTERVAL = 60
```

**注意** 在您重启seafile服务器后，不会立即同步，它在第一次同步周期后进行同步。例如，如果将同步周期设置为30分钟，则第一次自动同步将在您重启后的30分钟后发生。要立即同步，您需要手动触发。下一节将介绍这一情况。

运行同步后，您应该在日志 `logs/seafevents` 中看到如下所示的日志信息。并且在系统管理页面中应该能看到那些组。

```
[2015-03-30 18:15:05,109] [DEBUG] create group 1, and add dn pair CN=DnsUpdateProxy,CN=Users,DC=Seafile,DC=local<->1 success.
[2015-03-30 18:15:05,145] [DEBUG] create group 2, and add dn pair CN=Domain Computers,CN=Users,DC=Seafile,DC=local<->2 success.
[2015-03-30 18:15:05,154] [DEBUG] create group 3, and add dn pair CN=Domain Users,CN=Users,DC=Seafile,DC=local<->3 success.
[2015-03-30 18:15:05,164] [DEBUG] create group 4, and add dn pair CN=Domain Admins,CN=Users,DC=Seafile,DC=local<->4 success.
[2015-03-30 18:15:05,176] [DEBUG] create group 5, and add dn pair CN=RAS and IAS Servers,CN=Users,DC=Seafile,DC=local<->5 success.
[2015-03-30 18:15:05,186] [DEBUG] create group 6, and add dn pair CN=Enterprise Admins,CN=Users,DC=Seafile,DC=local<->6 success.
[2015-03-30 18:15:05,197] [DEBUG] create group 7, and add dn pair CN=dev,CN=Users,DC=Seafile,DC=local<->7 success.
```

## 手动触发同步

手动触发 LDAP 组同步。

```
cd seafile-server-lastest
./pro/pro.py ldapsync
```




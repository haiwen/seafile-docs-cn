# 同步 AD 群组

在 4.1.0 版本之后，专业版开始支持从 LDAP 或者 AD 导入(同步)群组到 seafile。

## 工作原理

导入或同步的过程是从 LDAP 服务器上的组映射到 seafile 的内部数据库中的组。这个过程是单向的。

* 数据库中对组的任何改变都不会回传到 LDAP；
* 除了“设置成员为组管理员” 之外，数据库中对组的任何更改将被下一个LDAP同步操作覆盖。如果要添加或删除成员则只能在LDAP服务器上执行此操作。
* 导入组的创建者将会被设置为系统管理员。

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

## 同步群组

### 配置

在启用 LDAP 组同步之前，您应该已经配置好 LDAP 身份验证。有关详细信息请参考[Seafile 企业版 LDAP 和 Active Directory 配置](using_ldap.md)。

以下是 LDAP 组同步相关选项。它们定义在 [ccnet.conf](../config/ccent-conf.md) 的“[LDAP_SYNC]”配置段中。

以下是选项摘要:

* **ENABLE_GROUP_SYNC**：如果要启用 LDAP 组同步请设置为 “true”。
* **GROUP_OBJECT_CLASS**: 这是用于搜索组对象的类的名称。在 Active Directory 中，通常是“group”；在 OpenLDAP 或其他服务器中，您可以使用“groupOfNames”、“groupOfUniqueNames”或“posixGroup”，这取决于您的LDAP服务器。默认值是“group”。
* **SYNC_INTERVAL**：设置自动同步周期，单位是分钟，您可以设置为60，这代表每隔60分钟从 LDAP/AD 服务器同步一次数据。
* **GROUP_FILTER**：在搜索组对象时使用的附加筛选器。如果设置了，最终用于搜索的筛选器是"(&(objectClass=GROUP_OBJECT_CLASS)(GROUP_FILTER))"，否则使用的筛选器将是"(objectClass=GROUP_OBJECT_CLASS)"。
* **GROUP_MEMBER_ATTR**：在加载组的成员时使用的属性字段。对于大多数directory服务器，属性是“member”，这也是默认值。对于"posixGroup"，它应该被设置为"memberUid"。
* **USER_ATTR_IN_MEMBERUID**：“memberuid”选项中的用户属性集,用于“posixgroup”。默认值为“uid”。
* **DEL_GROUP_IF_NOT_FOUND**: 如果设置为 “true”，即便在 AD/LDAP Server 上没有找到，也不会在Seafile中删除该群组；需要 Seafile-pro-6.3.0 及其以上版本。
* **SYNC_GROUP_AS_DEPARTMENT**: 如果设置该选项为 "true"，则将AD中的各群组同步为Seafile中的顶级“部门”，了解更多关于“部门”的信息可以参考[这里](https://help.seafile.com/zh/web_client/use_organization.html)。需要 Seafile-pro-6.3.8 及其以上版本。
* **CREATE_DEPARTMENT_LIBRARY**: 如果选择将普通群组同步为一个顶级“部门”，您还可以设置该选项为 "true"，当第一次同步群组时，会在“部门”中自动创建一个带有群组名称的部门资料库。
* **DEFAULT_DEPARTMENT_QUOTA**: 如果选择将普通群组同步为一个顶级“部门”，第一次同步群组时可以为每个“部门”设置默认的空间配额(以MB为单位)。如果未设置此选项，配额将设置为无限制。

查找群组的根节点是 `ccnet.conf` 的 “[LDAP]” 部分中设置的 “BASE_DN”。

一些LDAP服务器，例如 Active Directory，允许一个组作为另一个组的成员。这称为“组嵌套”。如果我们在A组中找到一个嵌套的B组，我们应该递归地将B组中的所有成员添加到A组中，并且B组仍然应该导入为一个独立的群组。也就是说，B组的所有成员也是A组的成员。

在某些LDAP服务器(如OpenLDAP)中，通常使用 "Posix" 组来存储组成员关系。如果要导入 "Posix" 组作为 Seafile 的群组，请将`GROUP_OBJECT_CLASS`选项设置为 "posixGroup"。LDAP中的 "posixGroup" 对象通常包含了成员 UID 的多值属性列表。可以使用 `GROUP_MEMBER_ATTR` 选项设置此属性的名称。默认情况下是 "MemberUid"。"MemberUid" 属性的值是一个可以用来标识用户的ID，它对应于用户对象中的属性。这个ID属性的名称通常是 "uid"，但是可以通过 `USER_ATTR_IN_MEMBERUID` 选项设置。注意，"posixGroup" 不支持嵌套组。

### 配置示例

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

这有一个关于 OpenLDAP 同步一般群组(但不是 PosiGroups)的配置示例：

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

## 同步OU为Seafile组织架构(6.3.0及其以上版本)

Seafile 中的“部门”是一个特殊的组。除了可以作为群组进行处理之外，还有两个“部门”特有的新的关键特性:

* 组织架构支持层次结构。一个部门可以有任何级别的子部门。
* 可以给部门设置存储空间配额。

Seafile 支持从AD/LDAP到“部门”的OU(Organizational Units)同步。同步过程保持了OU的层次结构。

从OU中导入“部门”的同步选项:
* **SYNC_DEPARTMENT_FROM_OU**: 设置为 "true"，开启从OU中同步“部门”的功能。
* **SYNC_INTERVAL**：设置自动同步周期，单位是分钟，您可以设置为60，这代表每隔60分钟从 LDAP/AD 服务器同步一次数据。
* **DEL_DEPARTMENT_IF_NOT_FOUND**: 如果设置为 "true"，一旦在AD/LDAP服务器中没有找到相应的OU，同步进程将删除这个“部门”。
* **CREATE_DEPARTMENT_LIBRARY**: 如果设置为 "true"，当第一次同步OU时，将会在“部门”中自动创建一个带有OU名称的部门资料库。
* **DEFAULT_DEPARTMENT_QUOTA**: 第一次同步OU时为每个“部门”设置的默认空间配额(以MB为单位)。如果未设置此选项，配额将设置为无限制。

**注意**：在6.3.8 pro之前，使用旧的配置语法将OU作为“部门”同步。这种语法从6.3.8 pro开始将不再支持。旧语法不支持同时从AD/LDAP同步组和OU。然而，这在许多情况下是必要的。使用新的语法，您可以同时同步群组和部门。

## 周期性同步和手动同步

周期性同步不会在您重新启动seafile server后立即发生。它在第一个同步间隔之后被调度。例如，如果您将同步间隔设置为30分钟，那么第一次自动同步将在服务重新启动30分钟后发生。要立即同步，您需要手动触发它。

运行同步后，您应该在日志 `logs/seafevents.log` 中看到如下所示的日志信息。并且在系统管理页面中应该能看到那些组。

```
[2015-03-30 18:15:05,109] [DEBUG] create group 1, and add dn pair CN=DnsUpdateProxy,CN=Users,DC=Seafile,DC=local<->1 success.
[2015-03-30 18:15:05,145] [DEBUG] create group 2, and add dn pair CN=Domain Computers,CN=Users,DC=Seafile,DC=local<->2 success.
[2015-03-30 18:15:05,154] [DEBUG] create group 3, and add dn pair CN=Domain Users,CN=Users,DC=Seafile,DC=local<->3 success.
[2015-03-30 18:15:05,164] [DEBUG] create group 4, and add dn pair CN=Domain Admins,CN=Users,DC=Seafile,DC=local<->4 success.
[2015-03-30 18:15:05,176] [DEBUG] create group 5, and add dn pair CN=RAS and IAS Servers,CN=Users,DC=Seafile,DC=local<->5 success.
[2015-03-30 18:15:05,186] [DEBUG] create group 6, and add dn pair CN=Enterprise Admins,CN=Users,DC=Seafile,DC=local<->6 success.
[2015-03-30 18:15:05,197] [DEBUG] create group 7, and add dn pair CN=dev,CN=Users,DC=Seafile,DC=local<->7 success.
```

手动触发 LDAP 同步：

```
cd seafile-server-lastest
./pro/pro.py ldapsync
```

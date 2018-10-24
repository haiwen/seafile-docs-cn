# 多存储后端

某些使用场景下，需要 Seafile 服务可以支持多个存储后端，例如：

1. 要将不同的文件类型存储到不同的存储后端。例如，普通文件可以存储到主存储(disks, SSD)；文档文件可以存储到 “冷存储”(其他存储系统)。
1. 结合多个存储后端来扩展存储的可扩展性。例如，单独使用一个 NFS 挂载卷时可能会受到大小限制；单独使用一个 S3 后端存储时，当对象数量变得很大时，Ceph RGW 的性能可能会受到很大影响。

在 Seafile 中，以资料库为单位，将数据分散存储到多个存储后端中。在同一个资料库中的所有数据将被存储到同一个存储后端。每个资料库和存储后端之间的映射关系存储在数据库中。根据使用情况选择不同的映射策略。

为了使用该功能，您需要：

1. 在 seafile.conf 中定义存储后端。
1. 在 seahub_settings.py 中开启多存储后端功能，并选择一个映射策略。

## 定义存储后端

在 Seafile 中，每一个存储后端都由一个 "storage class" 代表。存储后端由以下信息定义：

- `storage_id`：用来定义存储后端的内部 ID 字符串，对用户不可见。例如：'primary storage'。
- `name`：用户可见的存储名称。
- `is_default`：定义该存储是否是默认的。如果这个存储后端允许用户使用，当用户不选择时，将默认采用该存储后端。
- `commits`：该存储后端中，用来存放 commit 对象的存储位置。它可以是任何 Seafile 支持的存储，比如：文件系统、S3 或者 ceph。
- `fs`：该存储后端中，用来存放 fs 对象的存储位置。它可以是任何 Seafile 支持的存储，比如：文件系统、S3 或者 ceph。
- `blocks`：该存储后端中，用来存放 block 对象的存储位置。它可以是任何 Seafile 支持的存储，比如：文件系统、S3 或者 ceph。

commit, fs, 和 blocks 能够被存储在不同的存储中。这为定义存储后端提供了最为灵活的方式。

在 Seafile 6.3 之前的版本中，不支持多个存储后端。您必须明确地启用这个新功能，并使用与以前定义存储后端不同的语法格式定义存储后端。

首先，你必须在 seafile.conf 中启用这个功能：

```
[storage]
enable_storage_classes = true
storage_classes_file = /opt/seafile_storage_classes.json

[memcached]
memcached_options = --SERVER=<the IP of Memcached Server> --POOL-MIN=10 --POOL-MAX=100
```

- `enable_storage_classes`：设置为 True，开启多存储后端功能；接下来你必须在下一个配置项指定的 JSON 文件中定义出这些存储后端。
- `storage_classes_file`：指定包含有存储后端定义的 JSON 文件的位置。

JSON 文件是一个对象数组。每个对象定义一个存储后端。定义中的字段对应于我们需要为存储后端指定的信息。下面是一个例子:

```
[
{
"storage_id": "hot_storage",
"name": "Hot Storage",
"is_default": true,
"commits": {"backend": "s3", "bucket": "seafile-commits", "key": "ZjoJ8RPNDqP1vcdD60U4wAHwUQf2oJYqxN27oR09", "key_id": "AKIAIOT3GCU5VGCCL44A"},
"fs": {"backend": "s3", "bucket": "seafile-fs", "key": "ZjoJ8RPNDqP1vcdD60U4wAHwUQf2oJYqxN27oR09", "key_id": "AKIAIOT3GCU5VGCCL44A"},
"blocks": {"backend": "s3", "bucket": "seafile-blocks", "key": "ZjoJ8RPNDqP1vcdD60U4wAHwUQf2oJYqxN27oR09", "key_id": "AKIAIOT3GCU5VGCCL44A"}
},

{
"storage_id": "cold_storage",
"name": "Cold Storage",
"is_default": false,
"fs": {"backend": "fs", "dir": "/storage/seafile/seafile-data"},
"commits": {"backend": "fs", "dir": "/storage/seafile/seafile-data"},
"blocks": {"backend": "fs", "dir": "/storage/seafile/seaflle-data"}
},

{
"storage_id": "swift_storage",
"name": "Swift Storage",
"fs": {"backend": "swift", "tenant": "adminTenant", "user_name": "admin", "password": "openstack", "container": "seafile-commits", "auth_host": "192.168.56.31:5000", "auth_ver": "v2.0"},
"commits": {"backend": "swift", "tenant": "adminTenant", "user_name": "admin", "password": "openstack", "container": "seafile-fs", "auth_host": "192.168.56.31:5000", "auth_ver": "v2.0"},
"blocks": {"backend": "swift", "tenant": "adminTenant", "user_name": "admin", "password": "openstack", "container": "seafile-blocks", "auth_host": "192.168.56.31:5000", "auth_ver": "v2.0", "region": "RegionTwo"}
}
]
```

如上所示：`commits`，`fs` 和 `blocks` 信息的语法格式与 seafile.conf 中定义的 `[commit_object_backend]`, `[fs_object_backend]` 和 `[block_backend]` 语法格式相似。

如果你是用文件系统作为 `commits`，`fs` 或 `blocks` 的存储位置，您必须明确地提供"seafile-data"目录的路径。这些对象将会被存储在这个路径下的 `storage/commits`, `storage/fs`, `storage/blocks` 中。

**注意**：一般的文件系统，S3 和 Swift 后端是支持的，但 Ceph/RADOS 目前还不支持。

## 资料库映射策略

资料库映射策略决定了资料库使用的存储后端。目前我们为3个不同的用例提供3个策略。资料库的存储后端被创建和存储在一个数据表中。如果之后再更改映射策略各资料库对应的存储后端将不会改变。

选择映射策略之前，你需要在 seahub_settings.py 开启该功能：

```
ENABLE_STORAGE_CLASSES = True
```

### 用户选择

该策略需要用户在创建新资料库的时候选择存储后端。用户可以选择定义在 JSON 文件中的任何一个存储后端。

如果要使用该策略，需要在 seahub_settings.py 中添加以下配置：

```
STORAGE_CLASS_MAPPING_POLICY = 'USER_SELECT'
```

如果你开启了 STORAGE_CLASSES，但没有在 seahub_settings.py 中明确定义 `STORAGE_CLASS_MAPPING_POLIICY`，则默认使用“用户选择”策略。


### 基于角色映射

您还可以根据用户的角色配置用户可使用的存储后端。

在 `seahub_settings.py` 中加一个新的配置项 `storage_ids` 到角色配置段中，给每一个角色分配存储后端。如果给某个角色只分配了一个存储后端，这个角色下的用户将不能选择其他存储后端给资料库使用。否则，如果分配了多个存储后端，用户在创建资料库时可以从中选择一个存储后端。如果没有为角色分配任何存储后端，将使用JSON文件中指定的默认后端。

这里有一个简单的 seahub_settings.py 中的配置，使用该策略：

```
ENABLE_STORAGE_CLASSES = True
STORAGE_CLASS_MAPPING_POLICY = 'ROLE_BASED'

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
        'storage_ids': ['old_version_id', 'hot_storage', 'cold_storage', 'a_storage'],
    },
    'guest': {
        'can_add_repo': True,
        'can_add_group': False,
        'can_view_org': False,
        'can_use_global_address_book': False,
        'can_generate_share_link': False,
        'can_generate_upload_link': False,
        'can_invite_guest': False,
        'can_connect_with_android_clients': False,
        'can_connect_with_ios_clients': False,
        'can_connect_with_desktop_clients': False,
        'storage_ids': ['hot_storage', 'cold_storage'],
    },
}
```

### 基于资料库 ID 的映射

这个策略根据资料库的ID映射到存储后端。资料库的ID是UUID。这样，系统中的数据就可以在存储后端之间均匀地分配。

注意，这个策略并不是设计成完整的分布式存储解决方案。它不处理资料库数据在各存储后端之间的自动迁移。如果需要向配置文件添加更多的存储后端，则现有资料库将保留在它们的原始存储中。新的资料库可以在新的存储后端之间分布。您仍然需要在开始时计划系统的总存储容量。

要使用该策略，先在 seahub_settings.py 中添加以下配置项：

```
STORAGE_CLASS_MAPPING_POLICY = 'REPO_ID_MAPPING'
```

然后可以在 JSON 文件中的存储后端中添加 `for_new_library` 选项来存储新的资料库：

```
[
{
"storage_id": "new_backend",
"name": "New store",
"for_new_library": true,
"is_default": false,
"fs": {"backend": "fs", "dir": "/storage/seafile/new-data"},
"commits": {"backend": "fs", "dir": "/storage/seafile/new-data"},
"blocks": {"backend": "fs", "dir": "/storage/seafile/new-data"}
}
]
```
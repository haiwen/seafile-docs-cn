# Seafile FSCK

在服务器端，Seafile 通过一种内部格式将文件存储在资料库中。Seafile 对于文件和目录有其独有的表现方式（类似于Git）。

默认安装下，这些内部对象，会被直接存储在服务器的文件系统中（例如 Ext4，NTFS）。由于大多数文件系统，不能在服务器非正常关闭或系统崩溃后，保证文件内容的完整性。所以，如果当系统崩溃时，正在有新的内部对象被写入，那么当系统重启时，这些文件就会被损坏，相应的资料库也无法使用。

注意: 如果你把 seafile-data 目录存储在有后备电源的 NAS（例如 EMC 或 NetApp）系统中，或者使用 S3 作为专业版的服务器，内部对象不会被损坏。

从 2.0 版开始，Seafile 服务器引入了 `seafile-fsck` 工具来帮助你恢复这些毁坏的对象（类似于git-fsck工具）。这个工具将会进行如下两项工作：

1. 检查 Seafile 内部对象的完整性，并且删除毁坏的对象。
2. 恢复所有受影响的资料库到最近一致，可用的状态。

seaf-fsck 工具接受如下参数：

```
seaf-fsck [-c config_dir] [-d seafile_dir] [repo_id_1 [repo_id_2 ...]]
附加选项：
-D, --dry-run: 检查文件系统对象和块，但是不删除它们。
-s, --strict: 检查文件系统对象id是否和内容一致。
```

假设你按照标准安装，将 Seafile 安装到 `/data/haiwen` 目录下，在此目录下，运行如下命令：

```
cd /data/haiwen/seafile-server-{version}/seafile
export LD_LIBRARY_PATH=./lib:${LD_LIBRARY_PATH}
./bin/seaf-fsck -c ../../ccnet -d ../../seafile-data
```

这将会检查所有服务器端的资料库。

如果你知道哪个具体的资料库被毁坏，你也可以在命令行指定资料库 ID。可以通过在 Seahub 中访问资料库，来获得资料库 ID。在浏览器的地址栏，你将会看到类似于`https://seafile.example.com/repo/601c4f2f-5209-47a0-b939-1f8c7fae9ff2`的请求地址，其中`601c4f2f-5209-47a0-b939-1f8c7fae9ff2`便是资料库 ID.

在恢复之后，一些最近的文件更改或许会丢失，但是现在你可以访问这个资料库。请注意，此时一些客户端可能无法同步资料库，在客户端先解除同步，然后重新同步即可。

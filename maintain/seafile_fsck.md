# Seafile FSCK

在服务器端，Seafile把文件存储在一种内部格式的资料库中。Seafile对于文件和目录有其独自的表现方式（类似于Git）。

对于默认安装方式，这些内部对象存储在服务器端的文件系统目录中（例如Ext4，NTFS）。由于大多数文件系统不能保证文件内容的完整性当服务器非正常关闭或系统崩溃后，所以当系统崩溃时如果有新的内部对象正在被写入，那么当系统重启时它们就会呈现出毁坏状态，即相应的这部分资料库将无法使用。

注意: 如果你把seafile-data目录存储在后备电池的NAS（例如EMC或NetApp），或者专业版中的S3，内部对象不会被损坏。

从2.0版开始，Seafile服务器引入了seafile-fsck工具来帮助你恢复这些毁坏的对象（类似于git-fsck工具）。这个工具将会进行如下两项工作：

1. 检查Seafile内部对象的完整性，并且删除毁坏的对象。
2. 恢复所有受影响的资料库到最近一致，可用的状态。

seaf-fsck工具接受如下参数：

```
seaf-fsck [-c config_dir] [-d seafile_dir] [repo_id_1 [repo_id_2 ...]]
附加选项：
-D, --dry-run: 检查文件系统对象和块，但是不删除它们。
-s, --strict: 检查文件系统对象id是否和内容一致。
```

假设你按照标准的安装方式和目录结构，并且你的seafile安装到`/data/haiwen`目录下，你应当运行如下命令：

```
cd /data/haiwen/seafile-server-{version}/seafile
export LD_LIBRARY_PATH=./lib:${LD_LIBRARY_PATH}
./bin/seaf-fsck -c ../../ccnet -d ../../seafile-data
```

这将会检查所有服务器端的资料库。

如果你知道哪个具体的资料库被毁坏，你也可以在命令行指定库id。资料库id可以通过在seahub中导航到相应的库来获得。在网站浏览器的地址栏，你将会看到类似于`https://seafile.example.com/repo/601c4f2f-5209-47a0-b939-1f8c7fae9ff2`的请求地址，其中`601c4f2f-5209-47a0-b939-1f8c7fae9ff2`便是库id.

在恢复之后，一些最近的文件更改或许会丢失，但是现在你可以使用整个资料库。请注意，如果此时出现一些客户端无法同步资料库，你可以首先在客户端执行unsync资料库操作然后进行resync资料库目录。

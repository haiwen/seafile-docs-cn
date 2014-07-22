# Seafile GC

Seafile利用存储去重技术来减少存储资源的利用。
简单来说，这包含如下两层含义：

* 不同版本的文件或许会共享一些数据块。
* 不同的资料库也或许会共享一些数据块。

这项技术的运用将导致底层数据块不会被立即删除当你删除一个资料库后，因此Seafile服务器端没用的数据块将会增多。

为了释放无用数据块所占用的存储空间，你不得不在服务器端运行一个“垃圾回收”的程序来清理无用的数据块。

垃圾回收程序将会清理如下两种无用数据块：

1. 未被资料库所引用的数据块。
2. 如果你对一些资料库设置了历史长度限制，那么这些库的过期数据块也将会被删除。

** 运行垃圾回收程序之前，你必须在服务器端停掉seafile程序。**
这是因为垃圾回收程序会错误的删除刚刚写入Seafile的新的数据块。

运行垃圾回收程序

    cd seafile-server-{version}/seafile
    export LD_LIBRARY_PATH=./lib:${LD_LIBRARY_PATH}
    ./bin/seafserv-gc -c ../../ccnet -d ../../seafile-data

如果你[[搭建seafile服务器从源码|搭建和部署seafile服务器从源码]]，仅仅运行

    seafserv-gc -c ../../ccnet -d ../../seafile-data

当垃圾回收程序结束后，你也可以检查是否一些有用的数据块被错误的删除：

    seafserv-gc -c ../../ccnet -d ../../seafile-data --verify

如果一些有用的数据块丢失，它将会打印一些警告信息。

如果你想在真正删除一些数据块之前，做一些常规检查，可以使用--dry-run选项

    seafserv-gc -c ../../ccnet -d ../../seafile-data --dry-run

这将会向你展示数据块总数量和将被删除数据块数量。

如果在服务器端一些库的元数据被毁坏，垃圾回收程序将会停止处理，因为它无法识别是否一个数据块被一些毁坏的资料库所使用。如果你不想保留毁坏库的数据块，可以运行垃圾回收程序并使用--ignore-errors或-i选项。

    seafserv-gc -c ../../ccnet -d ../../seafile-data --ignore-errors

这将会屏蔽毁坏资料库的数据块为无用状态并删除掉它们。

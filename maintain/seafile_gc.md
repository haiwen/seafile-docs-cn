# Seafile GC

Seafile 利用存储去重技术来减少存储资源的利用。
简单来说，这包含如下两层含义：

* 不同版本的文件或许会共享一些数据块。
* 不同的资料库也或许会共享一些数据块。

运用这项技术之后，在你删除一个资料库时，会导致底层数据块不会被立即删除，因此 Seafile 服务器端没用的数据块将会增多。

通过运行**垃圾回收**程序，可以清理无用的数据块，释放无用数据块所占用的存储空间。

垃圾回收程序将会清理如下两种无用数据块：

1. 未被资料库所引用的数据块即数据块属于被删除的资料库。
2. 设置了历史长度限制的资料库的过期数据块。

**如果使用社区版服务器，运行垃圾回收程序之前，请先在服务器端停掉 Seafile 程序。这是因为垃圾回收程序，会错误的删除刚刚写入 Seafile 的新的数据块。对于专业版，3.1.11 及之后的版本，支持在线垃圾回收即如果使用 MySQL 或 PostgreSQL 数据库，你不需要暂停 Seafile 程序来进行垃圾回收。**

## 4.1.1 及之后的版本

从社区版 4.1.1 和 专业版 4.1.0开始， 我们改善了垃圾回收的命令参数和执行结果输出。

### Dry-run 模式

如果仅为了查看有多少垃圾可以回收而不进行删除操作，用 dry-run 选项：

```
seaf-gc.sh --dry-run [repo-id1] [repo-id2] ...
```

运行输出如下所示:

```
[03/19/15 19:41:49] seafserv-gc.c(115): GC version 1 repo My Library(ffa57d93)
[03/19/15 19:41:49] gc-core.c(394): GC started. Total block number is 265.
[03/19/15 19:41:49] gc-core.c(75): GC index size is 1024 Byte.
[03/19/15 19:41:49] gc-core.c(408): Populating index.
[03/19/15 19:41:49] gc-core.c(262): Populating index for repo ffa57d93.
[03/19/15 19:41:49] gc-core.c(308): Traversed 5 commits, 265 blocks.
[03/19/15 19:41:49] gc-core.c(440): Scanning unused blocks.
[03/19/15 19:41:49] gc-core.c(472): GC finished. 265 blocks total, about 265 reachable blocks, 0 blocks can be removed.

[03/19/15 19:41:49] seafserv-gc.c(115): GC version 1 repo aa(f3d0a8d0)
[03/19/15 19:41:49] gc-core.c(394): GC started. Total block number is 5.
[03/19/15 19:41:49] gc-core.c(75): GC index size is 1024 Byte.
[03/19/15 19:41:49] gc-core.c(408): Populating index.
[03/19/15 19:41:49] gc-core.c(262): Populating index for repo f3d0a8d0.
[03/19/15 19:41:49] gc-core.c(308): Traversed 8 commits, 5 blocks.
[03/19/15 19:41:49] gc-core.c(264): Populating index for sub-repo 9217622a.
[03/19/15 19:41:49] gc-core.c(308): Traversed 4 commits, 4 blocks.
[03/19/15 19:41:49] gc-core.c(440): Scanning unused blocks.
[03/19/15 19:41:49] gc-core.c(472): GC finished. 5 blocks total, about 9 reachable blocks, 0 blocks can be removed.

[03/19/15 19:41:49] seafserv-gc.c(115): GC version 1 repo test2(e7d26d93)
[03/19/15 19:41:49] gc-core.c(394): GC started. Total block number is 507.
[03/19/15 19:41:49] gc-core.c(75): GC index size is 1024 Byte.
[03/19/15 19:41:49] gc-core.c(408): Populating index.
[03/19/15 19:41:49] gc-core.c(262): Populating index for repo e7d26d93.
[03/19/15 19:41:49] gc-core.c(308): Traversed 577 commits, 507 blocks.
[03/19/15 19:41:49] gc-core.c(440): Scanning unused blocks.
[03/19/15 19:41:49] gc-core.c(472): GC finished. 507 blocks total, about 507 reachable blocks, 0 blocks can be removed.

[03/19/15 19:41:50] seafserv-gc.c(124): === Repos deleted by users ===
[03/19/15 19:41:50] seafserv-gc.c(145): === GC is finished ===

[03/19/15 19:41:50] Following repos have blocks to be removed:
repo-id1
repo-id2
repo-id3
```

如果在参数中指定资料库 ID，则程序只检查指定的资料库，否则所有的资料库将会被检查。

在程序输出的结尾，你会看到 "repos have blocks to be removed" 部分，这部分内容会列出含有可回收垃圾块的资料库的 ID，后续你可以运行程序不加 --dry-run 选项来回收这些资料库的垃圾数据块。

### 删除垃圾数据块

运行垃圾回收程序，不加 --dry-run 选项来删除垃圾数据块：

```
seaf-gc.sh [repo-id1] [repo-id2] ...
```

如果在参数中指定资料库 ID, 则程序只检查和删除指定的资料库。

正如前面所说，有两种类型的垃圾数据块可被回收，有时仅删除第一类无用数据块（属于删除的资料库）便可达到回收的目的，这种情况下，垃圾回收程序将不会检查未被删除的资料库，加入 “-r” 选项便可实现这个功能：

```
seaf-gc.sh -r
```

**Seafile 4.1.1 及之后的版本，被用户删除的资料库不会直接从系统中删除，它们会被转移到系统管理员界面的**垃圾箱**。垃圾箱中的资料库，只有在从垃圾箱中清除以后，它们的数据块才可被回收。**

## 3.1.2 及之后版本

运行垃圾回收程序

    ./seaf-gc.sh run

程序结束之后，运行以下命令，检查是否误删了还在使用的数据块，如果误删，会显示警告信息。

    ./seaf-gc.sh verify

可以通过 `dry-run` 选项，设置在运行垃圾回收程序前，进行完整性检查

程序将会显示 *所有的数据块数量* 和 *将要被删除的数据块数量*

    ./seaf-gc.sh dry-run

如果资料库已损坏，因为无法判断数据块是否还在被其他资料库使用，所以垃圾回收程序将会停止运行。

可以通过 `force` 选项，强制删除已损坏资料库的数据。通过将已损坏资料库的数据块标记为“未使用”，来将其删除。

    ./seaf-gc.sh force

## 3.1.2 及之前版本

运行垃圾回收程序

    cd seafile-server-{version}/seafile
    export LD_LIBRARY_PATH=./lib:${LD_LIBRARY_PATH}
    ./bin/seafserv-gc -c ../../ccnet -d ../../seafile-data

如果你[源码编译安装 Seafile 服务器](../build_seafile/linux.md)，仅仅运行

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

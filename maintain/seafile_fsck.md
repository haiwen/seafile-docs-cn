# Seafile FSCK

在服务器端，Seafile 通过一种内部格式将文件存储在资料库中。Seafile 对于文件和目录有其独有的表现方式（类似于Git）。

默认安装下，这些内部对象，会被直接存储在服务器的文件系统中（例如 Ext4，NTFS）。由于大多数文件系统，不能在服务器非正常关闭或系统崩溃后，保证文件内容的完整性。所以，如果当系统崩溃时，正在有新的内部对象被写入，那么当系统重启时，这些文件就会被损坏，相应的资料库也无法使用。

注意: 如果你把 seafile-data 目录存储在有后备电源的 NAS（例如 EMC 或 NetApp）系统中，或者使用 S3 作为专业版的服务器，内部对象不会被损坏。

从 2.0 版开始，Seafile 服务器引入了 `seafile-fsck` 工具来帮助你恢复这些毁坏的对象（类似于git-fsck工具）。这个工具将会进行如下两项工作：

1. 检查 Seafile 内部对象的完整性，并且删除毁坏的对象。
2. 恢复所有受影响的资料库到最近一致，可用的状态。

4.1 及之后的版本，我们提供一个 seaf-fsck.sh 脚本来运行 seafile-fsck 工具。 执行流程如下所示：

```
cd seafile-server-latest
./seaf-fsck.sh [--repair|-r] [--enable-sync|-e] [repo_id_1 [repo_id_2 ...]]
```

seaf-fsck 有检查资料库完整性和修复损坏资料库两种运行模式。

## 检查资料库完整性

执行 seaf-fsck.sh 不加任何参数将以**只读**方式检查所有资料库的完整性。

```
cd seafile-server-latest
./seaf-fsck.sh
```

如果你想检查指定资料库的完整性，只需将要检查的资料库 ID 作为参数即可：

```
cd seafile-server-latest
./seaf-fsck.sh [library-id1] [library-id2] ...
```

运行输出如下:

```
[02/13/15 16:21:07] fsck.c(470): Running fsck for repo ca1a860d-e1c1-4a52-8123-0bf9def8697f.
[02/13/15 16:21:07] fsck.c(413): Checking file system integrity of repo fsck(ca1a860d)...
[02/13/15 16:21:07] fsck.c(35): Dir 9c09d937397b51e1283d68ee7590cd9ce01fe4c9 is missing.
[02/13/15 16:21:07] fsck.c(200): Dir /bf/pk/(9c09d937) is curropted.
[02/13/15 16:21:07] fsck.c(105): Block 36e3dd8757edeb97758b3b4d8530a4a8a045d3cb is corrupted.
[02/13/15 16:21:07] fsck.c(178): File /bf/02.1.md(ef37e350) is curropted.
[02/13/15 16:21:07] fsck.c(85): Block 650fb22495b0b199cff0f1e1ebf036e548fcb95a is missing.
[02/13/15 16:21:07] fsck.c(178): File /01.2.md(4a73621f) is curropted.
[02/13/15 16:21:07] fsck.c(514): Fsck finished for repo ca1a860d.
```

被损坏的文件和目录将显示在输出的结果中。

有时，你会看到如下的输出结果：

```
[02/13/15 16:36:11] Commit 6259251e2b0dd9a8e99925ae6199cbf4c134ec10 is missing
[02/13/15 16:36:11] fsck.c(476): Repo ca1a860d HEAD commit is corrupted, need to restore to an old version.
[02/13/15 16:36:11] fsck.c(314): Scanning available commits...
[02/13/15 16:36:11] fsck.c(376): Find available commit 1b26b13c(created at 2015-02-13 16:10:21) for repo ca1a860d.
```

这意味着记录在数据库中的 "head commit" （当前资料库状态的标识）与数据目录中的记录不一致。这种情况下，fsck 会试着找出最近可用的一致状态，并检查其完整性。

建议: **如果你有很多资料库要检查，保存 fsck 的输出到日志文件中将有助于后面的进一步分析。**

## 修复损坏的资料库

fsck 修复损坏的资料库有如下两步流程:

1. 如果记录在数据库中的资料库当前状态无法在数据目录中找出，fsck 将会在数据目录中找到最近可用状态。
2. 检查第一步中可用状态的完整性。如果文件或目录损坏，fsck 将会将其置空并报告损坏的路径，用户便可根据损坏的路径来进行恢复操作。

执行如下命令来修复所有资料库：

```
cd seafile-server-latest
./seaf-fsck.sh --repair
```

大多数情况下我们建议你首先以只读方式检查资料库的完整性，找出损坏的资料库后，执行如下命令来修复指定的资料库：

```
cd seafile-server-latest
./seaf-fsck.sh --repair [library-id1] [library-id2] ...
```

由于被损坏的文件或目录在修复过后会被置空，在客户端同步被修复的损坏资料库将会导致数据丢失，即客户端先前好的完整的文件或目录拷贝将被空文件或空目录替代。为了避免这种情况发生，服务器将会阻止客户端同步被**修复**的损坏资料库。系统管理员应该通知用户来恢复损坏的文件或目录，然后执行如下命令让此资料库可以再次同步：

```
cd seafile-server-latest
./seaf-fsck.sh --enable-sync [library-id1] [library-id2] ...
```

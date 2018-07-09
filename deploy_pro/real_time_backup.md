# Seafile 实时备份服务器

备份是从主服务器(正在运行生产服务)将数据复制到备份服务器的过程。

备份是保证数据安全的重要步骤。在[备份文档](../maintain/backup_recovery.md)中表述的备份步骤有以下几点不足：

- 备份是在固定的“备份周期”(每天一次或每天几次)中完成的。如果主服务器存储被损坏，则在两个备份周期之间写入的最新数据将丢失。
- 备份过程会备份数据库和数据目录。在备份服务器中，数据库中的一些条目可能与数据目录不一致。这导致一些库在恢复后被“损坏”。

实时备份服务器使用与 Seafile 同步客户端类似的同步算法从主服务器检索数据。它的工作原理如下：

- 每当更新一个资料库时，主服务器都会通知备份服务器检索已更改的数据。使用增量同步算法，该过程快速运行并几乎实时地更新备份服务器。
- 备份服务器还会在一个固定的时间段主动检查主服务器上的所有资料库。任何新的或更新的库都将同步到备份服务器。这将修复由于之前的实时同步过程中出现的故障引起的任何遗漏的更新数据。
- 备份服务器始终保持数据库和数据目录的一致性。因此，备份服务器上的任何库都不会处于损坏状态(除非主服务器上的库已经损坏)。
- 所有资料库的全部历史将被备份。这与桌面客户端不一样，它只与资料库的最新状态同步。

有两组数据需要备份:

- Seafile 数据目录和 Seafile 数据库中的资料库核心元数据表。这些数据是 Seafile 中资料库的核心数据结构。它们通过 Seafile 的同步算法同步到备份服务器。在此过程中，元数据表与 Seafile 数据目录保持一致。
- 通过 mysqldump 备份数据库中的其他所有数据(包括 seafile，ccnet 和 seahub 数据)。但是 mysqldump 不能达到实时备份的效果，您可以通过设置 crontab 任务来周期性自动备份数据库。这些表的延迟备份不会影响 Seafile 资料库数据的完整性。

## 配置实时备份服务器

我们假设您已经有一整套的 Seafile 主服务器在运行，而现在您想要配置一套备份服务器。

配置备份服务器有以下几个步骤：

1. 在备份服务器上安装 Seafile 程序。
2. 在主服务器和备份服务器之间配置 Seafile 同步。
3. 通过 `mysqldump` 周期性的备份数据库中的数据。

### 在备份服务器上安装 Seafile

您可以按照这个[文档](../deploy_pro/download_and_setup_seafile_professional_server.md)在备份服务器上安装 Seafile。由于实时同步功能只有在 5.1.0 及其以上版本中可用，所以您必须将主服务器上的 Seafile 版本更新到 5.1.0 以上。

当在备份服务器上安装 Seafile 时需要注意：

- 数据库名称(ccnet，seafile 和 seahub 数据库)应该和主服务器上的相同。
- 您无需在备份服务器上开启专业版功能，例如 Office 文档预览，全文检索和文件编辑等功能。
- 您不能在主服务器上启动 Seahub 进程，这意味着通常情况下备份服务器不能对外提供服务。

### 配置 Seafile 实时同步

在主服务器上，添加以下配置到 `seafile.conf` 中：

```
[backup]
backup_url = http://backup-server
sync_token = c7a78c0210c2470e14a20a8244562ab8ad509734
```

在备份服务器上，添加以下配置到 `seafile.conf` 中：

```
[backup]
primary_url = http://primary-server
sync_token = c7a78c0210c2470e14a20a8244562ab8ad509734
sync_poll_interval = 3
```

- `backup_url`：备份服务器的访问地址，您可以使用http或https协议；
- `primary_url`：主服务器的访问地址。
- `sync_token`：主服务器和备份服务器之间共享的一个密钥，它是由系统管理员生成的40个字符的 SHA1。您可以使用 `uuidgen | openssl sha1` 命令生成一个随机密钥。
- `sync_poll_interval`：备份服务器定期轮询主服务器的所有资料库。您可以以小时为单位设置轮询间隔。默认的间隔是1小时，这意味着备份服务器将每小时轮询一次主服务器。如果您有大量的资料库，您应该选择较大的轮询间隔。

如果您使用https在主服务器和备份服务器之间同步，您必须为您的系统使用正确的 Seafile server 包。如果您使用的是 CentOS，您应该使用没有 “Ubuntu” 后缀的 Seafile 包;如果您使用的是 Debian 或 Ubuntu，您应该使用带有 “Ubuntu” 后缀的 Seafile 包。否则，您可能会在https请求中遇到CA错误。

保存配置后，在主服务器和备份服务器上重新启动 Seafile 服务。备份服务器将在重新启动时自动启动备份进程。

**注意**：不要在备份服务器上启动 Seahub 进程。

### 备份数据库

使用 `mysqldump` 备份服务器的 MySQL 数据：

```
mysqldump -u <user> -p<password> --databases \
--ignore-table=<seafile_db>.Repo \
--ignore-table=<seafile_db>.Branch \
--ignore-table=<seafile_db>.RepoHead \
<seafile_db> <ccnet_db> <seahub_db> > dbdump.sql
```

您应该将 `<user>`， `<password>` 替换为您的 MySQL 用户和密码，将 `<seafile_db>`， `<seahub_db>` 和 `<ccnet_db>` 替换为您的 MySQL 中的数据库名。

这三个被忽略的表是与资料库核心数据相关的表，并由 Seafile 备份服务器实时同步。它们保存在备份服务器的seafile数据库中，并与mysqldump进程分开。

**您应该设置 crontab 周期性自动运行 mysqldump 进程。**

如果希望以更实时的方式备份数据库表(除了使用Seafile同步的3个表)，可以将MySQL/MariaDB数据库主从复制的从主节点部署到另一个数据库服务器上。**在 Seafile 备份服务器上运行的数据库不能用作此复制的目标。**否则将导致复制冲突，因为备份服务器上的db也将通过 Seafile 备份进程进行更新。

### 检查备份状态

在上面的设置之后，您现在应该拥有以下备份数据的布局：

* 资料库数据由 Seafile 备份服务器备份和管理。根据备份服务器的设置，数据可以存储在外部存储、对象存储或本地磁盘上。
* 数据库表分为两部分:
	* 3个核心数据库表实时备份到备份节点的MySQL数据库。
	* 其他表通常被转储到带有 mysqldump 的文件中。备份文件存储在主服务器之外的其他地方。

`seaf-backup-cmd.sh` 提供 `status` 命令来查看备份状态。输出如下：

```
# ./seaf-backup-cmd.sh status
Total number of libraries: xxx
Number of synchronized libraries: xxx
Number of libraries waiting for sync: xxx
Number of libraries syncing: xxx
Number of libraries failed to sync: xxx

List of syncing libraries:
xxx
xxx

List of libraries failed to sync:
xxx
xxx
```

有几个原因可能导致库备份失败:

- 主服务器中的一些数据被损坏。这些数据可能处于最新状态或历史中。由于备份过程同步整个历史，历史中的损坏将导致备份失败。
- 主服务器运行了 `seaf-fsck`，它可以将库恢复到旧状态。

## 在备份服务器上恢复数据

在主服务器上发生严重数据损坏的不幸情况下，您可以直接在备份服务器上恢复服务。恢复的服务可以直接在备份服务器上运行。

在备份服务器上恢复数据有两个步骤：

- 将最新的 mysql dump 出的文件导入 Seafile 备份服务器的mysql数据库中。
- 在 Seafile 备份服务器上启用其他专业版功能特性，并启动seahub进程 `./seahub.sh start`。

#### 第一步：导入mysqldump数据到备份服务中

将最新的mysqldump文件导入备份服务器的数据库:

```
mysql -u <user> -p<pass> < dbdump.sql
```

将 `<user>` 和 `<pass>` 替换为您的 MySQL 的用户名密码。

#### 第二步：在备份服务器上启动 seahub 进程

将主服务器上的 Seafile 的配置复制到备份服务器，然后在备份服务器上启动seahub进程。

```
./seahub.sh start
```

## 为 Seafile 集群配置备份服务器

如果您的主服务作为一个 Seafile 集群运行，那么在设置备份服务器时需要注意两点:

1. 如果您使用的是MariaDB集群，那么您应该只使用其中一个 MySQL 实例作为主服务器。
2. 您必须更改`seafile.conf`并在每个 Seafile 节点上设置 `backup_url` 和`sync_token` 选项。所有主 Seafile 节点上的配置应该相同。它们都指向同一个备份服务器。

目前，不能将备份服务部署为集群。也就是说，您只能使用一个节点作为备份服务器。这种支持将来可能会增加。

## 管理实时备份服务器

`seaf-backup-cmd.sh` 脚本是管理备份服务器的工具。`seaf-backup-cmd.sh` 脚本提供以下命令:

### 手动触发资料库同步

您可以使用 `sync` 命令手动触发资料库的备份:

```
# ./seaf-backup-cmd.sh sync <library id>
```

该命令将被阻塞，直到备份完成。

### 处理备份错误

`sync` 命令的 `--force` 选项可以用来强制执行失败的备份。备份失败通常是由主服务器上的资料库的数据损坏引起的。`--force` 选项要求备份跳过损坏的对象并完成备份。

当发现备份错误时，请执行以下两个步骤:

1. 在主服务器上为失败的资料库运行 `seaf-fsck`。Fsck将修复资料库的任何损坏到最新的状态。
2. 在备份服务器上运行 `seaf-backup-cmd.sh sync --force <library id>`。
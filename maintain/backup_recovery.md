## 概述

一般来说，Seafile 备份分为两部分内容：

* Seafile 资料库数据
* 数据库

如果你根据我们的手册来安装 Seafile 服务器，你应该有如下目录结构：

    haiwen       # 根目录，haiwen 为示例文件名，如果你安装到其他目录则为相应的目录名
      --seafile-server-2.x.x # Seafile 安装包解压缩后目录
      --seafile-data   # Seafile 配置文件和数据（如果你选择默认方式）
      --seahub-data    # Seahub 数据
      --ccnet          # Ccnet 配置文件和数据
      --seahub.db      # Seahub 用到的 sqlite3 数据库文件
      --seahub_settings.py # seahub可选属性配置文件

你所有的资料库数据都存储在 **haiwen** 目录。

Seafile 也在数据库中存储一些重要的元数据。数据库的命名和存储路径取决于你所使用的数据库。

对于 SQLite, 数据库文件也存储在 **haiwen** 目录。相应的数据文件如下:

* ccnet/PeerMgr/usermgr.db: 包含用户信息
* ccnet/GroupMgr/groupmgr.db: 包含群组信息
* seafile-data/seafile.db: 包含资料库元数据信息
* seahub.db: 包含网站前端（Seahub）所用到的数据库表信息

对于 MySQL, 数据库由管理员来创建，所以不同的人部署，可能会有不同的文件名。大体而言，有如下三个数据库会被创建:

* ccnet-db: 包含用户和群组信息
* seafile-db: 包含资料库元数据信息
* seahub.db: 包含网站前端（seahub）所用到的数据库表信息

## 备份步骤 ##

备份需要如下三步：

1. 可选步: 如果你选择 SQLite 作为数据库，首先停掉 Seafile 服务器；
2. 备份数据库；
3. 备份存放 Seafile 数据的目录；

我们假设你的 Seafile 数据位于 `/data/haiwen` 目录下，并且你想将其备份到 `/backup` 目录（`/backup` 目录可以是 NFS（网络文件系统），可以是另一台机器的 Windows 共享，或者是外部磁盘）。请在 `/backup` 目录下创建如下目录结构：

    /backup
    ---- databases/  包含数据库备份
    ---- data/  包含 Seafile 数据备份

### 备份数据库 ###

我们建议你每次将数据库备份到另一个单独文件，并且不要覆盖最近一周来备份过的旧数据库文件。

**MySQL**

假设你的数据库名分别为 `ccnet-db`, `seafile-db` 和 `seahub-db`。`mysqldump` 会自动锁住表，所以在你备份 MySql 数据库的时候，不需要停掉 Seafile 服务器。通常因为数据库表非常小，所以执行以下命令备份不会花太长时间。

    mysqldump -h [mysqlhost] -u[username] -p[password] --opt ccnet-db > /backup/databases/ccnet-db.sql.`date +"%Y-%m-%d-%H-%M-%S"`

    mysqldump -h [mysqlhost] -u[username] -p[password] --opt seafile-db > /backup/databases/seafile-db.sql.`date +"%Y-%m-%d-%H-%M-%S"`

    mysqldump -h [mysqlhost] -u[username] -p[password] --opt seahub-db > /backup/databases/seahub-db.sql.`date +"%Y-%m-%d-%H-%M-%S"`

**SQLite**

对于 SQLite 数据库，在备份前你需要停掉 Seafile 服务器。

    sqlite3 /data/haiwen/ccnet/GroupMgr/groupmgr.db .dump > /backup/databases/groupmgr.db.bak.`date +"%Y-%m-%d-%H-%M-%S"`

    sqlite3 /data/haiwen/ccnet/PeerMgr/usermgr.db .dump > /backup/databases/usermgr.db.bak.`date +"%Y-%m-%d-%H-%M-%S"`

    sqlite3 /data/haiwen/seafile-data/seafile.db .dump > /backup/databases/seafile.db.bak.`date +"%Y-%m-%d-%H-%M-%S"`

    sqlite3 /data/haiwen/seahub.db .dump > /backup/databases/seahub.db.bak.`date +"%Y-%m-%d-%H-%M-%S"`

### 备份 Seafile 资料库数据 ###

由于所有的数据文件都存储在 `/data/haiwen` 目录, 备份整个目录即可。你可以直接拷贝整个目录到备份目录，或者你也可以用 rsync 做增量备份。

直接拷贝整个数据目录，

    cp -R /data/haiwen /backup/data/haiwen-`date +"%Y-%m-%d-%H-%M-%S"`

这样每次都会产生一个新的备份文件夹，完成后，可以删掉旧的备份。

如果你有很多数据，拷贝整个数据目录会花很多时间，这时你可以用rsync做增量备份。

    rsync -az /data/haiwen /backup/data

这个命令数据备份到 `/backup/data/haiwen` 下。

** 让拷贝和 rsync 过程成功结束是非常重要的，否则你最近的一些数据将会丢失。**

注意: 因为 `ccnet/ccnet.conf` 文件中的 ID 值必须和 `ccnet/mykey.peer` 中值的 SHA1 值保持一致。所以不要忘记拷贝 `ccnet/mykey.peer` 文件。

## 恢复备份 ##

如果你当前的 Seafile 服务器已经坏掉，将使用另一台机器来提供服务，需要恢复数据:

1. 假设在新机器中，Seafile 也被部署在了 `/data/haiwen` 目录中，拷贝 `/backup/data/haiwen` 到新机器中即可。
2. 恢复数据库。

### 恢复数据库

现在你已经拥有了数据库备份文件，你可以按如下步骤来进行恢复。

**MySQL**

    mysql -u[username] -p[password] ccnet-db < ccnet-db.sql.2013-10-19-16-00-05
    mysql -u[username] -p[password] seafile-db < seafile-db.sql.2013-10-19-16-00-20
    mysql -u[username] -p[password] seahub-db.sql.2013-10-19-16-01-05

**SQLite**

    cd /data/haiwen
    mv ccnet/PeerMgr/usermgr.db ccnet/PeerMgr/usermgr.db.old
    mv ccnet/GroupMgr/groupmgr.db ccnet/GroupMgr/groupmgr.db.old
    mv seafile-data/seafile.db seafile-data/seafile.db.old
    mv seahub.db seahub.db.old
    sqlite3 ccnet/PeerMgr/usermgr.db < usermgr.db.bak.xxxx
    sqlite3 ccnet/GroupMgr/groupmgr.db < groupmgr.db.bak.xxxx
    sqlite3 seafile-data/seafile.db < seafile.db.bak.xxxx
    sqlite3 seahub.db < seahub.db.bak.xxxx


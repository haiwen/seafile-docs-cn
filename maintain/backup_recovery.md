## 概述

一般来说，seafile备份分为两部分内容：

* Seafile库数据
* 数据库

如果你根据我们的手册来安装seafile服务器，你应该有如下目录结构：

    haiwen       # 根目录，haiwen为示例文件名，如果你安装到其他目录则为相应的目录名
      --seafile-server-2.x.x # seafile安装包解压缩后目录
      --seafile-data   # seafile配置文件和数据（如果你选择默认方式）
      --seahub-data    # seahub 数据
      --ccnet          # ccnet配置文件和数据 
      --seahub.db      # seahub用到的sqlite3数据库文件
      --seahub_settings.py # seahub可选属性配置文件

你所有的库数据都存储在'haiwen'目录。

Seafile也在数据库中存储一些重要的元数据。数据库的命名和存储路径取决于你所使用的数据库。

对于SQLite, 数据库文件也存储在'haiwen'目录。相应的数据文件如下:

* ccnet/PeerMgr/usermgr.db: 包含用户信息
* ccnet/GroupMgr/groupmgr.db: 包含组信息
* seafile-data/seafile.db: 包含库元数据信息
* seahub.db: 包含网站前端（seahub）所用到的表信息

对于MySQL, 数据库由管理员来创建，所以对于不同的人来部署，命名或许不同。大体而言，有如下三个数据库会被创建:

* ccnet-db: 包含用户和组信息
* seafile-db: 包含库元数据信息
* seahub.db: 包含网站前端（seahub）所用到的表信息

## 备份步骤 ##

备份需要如下三步：

1. 可选步: 如果你选择SQLite作为数据库，首先停掉Seafile服务器；
2. 备份数据库；
3. 备份seafile数据目录；

我们假设你的seafile数据目录位于`/data/haiwen`，并且你想将其备份到`/backup`目录。`/backup`目录可以是NFS格式或者是由另一台机器导出的Windows共享挂载也可以仅仅只是外部的磁盘。你可以在`/backup`目录下创建如下目录结构：

    /backup
    ---- databases/  包含数据库备份文件
    ---- data/  包含数据文件备份

### 备份数据库 ###

我们建议你每次将数据库备份到另一个单独文件，并且不要覆盖最近一周来备份过的旧数据库文件。

**MySQL**

假设你的数据库名分别为`ccnet-db`, `seafile-db` 和 `seahub-db`。利用mysqldump会自动锁住表，所以在你备份MySql数据库的时候不需要停掉Seafile服务器。通常因为数据库表非常小，所以执行以下命令备份不会花太长时间。

    mysqldump -h [mysqlhost] -u[username] -p[password] --opt ccnet-db > /backup/databases/ccnet-db.sql.`date +"%Y-%m-%d-%H-%M-%S"`

    mysqldump -h [mysqlhost] -u[username] -p[password] --opt seafile-db > /backup/databases/seafile-db.sql.`date +"%Y-%m-%d-%H-%M-%S"`

    mysqldump -h [mysqlhost] -u[username] -p[password] --opt seahub-db > /backup/databases/seahub-db.sql.`date +"%Y-%m-%d-%H-%M-%S"`

**SQLite**

对于SQLite数据库，在备份前你需要停掉Seafile服务器。

    sqlite3 /data/haiwen/ccnet/GroupMgr/groupmgr.db .dump > /backup/databases/groupmgr.db.bak.`date +"%Y-%m-%d-%H-%M-%S"`

    sqlite3 /data/haiwen/ccnet/PeerMgr/usermgr.db .dump > /backup/databases/usermgr.db.bak.`date +"%Y-%m-%d-%H-%M-%S"`

    sqlite3 /data/haiwen/seafile-data/seafile.db .dump > /backup/databases/seafile.db.bak.`date +"%Y-%m-%d-%H-%M-%S"`

    sqlite3 /data/haiwen/seahub.db .dump > /backup/databases/seahub.db.bak.`date +"%Y-%m-%d-%H-%M-%S"`

### 备份Seafile库数据 ###

由于所有的数据文件都存储在`/data/haiwen`目录, 所以只备份那整个目录即可。你可以直接拷贝整个目录到备份目录或者你也可以用rsync做增量备份。

直接拷贝整个数据目录，

    cp -R /data/haiwen /backup/data/haiwen-`date +"%Y-%m-%d-%H-%M-%S"`

这样每次都会产生另一个数据目录的备份目录，当新的备份目录产生你可以删掉旧的备份目录。

如果你有很多数据，拷贝整个数据目录会花很多时间，这时你可以用rsync做增量备份。

    rsync -az /data/haiwen /backup/data

这个命令备份数据目录到`/backup/data/haiwen`。

** 让拷贝和rsync过程成功结束是非常重要的，否则你最近的一些数据将会丢失。**

注意: `ccnet/ccnet.conf`文件中的ID属性值必须和`ccnet/mykey.peer`中值的SHA1运算值保持一致。所以不要忘记拷贝`ccnet/mykey.peer`文件。

## 恢复备份 ##

现在假设你的主seafile服务器已经坏掉，你正在转移到另一台机器即用备份的数据来恢复之前的seafile服务器:

1. 拷贝`/backup/data/haiwen`文件夹到新的机器。假设seafile在新机器上任部署到`/data/haiwen`目录。
2. 恢复数据库。

### 恢复数据库

现在你已经拥有最新的正确数据库文件备份，你可以按如下步骤来进行恢复。

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


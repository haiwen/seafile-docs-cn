## Overview

There are generally two parts of data to backup

* Seafile library data
* Databases

If you setup seafile server according to our manual, you should have a directory layout like:

    haiwen       # Replace the name with your organization name
      --seafile-server-2.x.x # untar from seafile package
      --seafile-data   # seafile configuration and data (if you choose the default)
      --seahub-data    # seahub data
      --ccnet          # ccnet configuration and data 
      --seahub.db      # sqlite3 database used by seahub
      --seahub_settings.py # optional config file for seahub

All your library data is stored under the 'haiwen' directory.

Seafile also stores some important metadata data in a few databases. The names and locations of these databases depends on which database software you use.

For SQLite, the database files are also under the 'haiwen' directory. The locations are:

* ccnet/PeerMgr/usermgr.db: contains user information
* ccnet/GroupMgr/groupmgr.db: contains group information
* seafile-data/seafile.db: contains library metadata
* seahub.db: contains tables used by the web front end (seahub)

For MySQL, the databases are created by the administrator, so the names can be different from one deployment to another. There are 3 databases:

* ccnet-db: contains user and group information
* seafile-db: contains library metadata
* seahub.db: contains tables used by the web front end (seahub)

## Backup steps ##

The backup is a three step procedure:

1. Optional: Stop Seafile server first if you're using SQLite as database.
2. Backup the databases;
3. Backup the seafile data directory;

We assume your seafile data directory is in `/data/haiwen`. And you want to backup to `/backup` directory. The `/backup` can be an NFS or Windows share mount exported by another machine, or just an external disk. You can create a layout similar to the following in `/backup` directory:

    /backup
    ---- databases/  contains database backup files
    ---- data/  contains backups of the data directory

### Backing up Databases ###

It's recommended to backup the database to a separate file each time. Don't overwrite older database backups for at least a week.

**MySQL**

Assume your database names are `ccnet-db`, `seafile-db` and `seahub-db`. mysqldump automatically locks the tables so you don't need to stop Seafile server when backing up MySQL databases. Since the database tables are usually very small, it won't take long to dump.

    mysqldump -h [mysqlhost] -u[username] -p[password] --opt ccnet-db > /backup/databases/ccnet-db.sql.`date +"%Y-%m-%d-%H-%M-%S"`

    mysqldump -h [mysqlhost] -u[username] -p[password] --opt seafile-db > /backup/databases/seafile-db.sql.`date +"%Y-%m-%d-%H-%M-%S"`

    mysqldump -h [mysqlhost] -u[username] -p[password] --opt seahub-db > /backup/databases/seahub-db.sql.`date +"%Y-%m-%d-%H-%M-%S"`

**SQLite**

You need to stop Seafile server first before backing up SQLite database.

    sqlite3 /data/haiwen/ccnet/GroupMgr/groupmgr.db .dump > /backup/databases/groupmgr.db.bak.`date +"%Y-%m-%d-%H-%M-%S"`

    sqlite3 /data/haiwen/ccnet/PeerMgr/usermgr.db .dump > /backup/databases/usermgr.db.bak.`date +"%Y-%m-%d-%H-%M-%S"`

    sqlite3 /data/haiwen/seafile-data/seafile.db .dump > /backup/databases/seafile.db.bak.`date +"%Y-%m-%d-%H-%M-%S"`

    sqlite3 /data/haiwen/seahub.db .dump > /backup/databases/seahub.db.bak.`date +"%Y-%m-%d-%H-%M-%S"`

### Backing up Seafile library data ###

The data files are all stored in the `/data/haiwen` directory, so just back up the whole directory. You can directly copy the whole directory to the backup destination, or you can use rsync to do incremental backup. 

To directly copy the whole data directory,

    cp -R /data/haiwen /backup/data/haiwen-`date +"%Y-%m-%d-%H-%M-%S"`

This produces a separate copy of the data directory each time. You can delete older backup copies after a new one is completed.

If you have a lot of data, copying the whole data directory would take long. You can use rsync to do incremental backup.

    rsync -az /data/haiwen /backup/data

This command backup the data directory to `/backup/data/haiwen`.

**It's very important to make sure the copy or rsync process finishes successfully. Otherwise some of your latest data may not be backed up.**

Important: The ID in `ccnet/ccnet.conf` must be consistent with the SHA1 value of `ccnet/mykey.peer`. So do not forget to copy `ccnet/mykey.peer`.

## Restore from backup ##

Now supposed your primary seafile server is broken, you're switching to a new machine. Using the backup data to restore your Seafile instance:

1. Copy `/backup/data/haiwen` to the new machine. Let's assume the seafile deployment location new machine is also `/data/haiwen`.
2. Restore the database.

### Restore the databases

Now with the latest valid database backup files at hand, you can restore them.

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


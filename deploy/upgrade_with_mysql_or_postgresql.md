#Seafile
## Upgrade with MySQL or PostgreSQL

First, download the new version, for example seafile-server_1.6.0_x86-64.tar.gz, and extract it to the directory where you put all Seafile related staff. You should have a directory layout similar to this:

<pre>
haiwen
   -- seafile-server-1.5.0
   -- seafile-server-1.6.0
   -- ccnet
   -- seafile-data
</pre>

## Major Continuous Upgrade (like from 1.5 to 1.6)

Major continuous upgrade including upgrading from 1.5.0 to 1.6.0 or upgrading from 1.5.0 to 1.6.1. It involves four steps:

1. Stop Seafile/Seahub
2. Update avatars folder and database tables
3. Update Nginx/Apache configs
4. Restart Seafile/Seahub

### 2. Update avatars folder and database tables （After Seafile Server 2.1.1 for MySQL）

Since seafile server 2.1.1, You can upgrade the the avatars folder and the databases using the upgrade scripts. The script's name is like `upgrade_X.X_Y.Y.sh`. For example, assume you are upgrading from seafile server 2.0.0 to seafile server 2.1.1, the you should run the `upgrade_2.0_2.1.sh` script.

```sh
cd seafile-server-2.1.1/
./upgrade/upgrade_2.0_2.1.sh
```

The script would update the avatars folder and the database tables for you.

### 2. Update avatars folder and database tables (For PostgreSQL and before Seafile Server 2.1.1)

Before Seafile Server 2.1.1 or if you are using PostgreSQL, you have to manually:

- update the avatars folder symbolic link
- update and the database tables

#### Update avatars symbolic link

Assume your top level directory is `/data/haiwen/`, and you are upgrading to seafile server version 1.6.0:

```
cd /data/haiwen
cp -a seafile-server-1.6.0/seahub/media/avatars/* seahub-data/avatars/
rm -rf seafile-server-1.6.0/seahub/media/avatars
#the new server avatars' folder will be linked to the updated avatars folder
ln -s -t seafile-server-1.6.0/seahub/media/  ../../../seahub-data/avatars/
```

#### Update database tables

When a new version of seafile server is released, there may be changes to the database of seafile/seahub/ccnet. We provide the sql statements to update the databases:

- `upgrade/sql/<VERSION>/mysql/seahub.sql`, for changes to seahub database
- `upgrade/sql/<VERSION>/mysql/seafile.sql`, for changes to seafile database
- `upgrade/sql/<VERSION>/mysql/ccnet.sql`, for changes to ccnet database

To apply the changes, just execute the sqls in the correspondent database. If any of the sql files above do not exist, it means the new version does not bring changes to the correspondent database.

```sh
seafile-server-1.6.0
├── seafile
├── seahub
├── upgrade
    ├── sql
        ├── 1.6.0
            ├── mysql
                ├── seahub.mysql
                ├── seafile.mysql
                ├── ccnet.mysql
```


### 3. Update Nginx/Apache Config

For Nginx:

```
  location /media {
      root /data/haiwen/seafile-server-1.6.0/seahub;
  }
```

For Apache:

```
Alias /media  /data/haiwen/seafile-server-1.6.0/seahub/media
```

**Tip:**
You can create a symbolic link <code>seafile-server-latest</code>, and make it point to your current seafile server folder (Since seafile server 2.1.0, the <code>setup-seafile.sh</code> script will do this for your). Then, each time you run a upgrade script, it would update the <code>seafile-server-latest</code> symbolic link to keep it always point to the latest version seafile server folder.

In this case, you can write:

```
    location /media {
        root /data/haiwen/seafile-server-latest/seahub;
    }
```

or For Apache:

```
Alias /media  /data/haiwen/seafile-server-latest/seahub/media
```

This way, you no longer need to update the nginx/apache config file each time you upgrade your seafile server.


### 4. Restart Seafile/Seahub/Nginx/Apache

After done above updating, now restart Seafile/Seahub/Nginx/Apache to see the new version at work!

## Noncontinuous Upgrade (like from 1.1 to 1.3)

You may also upgrade a few versions at once, e.g. from 1.1.0 to 1.3.0.
The procedure is:

1. upgrade from 1.1.0 to 1.2.0;
2. upgrade from 1.2.0 to 1.3.0.


## Minor upgrade (like from 1.5.0 to 1.5.1)

Minor upgrade is like an upgrade from 1.5.0 to 1.5.1.

Here is our dir strutcutre

<pre>
haiwen
   -- seafile-server-1.5.0
   -- seafile-server-1.5.1
   -- ccnet
   -- seafile-data
</pre>

### Update the avatar link

We provide a script for you, just run it:

```sh
cd seafile-server-1.5.1
upgrade/minor-upgrade.sh
```

### Update Nginx/Apache Config

For Nginx:

```
  location /media {
      root /data/haiwen/seafile-server-1.5.1/seahub;
  }
```

For Apache:

```
Alias /media  /data/haiwen/seafile-server-1.5.1/seahub/media
```

### Restart Seafile/Seahub/Nginx/Apache

After done above updating, now restart Seafile/Seahub/Nginx/Apache to see the new version at work!

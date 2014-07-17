# Migrate From SQLite to MySQL

First make sure the python module for MySQL is installed. On Ubuntu, use `apt-get install python-mysqldb` to install it.

Steps to migrate Seafile from SQLite to MySQL:

0. Stop seafile and seahub

1. Download [sqlite2mysql.sh](https://raw.github.com/haiwen/seafile/master/scripts/sqlite2mysql.sh) and [sqlite2mysql.py](https://raw.github.com/haiwen/seafile/master/scripts/sqlite2mysql.py) to the top directory of your Seafile installation path. For example, /data/haiwen.

2. Run sqlite2mysql.sh
```
  chmod +x sqlite2mysql.sh
  ./sqlite2mysql.sh
```
  This script will produce three files(ccnet-db.sql, seafile-db.sql, seahub-db.sql).

3. Create 3 databases named `ccnet-db`, `seafile-db`, `seahub-db`.
```
  create database `ccnet-db` character set = 'utf8';
  create database `seafile-db` character set = 'utf8';
  create database `seahub-db` character set = 'utf8';
```

4. Loads the sql files to your MySQL databases. For example:
```
  mysql> use `ccnet-db`
  mysql> source ccnet-db.sql
  mysql> use `seafile-db`
  mysql> source seafile-db.sql
  mysql> use `seahub-db`
  mysql> source seahub-db.sql
```

5. Modify configure files

  Append following lines to `ccnet/ccnet.conf`:

        [Database]
        ENGINE=mysql
        HOST=127.0.0.1
        USER=root
        PASSWD=root
        DB=ccnet-db
        CONNECTION_CHARSET=utf8

    Note: Use `127.0.0.1`, don't use `localhost`.

    Replace the database section in `seafile-data/seafile.conf` with following lines:

        [database]
        type=mysql
        host=127.0.0.1
        user=root
        password=root
        db_name=seafile-db
        CONNECTION_CHARSET=utf8

    Append following lines to `seahub_settings.py`:

        DATABASES = {
            'default': {
                'ENGINE': 'django.db.backends.mysql',
                'USER' : 'root',
                'PASSWORD' : 'root',
                'NAME' : 'seahub-db',
                'HOST' : '127.0.0.1',
                'OPTIONS': {
                    "init_command": "SET storage_engine=INNODB",
                }
            }
        }

6. Restart seafile and seahub



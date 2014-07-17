# Deploying Seafile with SQLite

## Download binary package

Visit our [download page](http://www.seafile.com/en/download/#server),  download the latest server package.

Choose one of:
- Generic Linux
- Windows
- Server for Raspberry Pi

```
#check if your system is x86 (32bit) or x86_64 (64 bit)
uname -m
```
Click the tarball link and save it.


## Deploying and Directory Layout

NOTE: If you place the Seafile data directory in external storage, such as NFS, CIFS mount, you should not use SQLite as the database, but use MySQL instead.

Supposed your organization's name is "haiwen", and you've downloaded seafile-server_1.4.0_* into your home directory. We suggest you to layout your deployment as follows :
```sh
mkdir haiwen
mv seafile-server_* haiwen
cd haiwen
# after moving seafile-server_* to this directory
tar -xzf seafile-server_*
mkdir installed
mv seafile-server_* installed
```

Now you should have the following directory layout
```sh
# tree . -L 2
.
├── installed
│   └── seafile-server_1.4.0_x86-64.tar.gz
└── seafile-server-1.4.0
    ├── reset-admin.sh
    ├── runtime
    ├── seafile
    ├── seafile.sh
    ├── seahub
    ├── seahub.sh
    ├── setup-seafile.sh
    └── upgrade
```

The benefit of this layout is that

 - We can place all the config files for Seafile server inside "haiwen" directory, making it easier to manage.
 - When you upgrade to a new version of Seafile, you can simply untar the latest package into "haiwen" directory. In this way you can reuse the existing config files in "haiwen" directory and don't need to configure again.


## Setting Up Seafile Server
#### Prerequisites

The Seafile server package requires the following packages have been installed in your system

- python 2.6.5+ or 2.7
- python-setuptools
- python-simplejson
- python-imaging
- sqlite3

```
#on Debian
apt-get update
apt-get install python2.7 python-setuptools python-simplejson python-imaging sqlite3
```

#### Setup

```sh
cd seafile-server-*
./setup-seafile.sh  #run the setup script & answer prompted questions
```

If some of the prerequisites are not installed, the seafile initialization script will ask you to install them.

The script will guide you through the settings of various configuration options.

**Seafile configuration options**

| Option | Description | Note |
| -- | -- | ---- |
| server name | Name of this seafile server | 3-15 characters, only English letters, digits and underscore ('_') are allowed |
| server ip or domain  | The IP address or domain name used by this server  | Seafile client program will access the server with this address |
| ccnet server port  | The TCP port used by ccnet, the underlying networking service of Seafile  | Default is 10001. If it's been used by other service, you can set it to another port. |
| seafile data dir  | Seafile stores your data in this directory. By default it'll be placed in the current directory.  | The size of this directory will increase as you put more and more data into Seafile. Please select a disk partition with enough free space. |
| seafile server port  | The TCP port used by Seafile to transfer data  | Default is 12001. If it's been used by other service, you can set it to another port. |
| httpsever port | The TCP port used by Seafile httpserver  | Default is 8082. If it's been used by other service, you can set it to another port. |


Now you should have the following directory layout :

```sh
#tree haiwen -L 2
haiwen
├── ccnet               # configuration files
│   ├── ccnet.conf
│   ├── mykey.peer
│   ├── PeerMgr
│   └── seafile.ini
├── installed
│   └── seafile-server_1.4.0_x86-64.tar.gz
├── seafile-data
│   └── seafile.conf
├── seafile-server-1.4.0  # active version
│   ├── reset-admin.sh
│   ├── runtime
│   ├── seafile
│   ├── seafile.sh
│   ├── seahub
│   ├── seahub.sh
│   ├── setup-seafile.sh
│   └── upgrade
├── seafile-server-latest  # symbolic link to seafile-server-1.4.0
├── seahub-data
│   └── avatars
├── seahub.db
├── seahub_settings.py   # optional config file
└── seahub_settings.pyc
```

The folder seafile-server-latest is a symbolic link to the current seafile server folder. When later you upgrade to a new version, the upgrade scripts would update this link to keep it always point to the latest seafile server folder.

## Running Seafile Server

#### Before Running

Since Seafile uses persistent connection between client and server, if you have a large number of clients , you should increase Linux file descriptors by ulimit before start seafile, like:

``ulimit -n 30000``

#### Starting Seafile Server and Seahub Website

- Start seafile:
```
./seafile.sh start # Start seafile service
```

- Start seahub:
```
./seahub.sh start <port>  # Start seahub website, port defaults to 8000
```

**Note**: The first time you start seahub, the script would prompt you to create an admin account for your seafile server.

After starting the services, you may open a web browser and types

``http://192.168.1.111:8000``

you will be redirected to the Login page. Enter the username and password you were provided during the Seafile setup. You will then be returned to the `Myhome` page where you can create libraries.

**Congratulations!** Now you have successfully setup your private Seafile server.

#### Run Seahub on another port

If you want to run seahub in a port other than the default 8000, say 8001, you must:

- stop the seafile server
```
./seahub.sh stop
./seafile.sh stop
```

- modify the value of SERVICE_URL in the file ``haiwen/ccnet/ccnet.conf``, like this: (assume your ip or domain is 192.168.1.100)
```
SERVICE_URL = http://192.168.1.100:8001
```

- restart seafile server
```
./seafile.sh start
./seahub.sh start 8001
```

see Seafile [Server Configuration Manual](deploy/server_configuration.md) for more details about ``ccnet.conf``.

## Manage Seafile and Seahub
####Stopping
```
./seahub.sh stop # stop seahub website
./seafile.sh stop # stop seafile processes
```
####Restarting
```
./seafile.sh restart
./seahub.sh restart
```
#### When the Scripts Fail

Most of the time, seafile.sh and seahub.sh work fine. But if they fail, you may

- Use pgrep command to check if seafile/seahub processes are still running
```
pgrep -f seafile-controller # check seafile processes
pgrep -f "manage.py run_gunicorn" # check seahub process
```

- Use pkill to kill the processes
```
pkill -f seafile-controller
pkill -f "manage.py run_gunicorn"
```

## That's it!

That's it! Now you may want read more about seafile.
- [Adminintration](../maintain/README.md)

# Seafile
## Server

This manual explains how to setup and run Seafile server from a pre-built package.

## Platform Support

- Generic Linux
    - including Raspberry Pi
- Windows

## Download

Visit [our download page](http://www.seafile.com/en/download), download the latest server package.

<pre>
#check if your system is x86 (32bit) or x86_64 (64 bit)
uname -m
</pre>


## Deploying and Directory Layout

NOTE: If you place the Seafile data directory in external storage, such as NFS, CIFS mount, you should not use SQLite as the database, but use MySQL instead. Please follow [https://github.com/haiwen/seafile/wiki/Download-and-Setup-Seafile-Server-with-MySQL this manual] to setup Seafile server.

Supposed your organization's name is "haiwen", and you've downloaded seafile-server_1.4.0_* into your home directory.
We suggest you to layout your deployment as follows :

<pre>
mkdir haiwen
mv seafile-server_* haiwen
cd haiwen
# after moving seafile-server_* to this directory
tar -xzf seafile-server_*
mkdir installed
mv seafile-server_* installed
</pre>

Now you should have the following directory layout
<pre>
# tree . -L 2
.
├── installed
│   └── seafile-server_1.4.0_x86-64.tar.gz
└── seafile-server-1.4.0
    ├── reset-admin.sh
    ├── runtime
    ├── seafile
    ├── seafile.sh
    ├── seahub
    ├── seahub.sh
    ├── setup-seafile.sh
    └── upgrade
</pre>

'''The benefit of this layout is that'''

* We can place all the config files for Seafile server inside "haiwen" directory, making it easier to manage.
* When you upgrade to a new version of Seafile, you can simply untar the latest package into "haiwen" directory. ''In this way you can reuse the existing config files in "haiwen" directory and don't need to configure again''.

## Setting Up Seafile Server

#### Prerequisites

The Seafile server package requires the following packages have been installed in your system

* python 2.6.5+ or 2.7
* python-setuptools
* python-simplejson
* python-imaging
* sqlite3

<pre>
#on Debian
apt-get update
apt-get install python2.7 python-setuptools python-simplejson python-imaging sqlite3
</pre>

#### Setup

<pre>
cd seafile-server-*
./setup-seafile.sh  #run the setup script & answer prompted questions
</pre>

If some of the prerequisites are not installed, the seafile initialization script will ask you to install them.

[[images/server-setup.png|You'll see these outputs when you run the setup script]]

The script will guide you through the settings of various configuration options.


{| border="1" cellspacing="0" cellpadding="5" align="center"
|+ Seafile configuration options
! Option
! Description
! Note
|-
| server name
| Name of this seafile server
| 3-15 characters, only English letters, digits and underscore ('_') are allowed
|-
| server ip or domain
| The IP address or domain name used by this server
| Seafile client program will access the server with this address
|-
| ccnet server port
| The TCP port used by ccnet, the underlying networking service of Seafile
| Default is 10001. If it's been used by other service, you can set it to another port.
|-
| seafile data dir
| Seafile stores your data in this directory. By default it'll be placed in the current directory.
| The size of this directory will increase as you put more and more data into Seafile. Please select a disk partition with enough free space.
|-
| seafile server port
| The TCP port used by Seafile to transfer data
| Default is 12001. If it's been used by other service, you can set it to another port.
|-
| httpsever  port
| The TCP port used by Seafile fileserver
| Default is 8082. If it's been used by other service, you can set it to another port.
|-
|}


If the setup is successful, you'll see the following output

[[images/server-setup-successfully.png]]

Now you should have the following directory layout :
<pre>
#tree haiwen -L 2
haiwen
├── ccnet               # configuration files
│   ├── ccnet.conf
│   ├── mykey.peer
│   ├── PeerMgr
│   └── seafile.ini
├── installed
│   └── seafile-server_1.4.0_x86-64.tar.gz
├── seafile-data
│   └── seafile.conf
├── seafile-server-1.4.0  # active version
│   ├── reset-admin.sh
│   ├── runtime
│   ├── seafile
│   ├── seafile.sh
│   ├── seahub
│   ├── seahub.sh
│   ├── setup-seafile.sh
│   └── upgrade
├── seafile-server-latest  # symbolic link to seafile-server-1.4.0
├── seahub-data
│   └── avatars
├── seahub.db
├── seahub_settings.py   # optional config file
└── seahub_settings.pyc
</pre>

The folder <code>seafile-server-latest</code> is a symbolic link to the current seafile server folder. When later you upgrade to a new version, the upgrade scripts would update this link to keep it always point to the latest seafile server folder.


## Running Seafile Server

#### Before Running

Since Seafile uses persistent connection between client and server, if you have '''a large number of clients ''', you should increase Linux file descriptors by ulimit before start seafile, like:

<pre>
ulimit -n 30000
</pre>

#### Starting Seafile Server and Seahub Website

Under seafile-server-1.4.0 directory, run the following commands

* Start seafile:

<pre>
./seafile.sh start # Start seafile service
</pre>

* Start seahub

<pre>
./seahub.sh start <port>  # Start seahub website, port defaults to 8000
</pre>

'''Note:''' The first time you start seahub, the script would prompt you to create an admin account for your seafile server.

After starting the services, you may open a web browser and types
<pre>
http://192.168.1.111:8000/
</pre>
you will be redirected to the Login page. Enter the username and password you were provided during the Seafile setup. You will then be returned to the `Myhome` page where you can create libraries.

'''Congratulations!''' Now you have successfully setup your private Seafile server.

#### Run Seahub on another port

If you want to run seahub in a port other than the default 8000, say 8001, you must:

* stop the seafile server
<pre>
./seahub.sh stop
./seafile.sh stop
</pre>

* modify the value of <code>SERVICE_URL</code> in the file <code>haiwen/ccnet/ccnet.conf</code>, like this: (assume your ip or domain is <code>192.168.1.100</code>)
<pre>
SERVICE_URL = http://192.168.1.100:8001
</pre>

* restart seafile server
<pre>
./seafile.sh start
./seahub.sh start 8001
</pre>

see [[Seafile server configuration options]] for more details about <code>ccnet.conf</code>.

## Stopping and Restarting Seafile and Seahub

#### Stopping

<pre>
./seahub.sh stop # stop seahub website
./seafile.sh stop # stop seafile processes
</pre>

#### Restarting

<pre>
./seafile.sh restart
./seahub.sh restart
</pre>

#### When the Scripts Fail

Most of the time, seafile.sh and seahub.sh work fine. But if they fail, you may

* Use '''pgrep''' command to check if seafile/seahub processes are still running

<pre>
pgrep -f seafile-controller # check seafile processes
pgrep -f "manage.py run_gunicorn" # check seahub process
</pre>

* Use '''pkill''' to kill the processes

<pre>
pkill -f seafile-controller
pkill -f "manage.py run_gunicorn"
</pre>

## That's it!
That's it! Now you may want read more about seafile.

* [[Seafile-server-management|How to manage the server]].

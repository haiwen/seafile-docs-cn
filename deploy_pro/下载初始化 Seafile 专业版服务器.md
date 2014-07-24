- [Preparation](#wiki-preparation)
- [Switch between the Seafile Community/Professional Server](#wiki-switch-server-version)
- [Configurable Options](#wiki-configurable-options)
- [Upgrading of Seafile Professional Server](#wiki-upgrade)
- [FAQ](#wiki-faq)


## <a id="wiki-preparation"></a>Preparation ##

### Minimum System Requirement ###

- A Linux server with 2GB RAM

### Install Java Runtime Environment (JRE) ###

On Ubuntu/Debian:
```
sudo apt-get install default-jre
```

On CentOS/Red Hat:
```
sudo yum install java-1.6.0-openjdk
```

*Note*: You can use either the JRE of openJDK or Oracle JRE, but not the GCJ(GNU Java) package.

### Install Libreoffice/UNO ###

Libreoffice program and Python-uno library is needed to enable office files online preview. If you don't install them, the office documents online preview will be disabled.

On Ubuntu/Debian:
```
sudo apt-get install libreoffice python-uno
```

On Centos/RHEL:
```
sudo yum install libreoffice libreoffice-headless libreoffice-pyuno
```

For other Linux distro: [Installation of LibreOffice on Linux](http://www.libreoffice.org/get-help/installation/linux/)

Also, you may need to install fonts for your language, especially for Asians, otherwise the  office/pdf document may not display correctly. 

For example, Chinese users may wish to install the WenQuanYi series of truetype fonts:

```
# For ubuntu/debian
sudo apt-get install ttf-wqy-microhei ttf-wqy-zenhei xfonts-wqy
```


### Install Python libraries ###

First make sure your have installed python 2.6 or 2.7
```
python --version
```

#### gevent ####

On Ubuntu/Debian:
```
sudo apt-get install python-gevent
```

On CentOS/RHEL:

```
sudo yum install gcc libevent-devel python-devel
sudo easy_install gevent
```

## Download and Setup Seafile Professional Server ##

### Get the license ###

Put the license you get under the top level diretory. In our wiki, we use the diretory `/data/haiwen/` as the top level directory.


### <a id="wiki-download-and-uncompress"></a>Download/Uncompress Seafile Professional Server ###

- 32bit
- [64bit](http://seacloud.cc/repo/0a3b015d-d82b-4c89-90b8-b010855bc57b/)

```
tar xf seafile-pro-server_1.7.0_x86-64.tar.gz
```

Now you have:

```
haiwen
├── seafile-license.txt
└── seafile-pro-server-1.7.0/
```


-----------

You should notice the difference between the names of the Community Server and Professional Server. Take the 1.7.0 64bit version as an example:

- Seafile Community Server tarball is `seafile-server_1.7.0_x86-86.tar.gz`; After uncompressing, the folder is `seafile-server-1.7.0`
- Seafile Professional Server tarball is `seafile-pro-server_1.7.0_x86-86.tar.gz`; After uncompressing, the folder is `seafile-pro-server-1.7.0`
    
-----------


### Setup ###

The setup process of Seafile Professional Server is the same as the Seafile Community Server. See [Download and Setup Seafile Server](https://github.com/haiwen/seafile/wiki/Download-and-setup-seafile-server) in the community wiki.

After you have succesfully setup Seafile Professional Server, you would have a directory layout like this:

```
#tree haiwen -L 2
haiwen
├── seafile-license.txt # license file
├── ccnet               # configuration files
│   ├── ccnet.conf
│   ├── mykey.peer
│   ├── PeerMgr
│   └── seafile.ini
├── pro-data            # data specific for professional version
│   └── seafevents.conf
├── seafile-data        
│   └── seafile.conf
├── seafile-pro-server-1.7.0
│   ├── reset-admin.sh
│   ├── runtime
│   ├── seafile
│   ├── seafile.sh
│   ├── seahub
│   ├── seahub-extra
│   ├── seahub.sh
│   ├── setup-seafile.sh
│   └── upgrade
├── seahub-data
│   └── avatars         # for user avatars
├── seahub.db
├── seahub_settings.py   # seahub config file
```

## <a id="wiki-switch-server-version"></a>Switch between the Community/Professional Server ##

It's quite likely you have deployed the Seafile Community Server and want to switch to the Professional Server, or vice versa. But there are some restrictions:

- You can only switch between Community Server and Professional Server of the same version.

That is, if you are using Community Server 1.6.0, and want to switch to the Professional Server 1.7.0, you must first upgrade to Community Server 1.7.0, and then follow the guides below to switch to the Professional Server 1.7.0.

### Switch from Community Server to Professional Server

In this situation,

- Stop Seafile Server if it's running
- Install the dependecies listed in the [Preparation](#wiki-preparation) section
- Get and uncompress the Professional Server tarball
- Run the Professional Server setup script
```
cd haiwen/seafile-pro-server-1.7.0/
./pro/pro.py setup --migrate
```

  The last command does the following for you:
  - ensure your have all the prerequisites met
  - create necessary extra configurations
  - update the avatar directory
  - create extra database tables  

**If you have been using MySQL for Seafile**

After the above setups, you need to:

1. Execute the SQL statesments in the file `seafile-pro-server-1.7.0/pro/misc/seahub_extra.mysql.sql` on your seahub database to add the extra seahub tables.
2. Edit the file `/data/haiwen/pro-data/seafevents.conf`:
```
[DATABASE]
type=mysql
username=<mysql username>
password=<mysql user password>
name=seahub-db
host=localhost
```

### Switch from Professional Server to Community Server

In the situation,

- Stop Seafile Server if it's running
- update the avatar directory link just like in [Minor Upgrade](https://github.com/haiwen/seafile/wiki/Upgrading-Seafile-Server#minor-upgrade-like-from-150-to-151)

## <a id="wiki-configurable-options"></a>Configurable Options ##

In the file `/data/haiwen/pro-data/seafevents.conf`:

```
[INDEX FILES]
# must be "true" to enable search
enabled = true

# The interval the search index is updated. Can be s(seconds), m(minutes), h(hours), d(days)
interval=10m

# If true, index the contents of office/pdf files while updating search index
# Note: If you change this option from "false" to "true", then you need to clear the search index and update the index again. See the FAQ for details.
index_office_pdf=false

[OFFICE CONVERTER]

# must be "true" to enable office/pdf file online preview
enabled = true

# How many libreoffice worker process to run concurrenlty
workers = 1

# how many pages are allowed to be previewed online. Default is 50 pages
max-pages = 50

# the max size of documents to allow to be previewed online, in MB. Default is 2 MB
max-size = 2

[SEAHUB EMAIL]

# must be "true" to enable user email notifications when there are new messages
enabled = true

# interval of sending seahub email. Can be s(seconds), m(minutes), h(hours), d(days)
interval = 30m

```

# <a id="wiki-upgrade"></a>Upgrading

See [Upgrading Seafile Server](https://github.com/haiwen/seafile/wiki/Upgrading-Seafile-Server#minor-upgrade-like-from-150-to-151) in the Community wiki.

# <a id="wiki-faq"></a>FAQ #

## <a id="wiki-search-faq"></a>FAQ about Search ##

- However I tried, files in an encrypted library aren't listed in the search results 

  This is because the server can't index encrypted files, since, they are encrypted.

- I switched to Professional Server from Community Server, but whatever I search, I get no results

  The search index is updated every 10 minutes by default. So before the first index update is performed, you get nothing no matter what you search.

  To be able to search immediately,

  - Make sure you have started seafile server
  - Update the search index manually:
  ```
  cd haiwen/seafile-pro-server-1.7.0
  ./pro/pro.py search --update
  ```

  If you have lots of files, this process may take quite a while.

- I want to enable full text search for office/pdf documents, so I set `index_office_pdf` to `true` in the configuration file, but it doesn't work.

  In this case, you need to:
  1. Edit the value of `index_office_pdf` option in `/data/haiwen/pro-data/seafevents.conf` to `true`
  2. Restart seafile server
  ```
  cd /data/haiwen/seafile-pro-server-1.7.0/
  ./seafile.sh restart
  ```
  3. Delete the existing search index
  ```
  ./pro/pro.py search --clear
  ```
  4. Create and update the search index again
  ```
  ./pro/pro.py search --update
  ```

## <a id="wiki-search-faq"></a>FAQ about Office/PDF document preview ##
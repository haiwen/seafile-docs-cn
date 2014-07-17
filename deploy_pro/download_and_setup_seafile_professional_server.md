# Download and Setup Seafile Professional Server
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

### Install poppler-utils ###

We need poppler-utils for full text search of pdf files.

On Ubuntu/Debian:
```
sudo apt-get install poppler-utils
```

On CentOS/Red Hat:
```
sudo yum install poppler-utils
```


### Install Libreoffice/UNO ###

Libreoffice program and Python-uno library is needed to enable office files online preview. If you don't install them, the office documents online preview will be disabled.

**Note:** We recommend using libreoffice 4.0 or 4.1. Old versions of libreoffice may not display some non-ascii fonts correctly. Libreoffice 4.2 can't be used too. We are going to work on this issue soon.

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
sudo easy_install pip
sudo pip install boto
```

If you receive an error about "Wheel installs require setuptools >= ...", run this between the pip and boto lines above
```
sudo pip install setuptools --no-use-wheel --upgrade
```

### Install other libraries as required in the community edition

See [Download and Setup Seafile Server With MySQL](../deploy/using_mysql.md).

## <a id="wiki-download-and-setup"></a>Download and Setup Seafile Professional Server ##

### Get the license ###

Put the license you get under the top level diretory. In our wiki, we use the diretory `/data/haiwen/` as the top level directory.


### <a id="wiki-download-and-uncompress"></a>Download/Uncompress Seafile Professional Server ###

- 32bit
- [64bit](http://seacloud.cc/repo/0a3b015d-d82b-4c89-90b8-b010855bc57b/)

```
tar xf seafile-pro-server_1.8.0_x86-64.tar.gz
```

Now you have:

```
haiwen
├── seafile-license.txt
└── seafile-pro-server-1.8.0/
```


-----------

You should notice the difference between the names of the Community Server and Professional Server. Take the 1.8.0 64bit version as an example:

- Seafile Community Server tarball is `seafile-server_1.8.0_x86-86.tar.gz`; After uncompressing, the folder is `seafile-server-1.7.0`
- Seafile Professional Server tarball is `seafile-pro-server_1.8.0_x86-86.tar.gz`; After uncompressing, the folder is `seafile-pro-server-1.7.0`
    
-----------


### Setup ###

The setup process of Seafile Professional Server is the same as the Seafile Community Server. See [Download and Setup Seafile Server With MySQL](../deploy/using_mysql.md).

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
├── seafile-pro-server-1.8.0
│   ├── reset-admin.sh
│   ├── runtime
│   ├── seafile
│   ├── seafile.sh
│   ├── seahub
│   ├── seahub-extra
│   ├── seahub.sh
│   ├── setup-seafile.sh
│   ├── setup-seafile-mysql.py
│   ├── setup-seafile-mysql.sh
│   └── upgrade
├── seahub-data
│   └── avatars         # for user avatars
├── seahub.db
├── seahub_settings.py   # seahub config file
```

## <a id="wiki-done"></a>Done

At this point, the basic setup of Seafile Professional Server is done. 

You may want to read more about Seafile Professional Server:

- [Setup Seafile Professional Server With Amazon S3](setup_with_mazon_S3.md)
- [FAQ For Seafile Professional Server](FAQ_for_seafile_pro_server.md)

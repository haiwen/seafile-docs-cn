# Migrate from Seafile Community Server
## <a id="wiki-restriction"></a>Restriction ##

It's quite likely you have deployed the Seafile Community Server and want to switch to the Professional Server, or vice versa. But there is some restriction:

- You can only switch between Community Server and Professional Server of the same version.

That is, if you are using Community Server 1.6.0, and want to switch to the Professional Server 1.7.0, you must first upgrade to Community Server 1.7.0, and then follow the guides below to switch to the Professional Server 1.7.0.

## <a id="wiki-preparation"></a>Preparation ##

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

## <a id="wiki-do-migration"></a>Do the migration ##

We assume you have already deployed Seafile Community Server 1.8.0 under `/data/haiwen/seafile-server-1.8.0`. 


### Get the license ###


Put the license you get under the top level directory of your Seafile installation. In our example, it is `/data/haiwen/`.


### <a id="wiki-download-and-uncompress"></a>Download/Uncompress Seafile Professional Server ###

- 32bit
- [64bit](http://seacloud.cc/repo/0a3b015d-d82b-4c89-90b8-b010855bc57b/)


You should uncompress the tarball to the top level directory of your installation, in our example, `/data/haiwen`.

```
tar xf seafile-pro-server_1.8.0_x86-64.tar.gz
```

Now you have:

```
haiwen
├── seafile-license.txt
├── seafile-pro-server-1.8.0/
├── seafile-server-1.8.0/
├── ccnet/
├── seafile-data/
├── seahub-data/
├── seahub.db
└── seahub_settings.py


```

-----------

You should notice the difference between the names of the Community Server and Professional Server. Take the 1.8.0 64bit version as an example:

- Seafile Community Server tarball is `seafile-server_1.8.0_x86-86.tar.gz`; After uncompressing, the folder is `seafile-server-1.8.0`
- Seafile Professional Server tarball is `seafile-pro-server_1.8.0_x86-86.tar.gz`; After uncompressing, the folder is `seafile-pro-server-1.8.0`
    
-----------


### Do the migration ###

- Stop Seafile Community Server if it's running
```
cd haiwen/seafile-server-1.8.0
./seafile.sh stop
./seahub.sh stop
```
- Run the migration script 
```
cd haiwen/seafile-pro-server-1.8.0/
./pro/pro.py setup --migrate
```

The migration script would do the following for you:

- ensure your have all the prerequisites met
- create necessary extra configurations
- update the avatar directory
- create extra database tables  


Now you have:

<blockquote>
haiwen<br/>
├── seafile-license.txt<br/>
├── seafile-pro-server-1.8.0/<br/>
├── seafile-server-1.8.0/<br/>
├── ccnet/<br/>
├── seafile-data/<br/>
├── seahub-data/<br/>
├── seahub.db<br/>
├── seahub_settings.py<br/>
└── <span style="color:green;font-weight:bold;">pro-data/</span><br/>
</blockquote>

### Start Seafile Professional Server ###

```
cd haiwen/seafile-pro-server-1.8.0
./seafile.sh start
./seahub.sh start
```


## <a id="wiki-switch-back"></a>Switch Back to Community Server ##

- Stop Seafile Professional Server if it's running
```
cd haiwen/seafile-pro-server-1.8.0/
./seafile.sh stop
./seahub.sh stop
```
- Update the avatar directory link just like in [Minor Upgrade](https://github.com/haiwen/seafile/wiki/Upgrading-Seafile-Server#minor-upgrade-like-from-150-to-151)
```
cd haiwen/seafile-server-1.8.0/
./upgrade/minor-upgrade.sh
```
- Start Seafile Community Server
```
cd haiwen/seafile-server-1.8.0/
./seafile.sh start
./seahub.sh start
```

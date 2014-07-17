# Linux

#### Preparation

The following list is what you need to install on your development machine. __You should install all of them before you build seafile__.

Package names are according to Ubuntu 12.04. For other Linux distros, please find their corresponding names yourself.

* autoconf/automake/libtool
* libevent-dev ( 2.0 or later )
* libcurl4-openssl-dev  (1.0.0 or later)
* libgtk2.0-dev ( 2.24 or later)
* uuid-dev
* intltool (0.40 or later)
* libsqlite3-dev (3.7 or later)
* valac  (only needed if you build from git repo)
* libjansson-dev
* libqt4-dev
* valac
* cmake
* libfuse-dev (for seafile >= 2.1)
* python-simplejson (for seaf-cli)

```bash
sudo apt-get install autoconf automake libtool libevent-dev libcurl4-openssl-dev libgtk2.0-dev uuid-dev intltool libsqlite3-dev valac libjansson-dev libqt4-dev cmake libfuse-dev
```
For a fresh Fedora 20 installation, the following will install all dependencies via YUM:

```bash
$ sudo yum install wget gcc libevent-devel openssl-devel gtk2-devel libuuid-devel sqlite-devel jansson-devel intltool cmake qt-devel fuse-devel libtool vala gcc-c++
```

#### Building

First you should get the latest source of libsearpc/ccnet/seafile/seafile-client:

Download the source tarball of the latest tag from

- https://github.com/haiwen/libsearpc/tags (use v3.0-latest)
- https://github.com/haiwen/ccnet/tags
- https://github.com/haiwen/seafile/tags
- https://github.com/haiwen/seafile-client/tags

For example, if the latest released seafile client is 3.0.2, then just use the **v3.0.2** tags of the four projects. You should get four tarballs:

- libsearpc-v3.0-latest.tar.gz
- ccnet-3.0.2.tar.gz
- seafile-3.0.2.tar.gz
- seafile-client-3.0.2.tar.gz

```sh
export version=3.0.2
alias wget='wget --content-disposition -nc'
wget https://github.com/haiwen/libsearpc/archive/v3.0-latest.tar.gz
wget https://github.com/haiwen/ccnet/archive/v${version}.tar.gz
wget https://github.com/haiwen/seafile/archive/v${version}.tar.gz
wget https://github.com/haiwen/seafile-client/archive/v${version}.tar.gz
```

Now uncompress them:

```sh
tar xf libsearpc-v3.0-latest.tar.gz
tar xf ccnet-${version}.tar.gz
tar xf seafile-${version}.tar.gz
tar xf seafile-client-${version}.tar.gz
```

To build Seafile client, you need first build **libsearpc** and **ccnet**, **seafile**.

##### set paths
```bash
export PREFIX=/usr
export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH"
export PATH="$PREFIX/bin:$PATH"
```

##### libsearpc

```bash
cd libsearpc-${version}
./autogen.sh
./configure --prefix=$PREFIX
make
sudo make install
```

##### ccnet #####

```bash
cd ccnet-${version}
./autogen.sh
./configure --prefix=$PREFIX
make
sudo make install
```

##### seafile

```bash
cd seafile-${version}/
./autogen.sh
./configure --prefix=$PREFIX --disable-gui
make
sudo make install
```

#### seafile-client

```bash
cd seafile-client-${version}
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$PREFIX .
make
sudo make install
```

#### custom prefix
when installing to a custom ```$PREFIX```, i.e. ```/opt```, you may need a script to set the path variables correctly

```bash
cat >$PREFIX/bin/seafile-applet.sh <<END
#!/bin/bash
export LD_LIBRARY_PATH="$PREFIX/lib:$LD_LIBRARY_PATH"
export PATH="$PREFIX/bin:$PATH"
exec seafile-applet $@
END
cat >$PREFIX/bin/seaf-cli.sh <<END
export LD_LIBRARY_PATH="$PREFIX/lib:$LD_LIBRARY_PATH"
export PATH="$PREFIX/bin:$PATH"
export PYTHONPATH=$PREFIX/lib/python2.7/site-packages
exec seaf-cli $@
END
chmod +x $PREFIX/bin/seafile-applet.sh $PREFIX/bin/seaf-cli.sh
```
you can now start the client with ```$PREFIX/bin/seafile-applet.sh```.


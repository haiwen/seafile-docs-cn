# Setup Develop Environment

## Preparation ##

Package names are according to Ubuntu 12.04. For other Linux distros, please find their corresponding names yourself.

* libevent-dev  (2.0 or later )
* libcurl4-openssl-dev  (1.0.0 or later)
* libglib2.0-dev (2.28 or later)
* uuid-dev
* intltool (0.40 or later)
* libsqlite3-dev (3.7 or later)
* libmysqlclient-dev (5.5 or later)
* libarchive-dev
* libtool
* libjansson-dev
* valac
* libfuse-dev
* python-dateutil

The following libraries need to be compiled from source.

* [libzdb](http://www.tildeslash.com/libzdb/dist/libzdb-2.12.tar.gz)
* [libevhtp](https://github.com/ellzey/libevhtp/archive/1.1.6.zip)

libzdb relies on two packages: <code>re2c</code> and <code>flex</code>.
libevhtp can be build by <code>cmake .; make; sudo make install</code>.  libevhtp's version should be 1.1.6 or 1.1.7.

'''Seahub''' is the web front end of Seafile. It's written in the Django framework. Seahub requires Python 2.6(2.7) installed on your server, and it needs the following python libraries:

* [Django1.5](https://www.djangoproject.com/download/1.5.2/tarball/)
* [Djblets](https://github.com/djblets/djblets/tarball/release-0.6.14)
* sqlite3
* simplejson (python-simplejson)
* PIL (aka. python imaging library, python-image) or Pillow
* chardet


## Download & Compile

Clone [libsearpc](https://github.com/haiwen/libsearpc/), [ccnet](https://github.com/haiwen/ccnet/), [seafile](https://github.com/haiwen/seafile/), [seahub](https://github.com/haiwen/seahub/) to ~/dev (or wherever you want).

Complie libsearpc with

    cd ~/dev/libsearpc
    ./autogen.sh
    ./configure
    make
    make install

Compile ccnet with

    cd ~/dev/ccnet
    ./autogen.sh
    ./configure --disable-client --enable-server   # `export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig` if libsearpc is not found
    make
    make install

Compile seafile with

    cd ~/dev/seafile
    ./autogen.sh
    ./configure --disable-client --enable-server
    make
    make install

## Run seafile

Run seafile with

    cd ~/dev/seafile/tests/basic
    ./seafile.sh 2

Or you can start ccnet, seafile and fileserver manually by:

    ccnet-server -c ~/dev/seafile/test/basic/conf2/ -D all -f -
    seaf-server -c ~/dev/seafile/test/basic/conf2/ -d ~/dev/seafile/test/basic/conf2/seafile-data/ -f -l -
    fileserver -c ~/dev/seafile/test/basic/conf2/ -d ~/dev/seafile/test/basic/conf2/seafile-data/ -f

## Prepare seahub

Go to seahub

    cd ~/dev/seahub

Download django-1.5 to thirdpart. And create and modify setenv.sh from templates

    cp setenv.sh.template setenv.sh

Create database

    . setenv.sh
    python manage.py syncdb

Create admin account (assume seafile is under ~/dev/seafile)

    python tools/seahub-admin.py ~/dev/seafile/tests/basic/conf2

Start seahub

    ./run-seahub.sh.template

# Mac OS X

Setup development environment
-----------------------------

1. Install xcode
2. Install macports

	Modify file `/opt/local/share/macports/Tcl/port1.0/portconfigure.tcl`, change the line

	    default configure.ldflags {-L${prefix}/lib}

	to

        default configure.ldflags {"-L${prefix}/lib -Xlinker -headerpad_max_install_names"}

3. Install following libraries and tools using `port`

	    autoconf，intltool，automake， pkgconfig，libtool，glib2，ossp-uuid，libevent，vala，openssl, git-core

4. Install python

	    port install python27
        port select python python27
        export PATH=/opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin:$PATH

    Then download and install pip from http://pypi.python.org/pypi/pip

5. Set pkg config environment

	    export PKG_CONFIG_PATH=/opt/local/lib/pkgconfig:/usr/local/lib/pkgconfig


Compiling libsearpc
------------------

Download [libsearpc](https://github.com/haiwen/libsearpc), then:

    ./autogen.sh
    LDFLAGS="-Xlinker -headerpad_max_install_names" ./configure
    make
    sudo make install


Compiling ccnet
---------------

Download [ccnet](https://github.com/haiwen/ccnet), then:

    ./autogen.sh
    CFLAGS="-Wall" LDFLAGS="-L/opt/local/lib -Xlinker -headerpad_max_install_names" ./configure
    make
    sudo make install


Compiling seafile
-----------------

1. Download [seafile](https://github.com/haiwen/seafile)
2. Install python libs and tools

	    sudo pip-2.7 install py2app web.py mako simplejson

3. Compile

        ./autogen.sh
        LDFLAGS="-L/opt/local/lib -Xlinker -headerpad_max_install_names -framework CoreServices" ./configure
        make
        sudo make install


Packaging
---------

1. seafileweb. First setup python path:

	    export PYTHONPATH=.:/usr/local/lib/python2.7/site-packages

	This path is where pyccnet and pysearpc installed.

        ./setupmac.sh web

    This will generate `seafileweb.app`, and copy it to `gui/mac/seafile`

2. ccnet, seaf-daemon:

        ./setupmac.sh dylib

    This will copy ccnet, seaf-daemon and other libraries to gui/mac/seafile, and use `install_name_tool` to modify the library paths in ccnet, seaf-daemon.

3. Compile seafile.app：

	    ./setupmac.sh 10.6 or ./setupmac.sh 10.7

    After compiling, it will copy seafile.app to `${top_dir}/../seafile-${VERSION}`. You can also compiling seafile.app in xcode.

4. Go to seafile-${VERSION} and see if it can run correctly.

5. Construct dmg using dropdmg. Use `dmg-backgroud.jpg` as dmg background, add link of `/Application` to seafile-${VERSION}, then packaging seafile-${VERSION} to seafile-${VERSION}.dmg.

Problem you may encounter
-------------------------

1. If `install_name_tool` reports "malformed object" "unknown load command", It may be the version of xcode command line tools incompatible with `install_name_tool`.
2. If xcode can't find glib, Corrects xcode's "build settings/search paths/header search".

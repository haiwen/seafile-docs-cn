# 开机启动 Seafile

Ubuntu 下
---------

Ubuntu
下，我们使用了这个[/etc/init.d/](https://help.ubuntu.com/community/UbuntuBootupHowto)这个脚本来设置
Seafile/Seahub 开机启动.

### 创建**/etc/init.d/seafile-server**脚本

    sudo vim /etc/init.d/seafile-server

脚本内容为: (同时需要修改相应的`user`和`script\_path`字段的值)

    #!/bin/sh

    # 请将 user 改为你的Linux用户名
    user=haiwen

    # 请将 script_dir 改为你的 Seafile 文件安装路径
    seafile_dir=/data/haiwen
    script_path=${seafile_dir}/seafile-server-latest
    seafile_init_log=${seafile_dir}/logs/seafile.init.log
    seahub_init_log=${seafile_dir}/logs/seahub.init.log

    # 若使用 fastcgi, 请将其设置为true
    fastcgi=false
    # fastcgi 端口, 默认为 8000. 
    fastcgi_port=8000

    case "$1" in
            start)
                    sudo -u ${user} ${script_path}/seafile.sh start >> ${seafile_init_log}
                    if [  $fastcgi = true ];
                    then
                            sudo -u ${user} ${script_path}/seahub.sh start-fastcgi ${fastcgi_port} >> ${seahub_init_log}
                    else
                            sudo -u ${user} ${script_path}/seahub.sh start >> ${seahub_init_log}
                    fi
            ;;
            restart)
                    sudo -u ${user} ${script_path}/seafile.sh restart >> ${seafile_init_log}
                    if [  $fastcgi = true ];
                    then
                            sudo -u ${user} ${script_path}/seahub.sh restart-fastcgi ${fastcgi_port} >> ${seahub_init_log}
                    else
                            sudo -u ${user} ${script_path}/seahub.sh restart >> ${seahub_init_log}
                    fi
            ;;
            stop)
                    sudo -u ${user} ${script_path}/seafile.sh $1 >> ${seafile_init_log}
                    sudo -u ${user} ${script_path}/seahub.sh $1 >> ${seahub_init_log}
            ;;
            *)
                    echo "Usage: /etc/init.d/seafile {start|stop|restart}"
                    exit 1
            ;;
    esac

**注意**: 如果你想在 fastcgi 下运行 Seahub,请设置`fastcgi`变量为`true`

### 为日志文件创建目录

     mkdir /path/to/seafile/dir/logs

### 创建**/etc/init/seafile-server.conf**文件

#### 非使用 MySQL

    start on (runlevel [2345])
    stop on (runlevel [016])

    pre-start script
    /etc/init.d/seafile-server start
    end script

    post-stop script
    /etc/init.d/seafile-server stop
    end script

#### 使用 MySQL

    start on (started mysql
    and runlevel [2345])
    stop on (runlevel [016])

    pre-start script
    /etc/init.d/seafile-server start
    end script

    post-stop script
    /etc/init.d/seafile-server stop
    end script

### 设置 seafile-sever 脚本为可执行文件

    sudo chmod +x /etc/init.d/seafile-server

### 完成

在升级 Seafile 服务器后请记得更新`script\_path`的值.

其他 Debian 系的 Linux 下
-------------------------

### 创建脚本**/etc/init.d/seafile-server**

    sudo vim /etc/init.d/seafile-server

脚本内容为: (同时需要修改相应的`user`和`script\_path`字段的值)

    #!/bin/sh

    ### BEGIN INIT INFO
    # Provides:          seafile-server
    # Required-Start:    $local_fs $remote_fs $network
    # Required-Stop:     $local_fs
    # Default-Start:     2 3 4 5
    # Default-Stop:      0 1 6
    # Short-Description: Starts Seafile Server
    # Description:       starts Seafile Server
    ### END INIT INFO

    # 请将 user 改为你的Linux用户名
    user=haiwen

    # 请将 script_path 改为你的 Seafile 文件安装路径
    seafile_dir=/data/haiwen
    script_path=${seafile_dir}/seafile-server-latest
    seafile_init_log=${seafile_dir}/logs/seafile.init.log
    seahub_init_log=${seafile_dir}/logs/seahub.init.log

    # 若使用 fastcgi, 请将其设置为true
    fastcgi=false
    # fastcgi 端口, 默认为 8000. 
    fastcgi_port=8000

    case "$1" in
            start)
                    sudo -u ${user} ${script_path}/seafile.sh start >> ${seafile_init_log}
                    if [  $fastcgi = true ];
                    then
                            sudo -u ${user} ${script_path}/seahub.sh start-fastcgi ${fastcgi_port} >> ${seahub_init_log}
                    else
                            sudo -u ${user} ${script_path}/seahub.sh start >> ${seahub_init_log}
                    fi
            ;;
            restart)
                    sudo -u ${user} ${script_path}/seafile.sh restart >> ${seafile_init_log}
                    if [  $fastcgi = true ];
                    then
                            sudo -u ${user} ${script_path}/seahub.sh restart-fastcgi ${fastcgi_port} >> ${seahub_init_log}
                    else
                            sudo -u ${user} ${script_path}/seahub.sh restart >> ${seahub_init_log}
                    fi
            ;;
            stop)
                    sudo -u ${user} ${script_path}/seafile.sh $1 >> ${seafile_init_log}
                    sudo -u ${user} ${script_path}/seahub.sh $1 >> ${seahub_init_log}
            ;;
            *)
                    echo "Usage: /etc/init.d/seafile {start|stop|restart}"
                    exit 1
            ;;
    esac

**注意**: 如果你想在 fastcgi 下运行 Seahub,请设置`fastcgi`变量为`true`

### 为日志文件创建目录

     mkdir /path/to/seafile/dir/logs

### 设置 seafile-sever 脚本为可执行文件

    sudo chmod +x /etc/init.d/seafile-server

### 在 rc.d 中新增 seafile-server

    sudo update-rc.d seafile-server defaults

### 完成

在升级 Seafile 服务器后请记得更新`script\_path`的值.

RHEL/CentOS 下
--------------

RHEL/CentOS 下,[/etc/rc.local](http://www.centos.org/docs/5/html/Installation_Guide-en-US/s1-boot-init-shutdown-run-boot.html)脚本会随系统开机自动执行,所以我们在这个脚本中设置启动Seafile/Seahub.

-   定位 python(python 2.6 or 2.7)

<!-- -->

    which python2.6 # or "which python2.7"

-   在 /etc/rc.local 脚本中, 将 python2.6(2.7)路径加入到**PATH**字段中,
    并增加 Seafile/Seahub 启动命令

<!-- -->

    `
    # 假设 python 2.6(2.7) 可执行文件在 /usr/local/bin 目录下
    PATH=$PATH:/usr/local/bin/

    # 请将 user 改为你的Linux用户名
    user=haiwen

    # 请将 script_path 改为你的 Seafile 文件安装路径
    seafile_dir=/data/haiwen
    script_path=${seafile_dir}/seafile-server-latest

    sudo -u ${user} ${script_path}/seafile.sh start > /tmp/seafile.init.log 2>&1
    sudo -u ${user} ${script_path}/seahub.sh start > /tmp/seahub.init.log 2>&1

**注意**: 如果你想在fastcgi下启动Seahub,只需将上文中最后一行**"seahub.sh start"**改为**"seahub.sh
start-fastcgi"**

-   完成. 在升级 Seafile 服务器后请记得更新 `script\_pat` 的值.

只使用 RHEL/CentOS 为服务程序（service）下
------------------------------------------

RHEL/CentOS 下 , 我们通过 /etc/init.d/ 脚本将 Seafile/Seahub作为服务程序随开机启动.

### 创建**/etc/sysconfig/seafile**文件

    # 请将 user 改为你的Linux用户名
    user=haiwen

    # 请将 script_path 改为你的 Seafile 文件安装路径
    seafile_dir=/home/haiwen
    script_path=${seafile_dir}/seafile-server-latest
    seafile_init_log=${seafile_dir}/logs/seafile.init.log
    seahub_init_log=${seafile_dir}/logs/seahub.init.log

    # 若使用 fastcgi, 请将其设置true
    fastcgi=false

    # fastcgi 端口, 默认为 8000. 
    fastcgi_port=8000

### 创建**/etc/init.d/seafile**文件

    #!/bin/bash
    #
    # seafile

    #
    # chkconfig: - 68 32
    # description: seafile

    # Source function library.
    . /etc/init.d/functions

    # Source networking configuration.
    . /etc/sysconfig/network

    if [ -f /etc/sysconfig/seafile ];then
            . /etc/sysconfig/seafile
            else
                echo "Config file /etc/sysconfig/seafile not found! Bye."
                exit 200
            fi

    RETVAL=0

    start() {
            # Start daemons.
            echo -n $"Starting seafile: "
            ulimit -n 30000
            su - ${user} -c"${script_path}/seafile.sh start >> ${seafile_init_log} 2>&1"
            RETVAL=$?
            echo
            [ $RETVAL -eq 0 ] && touch /var/lock/subsys/seafile
            return $RETVAL
    }

    stop() {
            echo -n $"Shutting down seafile: "
            su - ${user} -c"${script_path}/seafile.sh stop >> ${seafile_init_log} 2>&1"
            RETVAL=$?
            echo
            [ $RETVAL -eq 0 ] && rm -f /var/lock/subsys/seafile
            return $RETVAL
    }

    # See how we were called.
    case "$1" in
      start)
            start
            ;;
      stop)
            stop
            ;;
      restart|reload)
            stop
            start
            RETVAL=$?
            ;;
      *)
            echo $"Usage: $0 {start|stop|restart}"
            RETVAL=3
    esac

    exit $RETVAL

### 创建**/etc/init.d/seahub**脚本

    #!/bin/bash
    #
    # seahub

    #
    # chkconfig: - 69 31
    # description: seahub

    # Source function library.
    . /etc/init.d/functions

    # Source networking configuration.
    . /etc/sysconfig/network

    if [ -f /etc/sysconfig/seafile ];then
            . /etc/sysconfig/seafile
            else
                echo "Config file /etc/sysconfig/seafile not found! Bye."
                exit 200
            fi

    RETVAL=0

    start() {
            # Start daemons.
            echo -n $"Starting seahub: "
            ulimit -n 30000
            if [  $fastcgi = true ];
                    then
                    su - ${user} -c"${script_path}/seahub.sh start-fastcgi ${fastcgi_port} >> ${seahub_init_log} 2>&1"
                    else
                    su - ${user} -c"${script_path}/seahub.sh start >> ${seahub_init_log} 2>&1"
                    fi
            RETVAL=$?
            echo
            [ $RETVAL -eq 0 ] && touch /var/lock/subsys/seahub
            return $RETVAL
    }

    stop() {
            echo -n $"Shutting down seafile: "
            su - ${user} -c"${script_path}/seahub.sh stop >> ${seahub_init_log} 2>&1"
            RETVAL=$?
            echo
            [ $RETVAL -eq 0 ] && rm -f /var/lock/subsys/seahub
            return $RETVAL
    }

    # See how we were called.
    case "$1" in
      start)
            start
            ;;
      stop)
            stop
            ;;
      restart|reload)
            stop
            start
            RETVAL=$?
            ;;
      *)
            echo $"Usage: $0 {start|stop|restart}"
            RETVAL=3
    esac

    exit $RETVAL

接下来启动服务程序:

    chmod 550 /etc/init.d/seafile
    chmod 550 /etc/init.d/seahub
    chkconfig --add seafile
    chkconfig --add seahub
    chkconfig seahub on
    chkconfig seafile on

执行:

    service seafile start
    service seahub start

### 完成

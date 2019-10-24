# 开机自启动 Seafile

对于运行 systemd 的系统
-----------------------
- 例如 Debian 8 以及更新的版本，Ubuntu 15.04以及更新的版本。

创建 systemd 服务管理文件，将以下示例中 **${seafile\_dir}** 替换为您自己的 **seaile** 安装路径，并且将 **user** 指向真正运行seafile的用户。然后您需要重新加载 systemd 的守护进程：**systemctl daemon-reload**。

### 创建 systemd 服务文件 `/etc/systemd/system/seafile.service`

```
sudo vim /etc/systemd/system/seafile.service
```

文件内容如下：

```
[Unit]
Description=Seafile
# add mysql.service or postgresql.service depending on your database to the line below
After=network.target

[Service]
Type=oneshot
ExecStart=${seafile_dir}/seafile-server-latest/seafile.sh start
ExecStop=${seafile_dir}/seafile-server-latest/seafile.sh stop
RemainAfterExit=yes
User=seafile
Group=seafile

[Install]
WantedBy=multi-user.target
```

### 创建 systemd 服务文件 `/etc/systemd/system/seahub.service`

```
sudo vim /etc/systemd/system/seahub.service
```

文件内容如下(如果你想要运行fastcgi模式，请不要忘记修改它。)

```
[Unit]
Description=Seafile hub
After=network.target seafile.service

[Service]
#add enviornment setting 
Environment="LC_ALL=en_US.UTF-8"    
# change start to start-fastcgi if you want to run fastcgi
ExecStart=${seafile_dir}/seafile-server-latest/seahub.sh start
ExecStop=${seafile_dir}/seafile-server-latest/seahub.sh stop
User=seafile
Group=seafile
Type=oneshot
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

### 创建 systemd 服务文件 `/etc/systemd/system/seafile-client.service` (可选)

只有在你有了 **seafile** 控制台客户端并且希望开机运行此程序时你才需要创建此文件。

```
sudo vim /etc/systemd/system/seafile-client.service
```

文件内容如下：

```
[Unit]
Description=Seafile client
# Uncomment the next line you are running seafile client on the same computer as server
# After=seafile.service
# Or the next one in other case
# After=network.target

[Service]
Type=oneshot
ExecStart=/usr/bin/seaf-cli start
ExecStop=/usr/bin/seaf-cli stop
RemainAfterExit=yes
User=seafile
Group=seafile

[Install]
WantedBy=multi-user.target
```

### 设置服务开机自启动

```
sudo systemctl enable seafile.service
sudo systemctl enable seahub.service
sudo systemctl enable seafile-client.service    # 可选
```

对于使用 init 而非 systemd 的系统
---------------------------------

Ubuntu 14.10 以及更旧的版本
---------------------------

在没有 systemd 的 Ubuntu 系统上，我们使用 [/etc/init.d/](https://help.ubuntu.com/community/UbuntuBootupHowto) 脚本来设置 seafile/seahub 开机自启动。

### 创建一个脚本 **/etc/init.d/seafile-server**

```
sudo vim /etc/init.d/seafile-server
```

脚本内容如下：(你需要根据实际情况修改 **user** 和 **seafile\_dir** 的值)

```
#!/bin/bash
### BEGIN INIT INFO
# Provides:          seafile-server
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Seafile server
# Description:       Start Seafile server
### END INIT INFO

# Change the value of "user" to your linux user name
user=haiwen

# Change the value of "seafile_dir" to your path of seafile installation
# usually the home directory of $user
seafile_dir=/data/haiwen
script_path=${seafile_dir}/seafile-server-latest
seafile_init_log=${seafile_dir}/logs/seafile.init.log
seahub_init_log=${seafile_dir}/logs/seahub.init.log

# Change the value of fastcgi to true if fastcgi is to be used
fastcgi=false
# Set the port of fastcgi, default is 8000. Change it if you need different.
fastcgi_port=8000
#
# Write a polite log message with date and time
#
echo -e "\n \n About to perform $1 for seafile at `date -Iseconds` \n " >> ${seafile_init_log}
echo -e "\n \n About to perform $1 for seahub at `date -Iseconds` \n " >> ${seahub_init_log}
case "$1" in
        start)
                sudo -u ${user} ${script_path}/seafile.sh ${1} >> ${seafile_init_log}
                if [ $fastcgi = true ];
                then
                        sudo -u ${user} ${script_path}/seahub.sh ${1}-fastcgi ${fastcgi_port} >> ${seahub_init_log}
                else
                        sudo -u ${user} ${script_path}/seahub.sh ${1} >> ${seahub_init_log}
                fi
        ;;
        restart)
                sudo -u ${user} ${script_path}/seafile.sh ${1} >> ${seafile_init_log}
                if [ $fastcgi = true ];
                then
                        sudo -u ${user} ${script_path}/seahub.sh ${1}-fastcgi ${fastcgi_port} >> ${seahub_init_log}
                else
                        sudo -u ${user} ${script_path}/seahub.sh ${1} >> ${seahub_init_log}
                fi
        ;;
        stop)
                sudo -u ${user} ${script_path}/seahub.sh ${1} >> ${seahub_init_log}
                sudo -u ${user} ${script_path}/seafile.sh ${1} >> ${seafile_init_log}
        ;;
        *)
                echo "Usage: /etc/init.d/seafile-server {start|stop|restart}"
                exit 1
        ;;
esac
```

**注意：** 如果你正在使用本地 mysql 服务，请将 `# Required-Start:    $remote_fs $syslog` 替换为 `# Required-Start:    $remote_fs $syslog mysql`.

### 确保 seafile-server 脚本可执行

```
sudo chmod +x /etc/init.d/seafile-server
```

### 添加 seafile-server 到 rc.d 中

```
sudo update-rc.d seafile-server defaults
```

**注意：** 如果你更新了你的 seafile 服务，不要忘记更新 **script\_path** 的值。

其他基于 Debian 的发行版
------------------------

### 创建一个脚本 **/etc/init.d/seafile-server**

```
sudo vim /etc/init.d/seafile-server
```

脚本内容如下：(你需要根据实际情况修改 **user** 和 **seafile\_dir** 的值)

```
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

# Change the value of "user" to linux user name who runs seafile
user=haiwen

# Change the value of "seafile_dir" to your path of seafile installation
# usually the home directory of $user
seafile_dir=/data/haiwen
script_path=${seafile_dir}/seafile-server-latest
seafile_init_log=${seafile_dir}/logs/seafile.init.log
seahub_init_log=${seafile_dir}/logs/seahub.init.log

# Change the value of fastcgi to true if fastcgi is to be used
fastcgi=false
# Set the port of fastcgi, default is 8000. Change it if you need different.
fastcgi_port=8000

#
# Write a polite log message with date and time
#
echo -e "\n \n About to perform $1 for seafile at `date -Iseconds` \n " >> ${seafile_init_log}
echo -e "\n \n About to perform $1 for seahub at `date -Iseconds` \n " >> ${seahub_init_log}

case "$1" in
        start)
                sudo -u ${user} ${script_path}/seafile.sh ${1} >> ${seafile_init_log}
                if [ $fastcgi = true ];
                then
                        sudo -u ${user} ${script_path}/seahub.sh ${1}-fastcgi ${fastcgi_port} >> ${seahub_init_log}
                else
                        sudo -u ${user} ${script_path}/seahub.sh ${1} >> ${seahub_init_log}
                fi
        ;;
        restart)
                sudo -u ${user} ${script_path}/seafile.sh ${1} >> ${seafile_init_log}
                if [ $fastcgi = true ];
                then
                        sudo -u ${user} ${script_path}/seahub.sh ${1}-fastcgi ${fastcgi_port} >> ${seahub_init_log}
                else
                        sudo -u ${user} ${script_path}/seahub.sh ${1} >> ${seahub_init_log}
                fi
        ;;
        stop)
                sudo -u ${user} ${script_path}/seahub.sh ${1} >> ${seahub_init_log}
                sudo -u ${user} ${script_path}/seafile.sh ${1} >> ${seafile_init_log}
        ;;
        *)
                echo "Usage: /etc/init.d/seafile-server {start|stop|restart}"
                exit 1
        ;;
esac
```

**注意：**

1. 如果你想要以 fastcgi 模式运行 seahub ,只需要将 **fastcgi** 的值配置为 **true**

2. 如果你是在 MySQL 下部署 Seafile，添加 "mysql" 到 Required-Start 那行：

```
<!-- -->

# Required-Start: $local_fs $remote_fs $network mysql
```

### 为日志添文件加目录

```
mkdir /path/to/seafile/dir/logs
```

### 确保 seafile-server 脚本可执行

```
sudo chmod +x /etc/init.d/seafile-server
```

### 添加 seafile-server 到 rc.d

```
sudo updata-rc.d seafile-server defaults
```

### 完成

如果你更新了你的 seafile 服务，不要忘记更新 **script\_path** 的值。

RHEL/CentOS
-----------

在 RHEL/CentOS 上，脚本 [/etc/re.local](http://www.centos.org/docs/5/html/Installation_Guide-en-US/s1-boot-init-shutdown-run-boot.html) 会在系统启动时被执行，所以可以通过这个脚本来实现 seafile/seahub 开机自启。

-	确定您的 python 版本 (python 2.6 或者 2.7)

```
which python2.6 # 或者 "which python2.7"
```

-	在 /etc/rc.local 中添加 python2.6(2.7) 的目录到 **PATH**,并且添加 seafile/seahub 的启动命令

```
# Assume the python 2.6(2.7) executable is in "/usr/local/bin"
PATH=$PATH:/usr/local/bin/

# Change the value of "user" to your linux user name
user=haiwen

# Change the value of "seafile_dir" to your path of seafile installation
# usually the home directory of $user
seafile_dir=/data/haiwen
script_path=${seafile_dir}/seafile-server-latest

sudo -u ${user} ${script_path}/seafile.sh start > /tmp/seafile.init.log 2>&1
sudo -u ${user} ${script_path}/seahub.sh start > /tmp/seahub.init.log 2>&1
```

**注意：** 如果你想要以 fastcgi 模式启动，只需要将最后一行的 **"seahub.sh start"** 改为 **"seahub.sh start-fastcgi"**

-	完成。如果你更新了你的 seafile 服务，不要忘记更新 **script\_path** 的值。

RHEL/CentOS (run as service)
----------------------------

在 RHEL/CentOS 我们使用 /etc/init.d/ 脚本来实现 seafile/seahub 服务开机自启动。

### 创建文件 **/etc/sysconfig/seafile**

```
# Change the value of "user" to your linux user name
user=haiwen

# Change the value of "seafile_dir" to your path of seafile installation
# usually the home directory of $user
seafile_dir=/data/haiwen
script_path=${seafile_dir}/seafile-server-latest
seafile_init_log=${seafile_dir}/logs/seafile.init.log
seahub_init_log=${seafile_dir}/logs/seahub.init.log

# Change the value of fastcgi to true if fastcgi is to be used
fastcgi=false

# Set the port of fastcgi, default is 8000. Change it if you need different.
fastcgi_port=8000
```

### 创建一个脚本 **/etc/init.d/seafile**

```
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

#
# Write a polite log message with date and time
#
echo -e "\n \n About to perform $1 for seafile at `date -Iseconds` \n " >> ${seafile_init_log}

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
```

### 创建脚本 **/etc/init.d/seahub**

```
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
        echo -n $"Shutting down seahub: "
        su - ${user} -c"${script_path}/seahub.sh stop >> ${seahub_init_log} 2>&1"
        RETVAL=$?
        echo
        [ $RETVAL -eq 0 ] && rm -f /var/lock/subsys/seahub
        return $RETVAL
}

#
# Write a polite log message with date and time
#
echo -e "\n \n About to perform $1 for seahub at `date -Iseconds` \n " >> ${seahub_init_log}

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
```

然后设置开机自启：

```
chmod 550 /etc/init.d/seafile
chmod 550 /etc/init.d/seahub
chkconfig --add seafile
chkconfig --add seahub
chkconfig seahub on
chkconfig seafile on
```

并且运行：

```
service seafile start
service seahub start
```

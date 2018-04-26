# 运行 Clamav 为 daemon 模式

## Ubuntu 16.04 下安装

### 安装clamav-daemon和clamav-freshclam

```
apt-get install clamav-daemon clamav-freshclam
```

### 修改clamd配置文件，建议以root权限运行clamd进程：
/etc/clamav/clamd.conf

```
LocalSocketGroup root
User root
```

### 启动clamav-daemon

```
systemctl start clamav-daemon
```

* 测试Clamd工作效果：

```
clamdscan /dir/PATH
```

## CentOS 7 下安装

### 安装 Clamd 相关组件

```
yum install epel-release
yum install clamav-server clamav-data clamav-filesystem clamav-lib clamav-update clamav clamav-devel
```

### 配置Freshclam

* 按照以下方式配置Freshclam，以定期自动更新病毒库：

```
cp /etc/freshclam.conf /etc/freshclam.conf.bak
sed -i '/^Example/d' /etc/freshclam.conf
```

* 创建一个启动脚本：/usr/lib/systemd/system/clam-freshclam.service

```
# Run the freshclam as daemon
[Unit]
Description = freshclam scanner
After = network.target

[Service]
Type = forking
ExecStart = /usr/bin/freshclam -d -c 4
Restart = on-failure
PrivateTmp = true

[Install]
WantedBy=multi-user.target
```

* 设置开机自启并启动 Freshclam

```
systemctl enable clam-freshclam.service
systemctl start clam-freshclam.service
```

### 配置 Clamd

* 拷贝配置文件模版

```
cp /usr/share/clamav/template/clamd.conf /etc/clamd.conf
```

* 启用配置文件

```
sed -i '/^Example/d' /etc/clamd.conf
```

* 如下所示，修改配置文件中的相应内容

```

User root
LocalSocket /var/run/clamd.sock
...
```

### 运行 Clamd

* 创建启动脚本：/etc/init.d/clamd

```
case "$1" in
  start)
    echo -n "Starting Clam AntiVirus Daemon... "
    /usr/sbin/clamd
    RETVAL=$?
    echo
    [ $RETVAL -eq 0 ] && touch /var/lock/subsys/clamd
    ;;
  stop)
    echo -n "Stopping Clam AntiVirus Daemon... "
    pkill clamd
    rm -f /var/run/clamav/clamd.sock
    rm -f /var/run/clamav/clamd.pid
    RETVAL=$?
    echo
    [ $RETVAL -eq 0 ] && rm -f /var/lock/subsys/clamd
    ;;
esac
```

```
chmod +x /etc/init.d/clamd
```

* 设置开机自启并启动 Clamd

```
chkconfig clamd on
service clamd start
```

* 测试Clamd工作效果：

```
clamdscan /dir/PATH
```

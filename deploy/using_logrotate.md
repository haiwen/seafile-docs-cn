# 在服务器端设置 logrotate

## 工作原理

自 3.1 版本以后，seaf-server 和 ccnet-server 支持通过接收 SIGUR1 信号来管理日志文件。

这个功能在你需要剪切日志文件但是不想关闭服务器的时候非常有用。

> **注意**: 此功能在 Windows 下并不适用

## logrotate 默认配置

对于 Debian, logrotate 默认存储在 ``/etc/logrotate.d/``

## 配置示例

假设你的 ccnet-server 的日志文件是 `/home/haiwen/logs/ccnet.log`, ccnet-server 进程的 pidfile 是 `/home/haiwen/pids/ccnet.pid`.
seaf-server's 的日志文件是 `/home/haiwen/logs/seaf-server.log`, seaf-server 进程的 pidfile 是 `/home/haiwen/pids/seaf-server.pid`:

则请按如下配置 logroate:
```
/home/haiwen/logs/seaf-server.log
{
        daily
        missingok
        rotate 52
        compress
        delaycompress
        notifempty
        sharedscripts
        postrotate
                [ ! -f /home/haiwen/pids/seaf-server.pid ] || kill -USR1 `cat /home/haiwen/pids/seaf-server.pid`
        endscript
}

/home/haiwen/logs/ccnet.log
{
        daily
        missingok
        rotate 52
        compress
        delaycompress
        notifempty
        sharedscripts
        postrotate
                [ ! -f /home/haiwen/pids/ccnet.pid ] || kill -USR1 `cat /home/haiwen/pids/ccnet.pid`
        endscript
}
```

对于 Debian 用户, 可以将以上配置文件存储在 ``/etc/logrotate.d/seafile``

# Set up logrotate for server

## How it works

seaf-server and ccnet-server now (since version 3.1) support reopenning
logfile by receiving SIGUR1 signal.

This feature is very useful when you need cut logfile while you don't want
to shutdown the server programs. All you need to do now is cutting the logfile on
the fly.

> **NOTE**: signal is not supported by windows, so the feature is not available in windows

## Default logrotate configuration directory

For debian, the default directory for logrotate should be ``/etc/logrotate.d/``

## Sample configuration

Assuming your ccnet-server's logfile is `/home/haiwen/logs/ccnet.log`, and your
ccnet-server's pidfile for ccnet-server is ``/home/haiwen/pids/ccnet.pid``.

Assuming your seaf-server's logfile is setup to ``/home/haiwen/logs/seaf-server.log``, and your
seaf-server's pidfile for seaf-server is setup to ``/home/haiwen/pids/seaf-server.pid``:

The configuration for logroate could be like this:
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

You can save this file, for example in debian, to ``/etc/logrotate.d/seafile``

## That's it

You now gets all the things done, just sit and enjoy your time :-D

# 向seafile中导入目录

从seafile专业版5.1.3开始，支持将服务器上的一个本地文件目录导入到seafile中。它是系统管理员从现有的文件服务器(NFS,Samba etc.)中导入文件的便利工具。

要导入一个目录，应该在 seafile-server-laster 目录下使用 `seaf-import.sh` 脚本。

```
usage :
seaf-import.sh
 -p <import dir path, must set>
 -n <repo name, must set>
 -u <repo owner, must set>
```

指定的目录将作为一个资料库被导入到seafile中。你可以设定被导入资料库的名字和所有者。

执行 `./seaf-import.sh -p <dir you want to import> -n <repo name> -u <repo owner>`,

```
Starting seaf-import, please wait ...
[04/26/16 03:36:23] seaf-import.c(79): Import file ./runtime/seahub.pid successfully.
[04/26/16 03:36:23] seaf-import.c(79): Import file ./runtime/error.log successfully.
[04/26/16 03:36:23] seaf-import.c(79): Import file ./runtime/seahub.conf successfully.
[04/26/16 03:36:23] seaf-import.c(79): Import file ./runtime/access.log successfully.
[04/26/16 03:36:23] seaf-import.c(183): Import dir ./runtime/ to repo 5ffb1f43 successfully.
 run done
Done.
```

使用指定的资料库所有者登陆到seafile服务，你将会发现一个指定名称的新资料库。
# NFS 下集群安装

Seafile 集群中，各seafile服务器节点之间数据共享的一个常用方法是使用NFS共享存储。在NFS上共享的对象应该只是文件，这里提供了一个关于如何共享和共享什么的教程。

如何配置NFS服务器和客户端超出了本wiki的范围，提供以下参考文献：

* Ubuntu: https://help.ubuntu.com/community/SettingUpNFSHowTo
* CentOS: http://www.centos.org/docs/5/html/Deployment_Guide-en-US/ch-nfs.html

假设您使用了脚本安装,seafile的安装目录就是 `/opt/seafile` ,该目录下有一个 `seafile-data` 目录。并且，假如您挂载了NFS到 `/seafile-nfs` 目录下，请按照如下几个步骤配置：

* 将 `seafile-data` 目录移动到 `/seafile-nfs` 目录下:

```
mv /opt/seafile/seafile-data /seafile-nfs/
```


* 在集群中的每个节点上，为共享目录 `seafile-data` 设置一个软链接

```
ln -s /seafile-nfs/seafile-data /opt/seafile/seafile-data
```

这样，各seafile实例将共享同一个 `seafile-data` 目录。所有的其他配置文件和日志文件将保持独立。



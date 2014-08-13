# Setup Seafile cluster with NFS

In a Seafile cluster, one common way to share data among the Seafile server instances is to us NFS. You should only share the files objects on NFS. Here we'll provide a tutorial about how and what to share.

How to setup nfs server and client is beyond the scope of this wiki. Here are few references:

* Ubuntu: https://help.ubuntu.com/community/SettingUpNFSHowTo
* CentOS: http://www.centos.org/docs/5/html/Deployment_Guide-en-US/ch-nfs.html

Supposed your seafile server installation directory is `/data/haiwen`, after you run the setup script there should be a `seafile-data` directory in it. And supposed you mount the NFS drive on `/seafile-nfs`, you should follow a few steps:

* Move the `seafile-data` folder to `/seafile-nfs`:

```
mv /data/haiwen/seafile-data /seafile-nfs/
```


* On every node in the cluster, make a symbolic link to the shared seafile-data folder 

```
cd /data/haiwen
ln -s /seafile-nfs/seafile-data /data/haiwen/seafile-data
```


This way the instances will share the same `seafile-data` folder. All other config files and log files will remain independent.

# Setup With Ceph
Ceph is a scalable distributed storage system. Seafile can use Ceph's RADOS object storage layer for storage backend.

## Copy ceph conf file and client keyring

Seafile acts as a client to Ceph/RADOS, so it needs to access ceph cluster's conf file and keyring. You have to copy these files from a ceph admin node's /etc/ceph directory to the seafile machine.

```
seafile-machine# sudo scp user@ceph-admin-node:/etc/ceph/ /etc
```

## Edit seafile configuration

Edit `seafile-data/seafile.conf`, add the following lines:

```
[block_backend]
name = ceph
ceph_config = /etc/ceph/ceph.conf
pool = seafile-blocks
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100

[commit_object_backend]
name = ceph
ceph_config = /etc/ceph/ceph.conf
pool = seafile-commits
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100

[fs_object_backend]
name = ceph
ceph_config = /etc/ceph/ceph.conf
pool = seafile-fs
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100
```

It's recommended to create separate pools for commit, fs, and block objects.

```
ceph-admin-node# rados mkpool seafile-blocks
ceph-admin-node# rados mkpool seafile-commits
ceph-admin-node# rados mkpool seafile-fs
```

## Install and enable memcached

For best performance, Seafile requires install memcached and enable memcache for objects. 

We recommend to allocate 128MB memory for memcached. Edit /etc/memcached.conf

```
# Start with a cap of 64 megs of memory. It's reasonable, and the daemon default
# Note that the daemon will grow to this size, but does not start out holding this much
# memory
# -m 64
-m 128
```

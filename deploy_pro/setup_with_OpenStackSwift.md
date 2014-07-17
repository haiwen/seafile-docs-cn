# Setup With OpenStackSwift
Starting from professional server 2.0.5, Seafile can use S3-compatible cloud storage (such as OpenStack/Swift) as backend. This document will use Swift as example.

## Seafile Server Preparation

To setup Seafile Professional Server with OpenStack Swift:

- Setup the basic Seafile Professional Server following the guide on [[Download and setup Seafile Professional Server]]
- Install the python `boto` library. It's needed to access Swift.
```
sudo easy_install boto
```

For best performance, Seafile requires install memcached and enable memcache for objects. 

We recommend to allocate 128MB memory for memcached. Edit /etc/memcached.conf

```
# Start with a cap of 64 megs of memory. It's reasonable, and the daemon default
# Note that the daemon will grow to this size, but does not start out holding this much
# memory
# -m 64
-m 128
```

## Swift Preparation

You should enable S3 emulation middleware for Swift. For instructions please refer to the following links: 

* http://www.buildcloudstorage.com/2011/11/s3-apis-on-openstack-swift.html
* http://docs.openstack.org/grizzly/openstack-compute/admin/content/configuring-swift-with-s3-emulation-to-use-keystone.html

After successfully setup S3 middleware, you should be able to access it with any S3 clients. The access key id is a user in Swift, and the secret key is the user's password. The next thing you need to do is to create buckets for Seafile. With Python boto library you can do as follows:

```
import boto
import boto.s3.connection

connection = boto.connect_s3(
    aws_access_key_id='swifttest:testuser',
    aws_secret_access_key='testing',
    port=8080,
    host='swift-proxy-server-address',
    is_secure=False,
    calling_format=boto.s3.connection.OrdinaryCallingFormat())
connection.create_bucket('seafile-commits')
connection.create_bucket('seafile-fs')
connection.create_bucket('seafile-blocks')
```

## Modify seafile.conf

Append the following lines to `seafile-data/seafile.conf`

```
[block_backend]
name = s3
bucket = seafile-blocks
key_id = swifttest:testuser
key = testing
host = <swift-proxy-server-address>:8080
path_style_request = true
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100

[commit_object_backend]
name = s3
bucket = seafile-commits
key_id = swifttest:testuser
key = testing
host = <swift-proxy-server-address>:8080
path_style_request = true
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100

[fs_object_backend]
name = s3
bucket = seafile-fs
key_id = swifttest:testuser
key = testing
host = <swift-proxy-server-address>:8080
path_style_request = true
memcached_options = --SERVER=localhost --POOL-MIN=10 --POOL-MAX=100
```

## Run and Test ##

Now you can start Seafile by `./seafile.sh start` and `./seahub.sh start` and visit the website.

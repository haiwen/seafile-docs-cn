# 不同后端数据迁移
seafile支持在文件系统、s3、ceph、swift、阿里云oss等存储后端之间互相迁移数据（swift暂不支持迁出）, 如果你启用了存储后端加密的功能，目前是不能进行数据迁移的。
在不同后端迁移数据需要三个步骤：
1.新建临时 seafile.conf 文件
2.运行迁移脚本
3.替换 seafile.conf

## 新建临时 seafile.conf 文件
创建一个新的 seafile.conf, 填写目的后端的配置 (需要包含 `[block_backend]`, `[commit_object_backend]`, `[fs_object_backend]`), 保存到一个目录下， 如 /opt （此目录需要用户具有读取权限）

   例如，要迁移到阿里云后端：
```
cat > seafile.conf << EOF
[block_backend]
name = oss
key_id = LTAIXX****
key = 4BY7WEN*****
bucket = seafblk
endpoint = oss-cn-shanghai.aliyuncs.com

[commit_object_backend]
name = oss
key_id = LTAIBk*****
key = s6jaAJev******
bucket = seafcomm
endpoint = oss-cn-shanghai.aliyuncs.com

[fs_object_backend]
name = oss
key_id = LTAIr9******
key = K95ajKksD******
bucket = seaffs
endpoint = oss-cn-shanghai.aliyuncs.com
EOF

mv seafile.conf /opt
```
将配置中的 key, bucket 等信息替换成自己的配置

## 运行迁移脚本
假设 seafile 的安装路径为 `~/haiwen`, 进入 `~/haiwen/seafile-server-latest` 目录下， 执行 `migrate.sh`， 参数为新建的 seafile.conf 所在目录，这里为 /opt
```
cd ~/haiwen/seafile-server-latest
./migrate.sh /opt
```

## 替换 seafile.conf
对象迁移完成后， 需要将 seafile.conf 替换成新后端的配置
```
mv /opt/seafile.conf ~/haiwen/conf
```
此时的 seafile.conf 中仅有关于后端的配置， 更多的配置项和配置方法，如 memcache等，可以参考 [这篇文档](https://manual.seafile.com/config/seafile-conf.html) 进行补充。
替换配置文件之后，重启seafile服务，就可以正常访问新后端的数据了。


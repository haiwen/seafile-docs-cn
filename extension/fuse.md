# FUSE扩展

在Seafile系统上文件被分割成数据块，这意味着在你的Seafile服务器上存储的并不是完整的文件而是数据块。这种设计能够方便有效的运用数据去重技术。

然而，有时系统管理员想要直接访问服务器上的文件，你可以使用seaf-fuse来做到这点。

`Seaf-fuse`是一种[FUSE](http://fuse.sourceforge.net)虚拟文件系统的实现. 一句话来说就是，它挂载所有的Seafile文件到一个目录（它被称为'''挂载点''')，所以你可以像访问服务器上的正常目录一样来访问由Seafile服务器管理的所有文件。

```注意:```
* 加密的目录不可以被seaf-fuse来访问。
* Seaf-fuse的当前实现是只读访问，这意味着你不能通过挂载的目录来修改文件。
* 对于debian/centos系统，你需要在“fuse”组才有权限来挂载一个FUSE目录。

### 如何启动seaf-fuse

假设你想挂载到`/data/seafile-fuse`.

#### 创建一个目录作为挂载点

<pre>
mkdir -p /data/seafile-fuse
</pre>

#### 用脚本来启动seaf-fuse

```注意:``` 在启动seaf-fuse之前, 你应该已经通过执行`./seafile.sh start`启动好Seafile服务器。

<pre>
./seaf-fuse.sh start /data/seafile-fuse
</pre>

#### 停止seaf-fuse

<pre>
./seaf-fuse.sh stop
</pre>

### 挂载目录的内容

#### 顶层目录

现在你可以列出`/data/seafile-fuse`目录的内容

<pre>
$ ls -lhp /data/seafile-fuse

drwxr-xr-x 2 root root 4.0K Jan  1  1970 abc@abc.com/
drwxr-xr-x 2 root root 4.0K Jan  1  1970 foo@foo.com/
drwxr-xr-x 2 root root 4.0K Jan  1  1970 plus@plus.com/
drwxr-xr-x 2 root root 4.0K Jan  1  1970 sharp@sharp.com/
drwxr-xr-x 2 root root 4.0K Jan  1  1970 test@test.com/
</pre>

* 顶层目录包含许多子目录，每个子目录对应一个用户
* 文件和目录的时间戳不会被保存

#### 每个用户的目录

<pre>
$ ls -lhp /data/seafile-fuse/abc@abc.com

drwxr-xr-x 2 root root  924 Jan  1  1970 5403ac56-5552-4e31-a4f1-1de4eb889a5f_Photos/
drwxr-xr-x 2 root root 1.6K Jan  1  1970 a09ab9fc-7bd0-49f1-929d-6abeb8491397_My Notes/
</pre>

从上面的列表可以看出，在用户目录下有一些子目录，每个子目录代表此用户的一个资料库，并且以'''{库id}-{库名字}'''的格式来命名。

#### 资料库的目录

<pre>
$ ls -lhp /data/seafile-fuse/abc@abc.com/5403ac56-5552-4e31-a4f1-1de4eb889a5f_Photos/

-rw-r--r-- 1 root root 501K Jan  1  1970 image.png
-rw-r--r-- 1 root root 501K Jan  1  1970 sample.jpng
</pre>

#### 如果出现"Permission denied"的错误

如果你运行`./seaf-fuse.sh start`时，遇到"Permission denied"的错误信息, 很有可能你没有在“fuse用户组”解决方法：

* 把你的用户加到fuse组
<pre>
sudo usermod -a -G fuse <your-user-name>
</pre>

* 退出shell重新登陆
* 现在试着再一次执行`./seaf-fuse.sh start <path>`。


# 存储容量与文件上传/下载大小限制

## 存储容量

可以通过在 `seafile-data/seafile.conf` 文件中增加以下语句，来为所有用户设置默认存储容量（比如，2GB）。

<pre>
[quota]
# 用户存储容量，单位默认为 GB，要求为整数。
default = 2
</pre>

此设置对所有用户有效，如果想为某一用户单独设置，请在管理员界面更改。

## 文件修改历史保存期限 (seafile.conf)

如果你不想保存所有的文件修改历史，可以在 `seafile-data/seafile.conf` 中设置:

<pre>
[history]
# 文件修改历史保存期限（单位为“天”）
keep_days = 10
</pre>

## 文件上传/下载大小限制

在 `seafile-data/seafile.conf` 中:

<pre>
[fileserver]
# 设置最大上传文件为 200M.
max_upload_size=200

# 设置最大下载文件/目录为 200M.
max_download_dir_size=200
</pre>


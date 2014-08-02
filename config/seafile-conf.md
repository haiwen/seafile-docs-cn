# seafile.conf 配置

存储空间容量设置(seafile.conf)
------------------------------

如果你想向所有用户分配存储空间(e.g. 2GB)时 .
你可以在`seafile-data/seafile.conf`文件中增加以下语句

    [quota]
    # 单位为 Gb， 请使用数字
    default = 2

这个设置对所有用户生效. 如果你想对某一特定用户进行容量分配,
请以管理员身份登陆 Seahub 网站, 在**System Admin**页面中进行设置.

默认历史记录设置(seafile.conf)
------------------------------

如果你不想存储所有的文件修改历史,
可以对所有的资料库，设置一个默认的文件修改历史记录。

    [history]
    keep_days = days of history to keep

Seafile fileserver 配置(seafile.conf)
-------------------------------------

可通过`seafile-data/seafile.conf`的`[fileserver]` (3.1 版之前用 `[httpserver]`) 部分对 Seafile
fileserver 进行配置

    [fileserver]
    # fileserver 的 tcp 端口
    port = 8082

更改上传/下载设置.

    [fileserver]
    # 上传文件最大为200M.
    max_upload_size=200

    # 最大下载目录限制为200M.
    max_download_dir_size=200

**注意**: 请重启 Seafile和 Seahub以使修改生效.

    ./seahub.sh restart
    ./seafile.sh restart

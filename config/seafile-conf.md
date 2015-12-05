# seafile.conf 配置

**Note**: Seafile 服务器 5.0.0 之后，所有配置文件都移动到了统一的 **conf** 目录下。 [了解详情](../deploy/new_directory_layout_5_0_0.md).

## 存储空间容量设置

用户默认空间上限

    [quota]
    # 单位为 GB
    default = 2

这个设置对所有用户生效. 如果你想对某一特定用户进行容量分配, 请以管理员身份登陆 Seahub 网站,
在**System Admin**页面中进行设置.

## 默认历史记录设置

对所有的资料库设置一个默认的文件历史保留天数：

    [history]
    keep_days = days of history to keep

## Seafile fileserver

Seafile 监听的端口号 (不要修改该设置)

    [fileserver]
    # Seafile tcp 端口 (不要修改该设置)
    port = 8082

上传/下载大小限制：

    [fileserver]
    # 上传文件最大为200M.
    max_upload_size=200

    # 最大下载目录限制为200M.
    max_download_dir_size=200

## 注意

请重启 Seafile 和 Seahub 以使修改生效：

    ./seahub.sh restart
    ./seafile.sh restart

# ccnet.conf 配置

通过修改`ccnet/ccnet.conf`文件，可以对 Seafile
的网络选项进行设置，示例如下:

    [General]

    # Seafile 服务器端可不设置
    USER_NAME=example

    # 请不要改变这个 ID.
    ID=eb812fd276432eff33bcdde7506f896eb4769da0

    # Seafile 服务器名称, 客户端可见。
    NAME=example

    # Seahub(Seafile Web)外部链接. 客户端可见.
    # 域名部分(i.e., www.example.com)，在文件同步中也会用到.
    # 注意: 外部链接意味着"如果你使用 Nginx, 请使用 Nginx 相关地址"
    SERVICE_URL=http://www.example.com:8000


    [Network]

    # Ccnet 通过此端口监听客户端连接. 如被占用请更改.
    # Seafile 服务器中有效.
    PORT=10001

    [Client]
    # Ccnet 通过此端口监听本地连接（如 Seahub 网站）请求.
    # 此端口如被其他服务占用, Seafile 和 Seahub 将无法正常工作.
    # 如果你想在同一主机上运行 Seafile 和 Seahub, 请改为客户端使用的端口.
    PORT=13419

**注意**: 为使更改生效，请重启 Seafile.

    cd seafile-server
    ./seafile.sh restart

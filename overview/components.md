# Seafile服务器组件

Seafile 包含以下系统组件： 

- Seahub：网站界面，供用户管理自己在服务器上的数据和账户信息。Seafile服务器通过"gunicorn"（一个轻量级的Python HTTP服务器）来提供网站支持。Seahub作为gunicorn的一个应用程序来运行。
- **Seafile server** (``seaf-server``)： 数据服务进程, 处理原始文件的上传/下载/同步。
- **Ccnet server** (``ccnet-server``)： 内部 RPC 服务进程，连接多个组件。
- **Controller**: 监控 ccnet 和 seafile 进程，必要时会重启进程。

下面这张图显示了将 Seafile 部署在 Nginx/Apache 后的架构。

![Seafile Sync](../images/seafile-arch-new-http.png)

- 所有 Seafile 服务都可以配置在 Nginx/Apache 后面，由 Nginx/Apache 提供标准的 http(s) 访问。
- 当用户通过 seahub 访问数据时，seahub 通过 ccnet 提供的内部 RPC 来从 seafile server 获取数据。


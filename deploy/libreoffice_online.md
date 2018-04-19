# Seafile 集成 Collabora Online (LibreOffice Online)

从 Seafile 专业版 6.0.0 开始，可以选择集成 Collabora Online 到 Seafile 系统中以实现 office 文档的在线预览以及在线编辑功能。

## 安装 LibreOffice Online

1. 准备一台安装有 [docker](http://www.docker.com/) 的 Ubuntu 16.04 64位 服务器；

1. 提供一个域名给这个服务器，这里我们使用 *collabora-online.seafile.com*；

1. 获得并且安装一个可用 TLS/SSL 证书到该服务器上，我们使用 [Let’s Encrypt](https://letsencrypt.org/) ；

1. 使用 Nginx 服务代理 collabora online，配置示例如下：

```
server {
    listen       443 ssl;
    server_name  collabora-online.seafile.com;

    ssl_certificate /etc/letsencrypt/live/collabora-online.seafile.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/collabora-online.seafile.com/privkey.pem;

    # static files
    location ^~ /loleaflet {
        proxy_pass https://localhost:9980;
        proxy_set_header Host $http_host;
    }

    # WOPI discovery URL
    location ^~ /hosting/discovery {
        proxy_pass https://localhost:9980;
        proxy_set_header Host $http_host;
    }

    # websockets, download, presentation and image upload
    location ^~ /lool {
        proxy_pass https://localhost:9980;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $http_host;
    }
}
```

1. 然后使用下边的命令来启动 Collabora Online:

```
docker pull collabora/code
docker run -t -p 9980:9980 -e "domain=<your-dot-escaped-domain>" --restart always --cap-add MKNOD collabora/code
```

**注意**：`domain`参数是你的Seafile Server的域名，假如你的Seafile Server的域名是 *demo.seafile.com*，那这个命令应该：

```
docker run -t -p 9980:9980 -e "domain=demo\.seafile\.com" --restart always --cap-add MKNOD collabora/code
```

更多关于Collabora Online的信息和如何部署它请参考 https://www.collaboraoffice.com


## 配置 Seafile

**注意**：你必须在Seafile上 [enable https](../deploy/https_with_nginx.md) 来使用 Collabora Online，如何获得可用的TLS/SSL证书？(我们使用 [Let’s Encrypt](https://letsencrypt.org/))

添加以下配置到seahub_settings.py：

``` python
# From 6.1.0 CE version on, Seafile support viewing/editing **doc**, **ppt**, **xls** files via LibreOffice
# Add this setting to view/edit **doc**, **ppt**, **xls** files
OFFICE_SERVER_TYPE = 'CollaboraOffice'

# Enable LibreOffice Online
ENABLE_OFFICE_WEB_APP = True

# Url of LibreOffice Online's discovery page
# The discovery page tells Seafile how to interact with LibreOffice Online when view file online
# You should change `https://collabora-online.seafile.com/hosting/discovery` to your actual LibreOffice Online server address
OFFICE_WEB_APP_BASE_URL = 'https://collabora-online.seafile.com/hosting/discovery'

# Expiration of WOPI access token
# WOPI access token is a string used by Seafile to determine the file's
# identity and permissions when use LibreOffice Online view it online
# And for security reason, this token should expire after a set time period
WOPI_ACCESS_TOKEN_EXPIRATION = 30 * 60   # seconds

# List of file formats that you want to view through LibreOffice Online
# You can change this value according to your preferences
# And of course you should make sure your LibreOffice Online supports to preview
# the files with the specified extensions
OFFICE_WEB_APP_FILE_EXTENSION = ('odp', 'ods', 'odt', 'xls', 'xlsb', 'xlsm', 'xlsx','ppsx', 'ppt', 'pptm', 'pptx', 'doc', 'docm', 'docx')

# Enable edit files through LibreOffice Online
ENABLE_OFFICE_WEB_APP_EDIT = True

# types of files should be editable through LibreOffice Online
OFFICE_WEB_APP_EDIT_FILE_EXTENSION = ('odp', 'ods', 'odt', 'xls', 'xlsb', 'xlsm', 'xlsx','ppsx', 'ppt', 'pptm', 'pptx', 'doc', 'docm', 'docx')
```

然后重启 Seafile。

在 Seafile Web 界面上点击一个office文件，你将会看到如下页面：

![LibreOffice-online](../images/libreoffice-online.png)

## 问题解决：

了解如何集成工作将帮助你调试问题，当用户访问文件页面时：

1. (seahub->browser) Seahub将生成一个包含iframe的页面，并将其发送到浏览器。
2. (browser->LibreOffice Online) 使用iframe，浏览器将尝试从LibreOffice在线加载文件预览页面。
3. (LibreOffice Online->seahub) LibreOffice Online 接收请求并发送请求到Seahub获取文件内容。
4. (LibreOffice Online->browser) LibreOffice Online 将文件预览页面发送到浏览器。

如果你有问题，请检查Nginx中与Seahub相关的日志和 Collabora Online。
# Apache 2.4 下配置 Seahub

请使用 Apache 2.4 版本

## 准备工作

启用所需要的模块

### 编辑 httpd.conf

首先要编辑你的 httpd.conf 配置文件。添加以下几行到文件末尾处：

```
LoadModule proxy_module modules/mod_proxy.so
LoadModule proxy_fcgi_module modules/mod_proxy_fcgi.so
LoadModule proxy_http_module modules/mod_proxy_http.so
LoadModule rewrite_module modules/mod_rewrite.so
Include conf/extra/httpd-vhosts.conf
```

然后去掉 `DocumentRoot "${SRVROOT}/htdocs"` 这一行配置项。

### Apache 环境下部署 Seahub/FileServer

Seahub 是 Seafile 服务器的网站界面. FileServer 用来处理浏览器端文件的上传与下载. 默认情况下, 它在 8082 端口上监听 HTTP 请求.
这里我们通过 fastcgi 部署 Seahub, 通过反向代理（Reverse Proxy）部署 FileServer. 我们假设你已经将 Seahub 绑定了域名"www.myseafile.com".

修改 Apache 配置文件: (conf/extra/httpd-vhosts.conf)
假设您将 seafile 程序包解压到了 `C:/seafile` 目录下；
首先将 `conf/extra/httpd-vhosts.conf` 文件中的 `<VirtualHost _default_:80>` 配置段去掉；
然后添加以下配置信息到该文件中：

```
<VirtualHost *:80>
    ServerName www.myseafile.com
    DocumentRoot "${SRVROOT}/htdocs"
    Alias /media  "C:/seafile/seafile-server-6.0.7/seahub/media"

    RewriteEngine On

    <Location /media>
        Require all granted
    </Location>

    #
    # seafile fileserver
    #
    ProxyPass /seafhttp http://127.0.0.1:8082
    ProxyPassReverse /seafhttp http://127.0.0.1:8082
    RewriteRule ^/seafhttp - [QSA,L]

    #
    # seahub
    #
    SetEnvIf Request_URI . proxy-fcgi-pathinfo=unescape
    SetEnvIf Authorization "(.*)" HTTP_AUTHORIZATION=$1
    ProxyPass / fcgi://127.0.0.1:8000/
</VirtualHost>
```

#### 修改 seafile/seafile.conf

修改 `seafile/seafile.conf` 中的 `seahub` 配置段，该配置文件在你的seafile安装目录下：

```
[seahub]
port = 8000
fastcgi = true
```

### 修改 SERVICE_URL 和 FILE_SERVER_ROOT

下面还需要更新 SERVICE_URL 和 FILE_SERVER_ROOT 这两个配置项。否则无法通过 Web 正常的上传和下载文件。

5.0 版本开始，您可以直接通过管理员 Web 界面来设置这两个值(注意，如果同时在 Web 界面和配置文件中设置了这个值，以 Web 界面的配置为准。)：

```
SERVICE_URL: http://www.myseafile.com
FILE_SERVER_ROOT: http://www.myseafile.com/seafhttp
```

5.0 版本之前需要修改 ccnet.conf 文件和 seahub_settings.py 文件

#### 修改 ccnet.conf

```
SERVICE_URL = http://www.myseafile.com
```

#### 修改 seahub_settings.py （增加一行，这是一个 python 文件，注意引号）

```
FILE_SERVER_ROOT = 'http://www.myseafile.com/seafhttp'
```

### 重启 seafile 服务和 Apache 服务

配置文件做过修改后，必须重启 seafile 服务和 Apache 服务才能生效。


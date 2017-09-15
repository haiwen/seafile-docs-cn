# Apache 下配置 Seahub

请使用 Apache 2.4 版本。

## 准备工作

安装和启用需要的模块。

在 Ubuntu 系统上可以使用以下命令:

```bash
sudo a2enmod rewrite
sudo a2enmod proxy_http
```

## Apache 环境下部署 Seahub/FileServer

Seahub 是 Seafile 服务器的网站界面. FileServer 用来处理浏览器端文件的上传与下载. 默认情况下, 它在 8082 端口上监听 HTTP 请求.

这里我们通过 fastcgi 部署 Seahub, 通过反向代理（Reverse Proxy）部署 FileServer. 我们假设你已经将 Seahub 绑定了域名"www.myseafile.com".

修改 Apache 配置文件:
(`sites-enabled/000-default`) for ubuntu/debian
(`vhost.conf`) for centos/fedora
```apache
<VirtualHost *:80>
    ServerName www.myseafile.com
    # Use "DocumentRoot /var/www/html" for Centos/Fedora
    # Use "DocumentRoot /var/www" for Ubuntu/Debian
    DocumentRoot /var/www
    Alias /media  /home/user/haiwen/seafile-server-latest/seahub/media

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
    SetEnvIf Authorization "(.*)" HTTP_AUTHORIZATION=$1
    ProxyPass / http://127.0.0.1:8000/
    ProxyPassReverse / http://127.0.0.1:8000/
</VirtualHost>
```

## 修改 SERVICE_URL 和 FILE_SERVER_ROOT

下面还需要更新 SERVICE_URL 和 FILE_SERVER_ROOT 这两个配置项。否则无法通过 Web 正常的上传和下载文件。

5.0 版本开始，您可以直接通过管理员 Web 界面来设置这两个值(注意，如果同时在 Web 界面和配置文件中设置了这个值，以 Web 界面的配置为准。)：
```
SERVICE_URL: http://www.myseafile.com
FILE_SERVER_ROOT: http://www.myseafile.com/seafhttp
```

5.0 版本之前需要修改 ccnet.conf 文件和 seahub_settings.py 文件

### 修改 ccnet.conf

<pre>
SERVICE_URL = http://www.myseafile.com
</pre>

### 修改 seahub_settings.py （增加一行，这是一个 python 文件，注意引号）

```python
FILE_SERVER_ROOT = 'http://www.myseafile.com/seafhttp'
```


## 启动 Seafile 和 Seahub

<pre>
sudo service Apache2 restart
./seafile.sh start
./seahub.sh start # 如果你使用 fastcgi 请使用此命令`./seahub.sh start-fastcgi`
</pre>


## 其他说明

阅读[Seafile 组件](../overview/components.md)会帮你更好的理解 Seafile

在 Seafile 服务器端有两个组件：Seahub 和 FileServer。 FileServer 通过监听 8082 端口处理文件的上传与下载. Seahub 通过监听 8000 端口负责其他的WEB页面。在 https 下, Seahub 应该通过 fastcgi 模式监听 8000 端口 (运行./seahub.sh start-fastcgi). 而且在 fastcgi 模式下, 如果直接访问`http://domain:8000`时，会返回错误页面.

# Apache 下配置 Seahub

## 准备工作

1. Ubuntu 下安装<code>python-flup</code>库:

    <pre>
    sudo apt-get install python-flup
    </pre>

2. Ubuntu 下安装和启用 mod_fastcgi 和 mod_rewrite :

    <pre>
    sudo apt-get install libApache2-mod-fastcgi
    sudo a2enmod rewrite
    sudo a2enmod fastcgi
    </pre>

3. 启用 Apache proxy

    <pre>
    sudo a2enmod proxy_http
    </pre>


## Apache 环境下部署 Seahub/FileServer

Seahub 是 Seafile 服务器的网站界面. FileServer 用来处理浏览器端文件的上传与下载. 默认情况下, 它在 8082 端口上监听 HTTP 请求.

这里我们通过 fastcgi 部署 Seahub, 通过反向代理（Reverse Proxy）部署 FileServer. 我们假设你已经将 Seahub 绑定了域名"www.myseafile.com".

首先编辑你的 Apache 配置文件.根据你的 Linux 版本, 你需要在**文件末尾**增加以下语句:

`Apache2.conf`, for ubuntu/debian:
```
FastCGIExternalServer /var/www/seahub.fcgi -host 127.0.0.1:8000
```

`httpd.conf`, for centos/fedora:
```
FastCGIExternalServer /var/www/html/seahub.fcgi -host 127.0.0.1:8000
```

注意, `seahub.fcgi`只是一个位置标识符, 你并不需要在你的系统中新建这个文件夹.

二, 修改 Apache 配置文件:
(`sites-enabled/000-default`) for ubuntu/debian
(`vhost.conf`) for centos/fedora

```
<VirtualHost *:80>
  ServerName www.myseafile.com
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
  RewriteRule ^/(media.*)$ /$1 [QSA,L,PT]
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteRule ^(.*)$ /seahub.fcgi$1 [QSA,L,E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]
</VirtualHost>
```


## 修改 ccnet.conf 和 seahub_setting.py

### 修改 ccnet.conf

你需要在<code>/data/haiwen/ccnet/ccnet.conf</code>的<code>SERVICE_URL</code>字段中自定义域名。

<pre>
SERVICE_URL = http://www.myseafile.com
</pre>

注意:如果你改变了 Seahub 的域名,也需要同步更改<code>SERVICE_URL</code>.

### 修改 seahub_settings.py

请在<code>seahub_settings.py</code>新增一行，设定`FILE_SERVER_ROOT`的值

```python
FILE_SERVER_ROOT = 'http://www.myseafile.com/seafhttp'
```

## 启动 Seafile 和 Seahub

<pre>
sudo service Apache2 restart
./seafile.sh start
./seahub.sh start-fastcgi
</pre>


## 其他说明

阅读[Seafile 组件](../overview/components.md)会帮你更好的理解 Seafile

在 Seafile 服务器端有两个组件：Seahub 和 FileServer。 FileServer 通过监听 8082 端口处理文件的上传与下载. Seahub 通过监听 8000 端口负责其他的WEB页面。在 https 下, Seahub 应该通过 fastcgi 模式监听 8000 端口 (运行./seahub.sh start-fastcgi). 而且在 fastcgi 模式下, 如果直接访问`http://domain:8000`时，会返回错误页面.

当一个用户访问`https://domain.com/home/my/`时, Apache 接受到访问请求后，通过 fastcgi 将其转发至 Seahub。 可通过以下配置来实现:

    #
    # seahub
    #
    RewriteRule ^/(media.*)$ /$1 [QSA,L,PT]
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteRule ^/(seahub.*)$ /seahub.fcgi/$1 [QSA,L,E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]

和

    FastCGIExternalServer /var/www/seahub.fcgi -host 127.0.0.1:8000


当一个用户在 Seahub 中点击文件下载链接时， Seahub 读取<code>FILE_SERVER_ROOT</code>的值，并将其用户重定向到
`https://domain.com/seafhttp/xxxxx/`。当 Apache 在 `https://domain.com/seafhttp/xxxxx/`接收到访问请求后, 它把请求发送到正在监听 127.0.0.1:8082 的 FileServer 组件, 可通过以下配置来实现:

    ProxyPass /seafhttp http://127.0.0.1:8082
    ProxyPassReverse /seafhttp http://127.0.0.1:8082
    RewriteRule ^/seafhttp - [QSA,L]

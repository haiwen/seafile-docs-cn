# Apache 下启用 Https

通过 OpenSSL 生成 SSL 数字认证
------------------------------

免费 Self-Signed SSL 数字认证用户请看. 如果你是 SSL
付费认证用户可跳过此步.

    openssl genrsa -out privkey.pem 2048
    openssl req -new -x509 -key privkey.pem -out cacert.pem -days 1095

在 Seahub 端启用 https
----------------------

假设你已经按照[Apache 下配置 Seahub](deploy_with_apache.md)对 Apache 进行了相关设置.请启用 mod\_ssl

    [sudo] a2enmod ssl

Windows 下, 你需要在 httpd.conf 中增加 SSL 模块

    LoadModule ssl_module modules/mod_ssl.so

接下来修改你的Apache配置文件，这是示例:

    <VirtualHost *:443>
      ServerName www.myseafile.com
      DocumentRoot /var/www
      Alias /media  /home/user/haiwen/seafile-server-latest/seahub/media

      SSLEngine On
      SSLCertificateFile /path/to/cacert.pem
      SSLCertificateKeyFile /path/to/privkey.pem

      RewriteEngine On

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
      RewriteRule ^(.*)$ /seahub.fcgi/$1 [QSA,L,E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]
    </VirtualHost>

修改相关配置以使用 https
------------------------

### ccnet 配置

因为你想使用 https 而非 http,
你需要修改`ccnet/ccnet.conf`中`SERVICE_URL`字段的值:

    SERVICE_URL = https://www.myseafile.com

### seahub\_settings.py 配置

    FILE_SERVER_ROOT = 'https://www.myseafile.com/seafhttp'

启动Seafile和Seahub
-------------------

    ./seafile.sh start
    ./seahub.sh start-fastcgi

其他说明
--------

阅读[Seafile 组件](../overview/components.md)会帮你更好的理解 Seafile.

在 Seafile 服务器端的两个组件：Seahub 和 FileServer. FileServer 通过监听 8082 端口处理文件的上传与下载. Seahub 通过监听 8000 端口负责其他的WEB页面. 但是在 https 下, Seahub 应该通过 fastcgi 模式监听8000端口 (运行`./seahub.sh start-fastcgi`). 而且在 fastcgi 模式下, 如果直接访问`http://domain:8000`，会返回错误页面.

当一个用户访问`https://domain.com/home/my/`时, Apache 接受到访问请求后，通过 fastcgi 将其转发至 Seahub. 可通过以下配置来实现:

    #
    # seahub
    #
    RewriteRule ^/(media.*)$ /$1 [QSA,L,PT]
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteRule ^/(seahub.*)$ /seahub.fcgi/$1 [QSA,L,E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]

and

    FastCGIExternalServer /var/www/seahub.fcgi -host 127.0.0.1:8000

当一个用户在 Seahub 中点击文件下载链接时， Seahub
读取`FILE_SERVER_ROOT`的值，并将其用户重定向到`https://domain.com/seafhttp/xxxxx/`.`https://domain.com/seafhttp`是`FILE_SERVER_ROOT`的值.  这里,`FILE_SERVER`表示是 Seafile 中只负责文件上传与下载的的 FileServer 组件.

当 Apache
在`https://domain.com/seafhttp/xxxxx/`接收到访问请求后,它把请求发送到正在监听`127.0.0.1:8082`的 FileServer 组件,可通过以下配置来实现:

    ProxyPass /seafhttp http://127.0.0.1:8082
    ProxyPassReverse /seafhttp http://127.0.0.1:8082
    RewriteRule ^/seafhttp - [QSA,L]

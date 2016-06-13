# Apache 下启用 Https

请使用 Apache 2.4 版本。

## 通过 OpenSSL 生成 SSL 数字认证


免费 Self-Signed SSL 数字认证用户请看. 如果你是 SSL 付费认证用户可跳过此步.

    openssl genrsa -out privkey.pem 2048
    openssl req -new -x509 -key privkey.pem -out cacert.pem -days 1095

## 在 Seahub 端启用 https

假设你已经按照[Apache 下配置 Seahub](deploy_with_apache.md)对 Apache 进行了相关设置.请启用  `mod_ssl`

```
    [sudo] a2enmod ssl
```

接下来修改你的 Apache 配置文件，这是示例:

```
<VirtualHost *:443>
  ServerName www.myseafile.com
  DocumentRoot /var/www

  SSLEngine On
  SSLCertificateFile /path/to/cacert.pem
  SSLCertificateKeyFile /path/to/privkey.pem

  Alias /media  /home/user/haiwen/seafile-server-latest/seahub/media

  <Location /media>
    ProxyPass !
    Require all granted
  </Location>

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
  SetEnvIf Request_URI . proxy-fcgi-pathinfo=unescape
  SetEnvIf Authorization "(.*)" HTTP_AUTHORIZATION=$1
  ProxyPass / fcgi://127.0.0.1:8000/
</VirtualHost>
```

## 修改 SERVICE_URL 和 FILE_SERVER_ROOT

下面还需要更新 SERVICE_URL 和 FILE_SERVER_ROOT 这两个配置项。否则无法通过 Web 正常的上传和下载文件。

5.0 版本开始，您可以直接通过管理员 Web 界面来设置这两个值：(注意，如果同时在 Web 界面和配置文件中设置了这个值，以 Web 界面的配置为准。)
```
SERVICE_URL: https://www.myseafile.com
FILE_SERVER_ROOT: https://www.myseafile.com/seafhttp
```


## 启动 Seafile 和 Seahub

    ./seafile.sh start
    ./seahub.sh start-fastcgi

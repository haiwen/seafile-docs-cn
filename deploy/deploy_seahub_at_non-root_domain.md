# 在非根域名下部署 Seahub
这份文档将说明如何在网站的非根文件夹下通过 Apache/Nginx 部署 Seafile。

**注意:** 请先阅读 [Nginx 下配置 Seahub](deploy_with_nginx.md) 或者 [Apache 下配置 Seahub](deploy_with_apache.md).

## Nginx 下部署

首先更改 `seahub_settings.py` 中一些变量的值:

<pre>
SERVE_STATIC = False
MEDIA_URL = '/seafmedia/'
SITE_ROOT = '/seafile/'
</pre>

我们将使用 Nginx 来管理静态文件(js, css, etc), 所以将 <code>SERVE_STATIC</code> 设置为 `False`。

可以自定义 <code>MEDIA_URL</code> 的值，但是确保结尾包含斜线。

因为要在 <code>/seafile/</code> 目录下而不是根目录下部署 Seafile, 所以设置 <code>SITE_ROOT</code> 的值为 <code>/seafile/</code>。

接下来，配置 Nginx 如下:

<pre>
server {
    listen 80;
    server_name www.example.com;
    proxy_set_header X-Forwarded-For $remote_addr;
    location /seafile {
        fastcgi_pass    127.0.0.1:8000;
        fastcgi_param   SCRIPT_FILENAME     $document_root$fastcgi_script_name;
        fastcgi_param   PATH_INFO           $fastcgi_script_name;

        fastcgi_param	SERVER_PROTOCOL	    $server_protocol;
        fastcgi_param   QUERY_STRING        $query_string;
        fastcgi_param   REQUEST_METHOD      $request_method;
        fastcgi_param   CONTENT_TYPE        $content_type;
        fastcgi_param   CONTENT_LENGTH      $content_length;
        fastcgi_param	SERVER_ADDR         $server_addr;
        fastcgi_param	SERVER_PORT         $server_port;
        fastcgi_param	SERVER_NAME         $server_name;
#       fastcgi_param   HTTPS               on; # 如果使用 https，请取消掉这行的注释。
        access_log      /var/log/nginx/seahub.access.log;
    	error_log       /var/log/nginx/seahub.error.log;
    }

    location /seafhttp {
        rewrite ^/seafhttp(.*)$ $1 break;
        proxy_pass http://127.0.0.1:8082;
        client_max_body_size 0;
    }

    location /seafmedia {
        rewrite ^/seafmedia(.*)$ /media$1 break;
        root /home/user/haiwen/seafile-server-latest/seahub;
    }
}
</pre>

接下来设置 `SERVICE_URL` 和 `FILE_SERVER_ROOT` 的值。

## Apache 下部署

首先更改 `seahub_settings.py` 中一些变量的值:

<pre>
SERVE_STATIC = False
MEDIA_URL = '/seafmedia/'
SITE_ROOT = '/seafile/'
</pre>

在 `httpd.conf` 文件中加入以下语句:
<pre>
  FastCGIExternalServer /var/www/seahub.fcgi -host 127.0.0.1:8000
</pre>
接下来配置 Apache，示例如下:

<pre>
<VirtualHost *:80>
  ServerName www.example.com
  DocumentRoot /var/www
  Alias /seafmedia  /home/user/haiwen/seafile-server-2.0.2/seahub/media

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
  RewriteRule ^/(seafmedia.*)$ /$1 [QSA,L,PT]
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteRule ^/(seafile.*)$ /seahub.fcgi/$1 [QSA,L,E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]
</VirtualHost>
</pre>

请注意更改 Alias 的值为自己的文件路径。

## 更改 ccnet.conf 和 seahub_setting.py

### 更改 ccnet.conf

为使 Seafile 知道你所使用的域名，请更改 <code>/data/haiwen/ccnet/ccnet.conf</code> 中 <code>SERVICE_URL</code> 变量的值。

<pre>
SERVICE_URL = http://www.myseafile.com/seafile
</pre>

注意: 如果以后域名有所变动，请记得更改 <code>SERVICE_URL</code>.

### 更改 seahub_settings.py

更改 `seahub_settings.py` 中 `FILE_SERVER_ROOT` 的值

```python
FILE_SERVER_ROOT = 'http://www.myseafile.com/seafhttp'
```

## 启动 Seafile 和 Seahub

<pre>
./seafile.sh start
./seahub.sh start-fastcgi
</pre>

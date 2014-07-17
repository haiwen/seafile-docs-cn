# Deploy Seahub at Non-root domain
This documentation will talk about how to deploy Seafile Web using Apache/Nginx at Non-root directory of the website(e.g., www.example.com/seafile/).

**Note:** We assume you have read [[Deploy Seafile with nginx]] or [[Deploy Seafile with apache]].

## Deploy with Nginx

First, we need to overwrite some variables in seahub_settings.py:

<pre>
SERVE_STATIC = False
MEDIA_URL = '/seafmedia/'
SITE_ROOT = '/seafile/'
</pre>

We will use Nginx to serve static files(js, css, etc), so we just disable <code>SERVE_STATIC</code>.

<code>MEDIA_URL</code> can be anything you like, just make sure a trailing slash is appended at the end.

We deploy Seafile at <code>/seafile/</code> directory instead of root directory, so we set <code>SITE_ROOT</code> to <code>/seafile/</code>.

Then, we need to configure the Nginx:

<pre>
server {
    listen 80;
    server_name www.example.com;
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
#       fastcgi_param   HTTPS               on; # enable this line only if https is used
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

You need also to modify `SERVICE_URL` and `HTTP_SERVER_ROOT` (see below).

## Deploy with Apache

First, you need to modify seahub_settings.py as above.

Then edit httpd.conf file, add this line:
<pre>
  FastCGIExternalServer /var/www/seahub.fcgi -host 127.0.0.1:8000
</pre>
After that, you need to configure your Apache, here is the sample configuration:

<pre>
<VirtualHost *:80>
  ServerName www.example.com
  DocumentRoot /var/www
  Alias /seafmedia  /home/user/haiwen/seafile-server-2.0.2/seahub/media

  RewriteEngine On

  #
  # seafile httpserver
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

We use Alias to let Apache serve static files, please change the second argument to your path.

## Modify ccnet.conf and seahub_setting.py

### Modify ccnet.conf

You need to modify the value of <code>SERVICE_URL</code> in <code>/data/haiwen/ccnet/ccnet.conf</code>
to let Seafile know the domain you choose.

<pre>
SERVICE_URL = http://www.myseafile.com/seafile
</pre>

Note: If you later change the domain assigned to seahub, you also need to change the value of  <code>SERVICE_URL</code>.

### Modify seahub_settings.py

You need to add a line in <code>seahub_settings.py</code> to set the value of `HTTP_SERVER_ROOT`

```python
HTTP_SERVER_ROOT = 'http://www.myseafile.com/seafhttp'
```

## Start Seafile and Seahub

<pre>
./seafile.sh start
./seahub.sh start-fastcgi
</pre>

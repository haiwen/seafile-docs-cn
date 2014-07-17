# Enabling Https with Nginx

Here we use self-signed SSL digital certificate for free. If you use a paid ssl certificate from some authority, just skip the first step.

### Generate SSL digital certificate with OpenSSL
```bash
    openssl genrsa -out privkey.pem 2048
    openssl req -new -x509 -key privkey.pem -out cacert.pem -days 1095
```

### Enable SSL module of Nginx (optional)
If your Nginx does not support SSL, you need to recompile it, the commands are as follows:
```bash
    ./configure --with-http_stub_status_module --with-http_ssl_module
    make && make install
```

### Modify Nginx configuration file

Assume you have configured nginx as
[Deploy-Seafile-with-nginx](deploy_with_nginx.md). To use https, you need to modify your nginx configuration file.
```nginx
    server {
        listen       80;
        server_name  www.yourdoamin.com;
        rewrite ^ https://$http_host$request_uri? permanent;	# force redirect http to https
    }

    server {
        listen 443;
        ssl on;
        ssl_certificate /etc/ssl/cacert.pem;	# path to your cacert.pem
        ssl_certificate_key /etc/ssl/privkey.pem;	# path to your privkey.pem
        server_name www.yourdoamin.com;
        # ......
        fastcgi_param   HTTPS               on;
        fastcgi_param   HTTP_SCHEME         https;
    }
```


### Sample configuration file

Here is the sample configuration file:

```nginx
    server {
        listen       80;
        server_name  www.yourdoamin.com;
        rewrite ^ https://$http_host$request_uri? permanent;	# force redirect http to https
    }
    server {
        listen 443;
        ssl on;
        ssl_certificate /etc/ssl/cacert.pem;            # path to your cacert.pem
        ssl_certificate_key /etc/ssl/privkey.pem;	# path to your privkey.pem
        server_name www.yourdoamin.com;
        location / {
            fastcgi_pass    127.0.0.1:8000;
            fastcgi_param   SCRIPT_FILENAME     $document_root$fastcgi_script_name;
            fastcgi_param   PATH_INFO           $fastcgi_script_name;

            fastcgi_param   SERVER_PROTOCOL	$server_protocol;
            fastcgi_param   QUERY_STRING        $query_string;
            fastcgi_param   REQUEST_METHOD      $request_method;
            fastcgi_param   CONTENT_TYPE        $content_type;
            fastcgi_param   CONTENT_LENGTH      $content_length;
            fastcgi_param   SERVER_ADDR         $server_addr;
            fastcgi_param   SERVER_PORT         $server_port;
            fastcgi_param   SERVER_NAME         $server_name;
            fastcgi_param   HTTPS               on;
            fastcgi_param   HTTP_SCHEME         https;

            access_log      /var/log/nginx/seahub.access.log;
    	    error_log       /var/log/nginx/seahub.error.log;
        }
        location /seafhttp {
            rewrite ^/seafhttp(.*)$ $1 break;
            proxy_pass http://127.0.0.1:8082;
            client_max_body_size 0;
        }
        location /media {
            root /home/user/haiwen/seafile-server-latest/seahub;
        }
    }
```

### Reload Nginx
```bash
    nginx -s reload
```

## Modify settings to use https

### ccnet conf

Since you change from http to https, you need to modify the value of "SERVICE_URL" in <code>ccnet/ccnet.conf</code>:
```bash
SERVICE_URL = https://www.yourdomain.com
```

### seahub_settings.py

At the end of the file, add a line:

```python
HTTP_SERVER_ROOT = 'https://www.yourdomain.com/seafhttp'
```

## Start Seafile and Seahub

```bash
./seafile.sh start
./seahub.sh start-fastcgi
```

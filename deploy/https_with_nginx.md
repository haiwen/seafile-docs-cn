# Nginx 下启用 Https

## 在 Seahub 端启用 https

免费 Self-Signed SSL 数字认证用户请看. 如果你是 SSL 付费认证用户可跳过此步.

### 通过 OpenSSL 生成 SSL 数字认证

    openssl genrsa -out privkey.pem 2048
    openssl req -new -x509 -key privkey.pem -out cacert.pem -days 1095


### 修改 Nginx 配置文件

请修改 nginx 配置文件以使用 HTTPS：
```
server {
    listen       80;
    server_name  seafile.example.com;
    rewrite ^ https://$http_host$request_uri? permanent;    # force redirect http to https

    # Enables or disables emitting nginx version on error pages and in the "Server" response header field.
    server_tokens off;
}

server {
    listen 443;
    ssl on;
    ssl_certificate /etc/ssl/cacert.pem;        # path to your cacert.pem
    ssl_certificate_key /etc/ssl/privkey.pem;    # path to your privkey.pem
    server_name seafile.example.com;
    server_tokens off;
    # ......
    proxy_pass         http://127.0.0.1:8000;
    proxy_set_header   Host $host;
    proxy_set_header   X-Real-IP $remote_addr;
    proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header   X-Forwarded-Host $server_name;
    proxy_set_header   X-Forwarded-Proto https;

    proxy_read_timeout  1200s;
}
```

### 配置文件示例

这里是配置文件示例:

```
server {
    listen       80;
    server_name  seafile.example.com;
    rewrite ^ https://$http_host$request_uri? permanent;	#强制将http重定向到https
    server_tokens off;
}
server {
    listen 443;
    ssl on;
    ssl_certificate /etc/ssl/cacert.pem;        #cacert.pem 文件路径
    ssl_certificate_key /etc/ssl/privkey.pem;	#privkey.pem 文件路径
    server_name seafile.example.com;
    ssl_session_timeout 5m;
    ssl_session_cache shared:SSL:5m;

    # Diffie-Hellman parameter for DHE ciphersuites, recommended 2048 bits
    ssl_dhparam /etc/nginx/dhparam.pem;

    # secure settings (A+ at SSL Labs ssltest at time of writing)
    # see https://wiki.mozilla.org/Security/Server_Side_TLS#Nginx
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-SHA256:DHE-RSA-AES256-SHA:DHE-RSA-CAMELLIA256-SHA:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-RSA-SEED-SHA:DHE-RSA-CAMELLIA128-SHA:HIGH:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!SRP:!DSS';
    ssl_prefer_server_ciphers on;

    proxy_set_header X-Forwarded-For $remote_addr;

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";
    server_tokens off;

    location / {
        proxy_pass         http://127.0.0.1:8000;
        proxy_set_header   Host $host;
        proxy_set_header   X-Real-IP $remote_addr;
        proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Host $server_name;
        proxy_set_header   X-Forwarded-Proto https;

        access_log      /var/log/nginx/seahub.access.log;
        error_log       /var/log/nginx/seahub.error.log;

        proxy_read_timeout  1200s;

        client_max_body_size 0;
    }

# 如果你使用 fastcgi 请使用此配置
#
#    location / {
#        fastcgi_pass    127.0.0.1:8000;
#        fastcgi_param   SCRIPT_FILENAME     $document_root$fastcgi_script_name;
#        fastcgi_param   PATH_INFO           $fastcgi_script_name;
#
#        fastcgi_param   SERVER_PROTOCOL     $server_protocol;
#        fastcgi_param   QUERY_STRING        $query_string;
#        fastcgi_param   REQUEST_METHOD      $request_method;
#        fastcgi_param   CONTENT_TYPE        $content_type;
#        fastcgi_param   CONTENT_LENGTH      $content_length;
#        fastcgi_param   SERVER_ADDR         $server_addr;
#        fastcgi_param   SERVER_PORT         $server_port;
#        fastcgi_param   SERVER_NAME         $server_name;
#        fastcgi_param   REMOTE_ADDR         $remote_addr;
#        fastcgi_read_timeout 36000;
#
#        client_max_body_size 0;
#
#        access_log      /var/log/nginx/seahub.access.log;
#        error_log       /var/log/nginx/seahub.error.log;
#    }

    location /seafhttp {
        rewrite ^/seafhttp(.*)$ $1 break;
        proxy_pass http://127.0.0.1:8082;
        client_max_body_size 0;
        proxy_connect_timeout  36000s;
        proxy_read_timeout  36000s;
        proxy_send_timeout  36000s;
        send_timeout  36000s;
    }
    location /media {
        root /home/user/haiwen/seafile-server-latest/seahub;
    }
}
```

### 重新加载 Nginx

    nginx -s reload


## 修改 SERVICE_URL 和 FILE_SERVER_ROOT

下面还需要更新 SERVICE_URL 和 FILE_SERVER_ROOT 这两个配置项。否则无法通过 Web 正常的上传和下载文件。

5.0 版本开始，您可以直接通过管理员 Web 界面来设置这两个值 (注意，如果同时在 Web 界面和配置文件中设置了这个值，以 Web 界面的配置为准。)：
```
SERVICE_URL: https://www.myseafile.com
FILE_SERVER_ROOT: https://www.myseafile.com/seafhttp
```

## 启动 Seafile 和 Seahub
```
./seafile.sh start
./seahub.sh start # 如果你使用 fastcgi 请使用此命令`./seahub.sh start-fastcgi`
```

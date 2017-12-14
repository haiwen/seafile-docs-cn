# Nginx 下配置 Seahub

## Nginx 环境下部署 Seahub/SeafServer

Seahub 是 Seafile 服务器的网站界面. SeafServer 用来处理浏览器端文件的上传与下载. 默认情况下, 它在 8082 端口上监听 HTTP 请求.

这里我们通过反向代理（Reverse Proxy）部署 SeafServer. 我们假设你已经将 Seahub 绑定了域名"www.myseafile.com".

下面是一个 Nginx 配置文件的例子。

Ubuntu 下你可以

1. 创建文件 /etc/nginx/site-available/seafile.conf，并拷贝以下内容
2. 删除 /etc/nginx/site-enabled/default: `rm /etc/nginx/site-enabled/default`
3. 创建符号链接: `ln -s /etc/nginx/sites-available/seafile.conf /etc/nginx/sites-enabled/seafile.conf`

```
server {
    listen 80;
    server_name seafile.example.com;

    proxy_set_header X-Forwarded-For $remote_addr;

    location / {
         proxy_pass         http://127.0.0.1:8000;
         proxy_set_header   Host $host;
         proxy_set_header   X-Real-IP $remote_addr;
         proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
         proxy_set_header   X-Forwarded-Host $server_name;
         proxy_read_timeout  1200s;

         # used for view/edit office file via Office Online Server
         client_max_body_size 0;

         access_log      /var/log/nginx/seahub.access.log;
         error_log       /var/log/nginx/seahub.error.log;
    }

# If you are using [FastCGI](http://en.wikipedia.org/wiki/FastCGI),
# which is not recommended, you should use the following config for location `/`.
#
#    location / {
#         fastcgi_pass    127.0.0.1:8000;
#         fastcgi_param   SCRIPT_FILENAME     $document_root$fastcgi_script_name;
#         fastcgi_param   PATH_INFO           $fastcgi_script_name;
#
#         fastcgi_param     SERVER_PROTOCOL     $server_protocol;
#         fastcgi_param   QUERY_STRING        $query_string;
#         fastcgi_param   REQUEST_METHOD      $request_method;
#         fastcgi_param   CONTENT_TYPE        $content_type;
#         fastcgi_param   CONTENT_LENGTH      $content_length;
#         fastcgi_param     SERVER_ADDR         $server_addr;
#         fastcgi_param     SERVER_PORT         $server_port;
#         fastcgi_param     SERVER_NAME         $server_name;
#         fastcgi_param   REMOTE_ADDR         $remote_addr;
#          fastcgi_read_timeout 36000;
#
#         client_max_body_size 0;
#
#         access_log      /var/log/nginx/seahub.access.log;
#          error_log       /var/log/nginx/seahub.error.log;
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

Nginx 默认设置 "client_max_body_size" 为 1M。如果上传文件大于这个值的话，会报错，相关 HTTP 状态码为 423 ("Request Entity Too Large"). 你可以将值设为 <code>0</code> 以禁用此功能.

如果要上传大于 4GB 的文件，默认情况下 Nginx 会把整个文件存在一个临时文件中，然后发给上游服务器 (seaf-server)，这样容易出错。使用 1.8.0 以上版本同时在 Nginx 配置文件中设置以下内容能解决这个问题：

```
    location /seafhttp {
        ... ...
        proxy_request_buffering off;
    }
```

## 修改 SERVICE_URL 和 FILE_SERVER_ROOT

下面还需要更新 SERVICE_URL 和 FILE_SERVER_ROOT 这两个配置项。否则无法通过 Web 正常的上传和下载文件。

5.0 版本开始，您可以直接通过管理员 Web 界面来设置这两个值 (注意，如果同时在 Web 界面和配置文件中设置了这个值，以 Web 界面的配置为准。)：
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
./seafile.sh start
./seahub.sh start-fastcgi
./seahub.sh start # 如果你使用 fastcgi 请使用此命令`./seahub.sh start-fastcgi`
</pre>

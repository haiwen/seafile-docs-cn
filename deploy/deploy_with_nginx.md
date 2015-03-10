# Nginx 下配置 Seahub

## 准备工作

Ubuntu 下安装<code>python-flup</code>库:
 
```
sudo apt-get install python-flup
```

## Nginx 环境下部署 Seahub/SeafServer 

Seahub 是 Seafile 服务器的网站界面. SeafServer 用来处理浏览器端文件的上传与下载. 默认情况下, 它在 8082 端口上监听 HTTP 请求. 

这里我们通过 fastcgi 部署 Seahub, 通过反向代理（Reverse Proxy）部署 SeafServer. 我们假设你已经将 Seahub 绑定了域名"www.myseafile.com". 

这是一个 Nginx 配置文件的例子 (你可以创建文件 /etc/nginx/conf.d/seafile.conf， 并拷贝以下内容, 如果你用 gedit 编辑，别忘了删除 seafile.conf~ 这个临时文件).

<pre>
server {
    listen 80;
    server_name www.myseafile.com;

    proxy_set_header X-Forwarded-For $remote_addr;

    location / {
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
        fastcgi_param   REMOTE_ADDR         $remote_addr;

        access_log      /var/log/nginx/seahub.access.log;
    	error_log       /var/log/nginx/seahub.error.log;
    }

    location /seafhttp {
        rewrite ^/seafhttp(.*)$ $1 break;
        proxy_pass http://127.0.0.1:8082;
        client_max_body_size 0;
        proxy_connect_timeout  36000s;
        proxy_read_timeout  36000s;
    }

    location /media {
        root /home/user/haiwen/seafile-server-latest/seahub;
    }
}
</pre>

Nginx 默认设置 "client_max_body_size" 为 1M。如果上传文件大于这个值的话，会报错，相关 HTTP 状态码为 423 ("Request Entity Too Large"). 你可以将值设为 <code>0</code> 以禁用此功能.

## 修改 ccnet.conf 和 seahub_setting.py

### 修改 ccnet.conf

你需要在<code>/data/haiwen/ccnet/ccnet.conf</code>的<code>SERVICE_URL</code>字段中自定义域名。

<pre>
SERVICE_URL = http://www.myseafile.com
</pre>

注意:如果你改变了 Seahub的域名,也需要同步更改<code>SERVICE_URL</code>.

### 修改 seahub_settings.py

请在<code>seahub_settings.py</code>新增一行，设定`FILE_SERVER_ROOT`的值

```python
FILE_SERVER_ROOT = 'http://www.myseafile.com/seafhttp'
```

## 启动 Seafile 和 Seahub

<pre>
./seafile.sh start
./seahub.sh start-fastcgi
</pre>


# Nginx 下启用 Https

在 Seahub 端启用 https
----------------------

免费 Self-Signed SSL 数字认证用户请看. 如果你是 SSL 付费认证用户可跳过此步.

### 通过 OpenSS L生成 SSL 数字认证

    openssl genrsa -out privkey.pem 2048
    openssl req -new -x509 -key privkey.pem -out cacert.pem -days 1095


### 修改 Nginx 配置文件

假设你已经按照[[在Nginx环境下部署Seafile]]对 nginx 进行了相关设置. 请修改 nginx 配置文件以使用 HTTPS.

    server {
      listen       80;
      server_name  www.yourdoamin.com; 
      rewrite ^ https://$http_host$request_uri? permanent;	#强制将http重定向到https
    }

    server {
      listen 443;
      ssl on;
      ssl_certificate /etc/ssl/cacert.pem;	#cacert.pem 文件路径
      ssl_certificate_key /etc/ssl/privkey.pem;	#privkey.pem 文件路径
      server_name www.yourdoamin.com;    
      # ......
      fastcgi_param   HTTPS               on;
      fastcgi_param   HTTP_SCHEME         https;
    }

### 配置文件示例

这里是配置文件示例:

    server {
      listen       80;
      server_name  www.yourdoamin.com;
      rewrite ^ https://$http_host$request_uri? permanent;	#强制将http重定向到https
    }
    server {
      listen 443;
      ssl on;
      ssl_certificate /etc/ssl/cacert.pem;            #cacert.pem 文件路径
      ssl_certificate_key /etc/ssl/privkey.pem;	#privkey.pem 文件路径
      server_name www.yourdoamin.com;    
      proxy_set_header X-Forwarded-For $remote_addr;
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
          proxy_connect_timeout  36000s;
          proxy_read_timeout  36000s;
      }
      location /media {
          root /home/user/haiwen/seafile-server-latest/seahub;
      }
    }

### 重新加载 Nginx

    nginx -s reload

修改相关配置以使用 https
------------------------

### ccnet 配置

因为你想使用 https 而非 http,
你需要修改`ccnet/ccnet.conf`中**SERVICE\_URL**字段的值:

    SERVICE_URL = https://www.yourdomain.com

### seahub\_settings.py 配置

    FILE_SERVER_ROOT = 'https://www.yourdomain.com/seafhttp'

启动 Seafile 和 Seahub
----------------------

    ./seafile.sh start
    ./seahub.sh start-fastcgi

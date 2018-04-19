# OnlyOffice 集成

从 6.1.0+ (包括开源版) 版本开始，Seafile 支持集成[OnlyOffice](https://www.onlyoffice.com/)来在线编辑和预览office文档。
要想使用 OnlyOffice，你必须先部署一个 OnlyOffice 服务。

**关于集群**

在集群部署中，我们建议在另一个子域中专门部署一台DocumentServer主机或一个DocumentServer集群。
从技术上来讲，如果负载均衡器可以调度文件夹，它也可以通过子文件夹来工作。

**对于大多数用户，我们建议将documentserver部署为docker镜像，并使用一个子文件夹来提供**

这么做的好处：
- 不需要依赖额外的服务器
- 不需要依赖额外的子域
- 不需要依赖额外的ssl证书
- 部署方便快捷
- 维护简单


## 通过子域部署DocumentServer
URL 示例：https://onlyoffice.domain.com

- 子域
- 子域的DNS解析记录
- SSL证书

我们建议您使用[ONLYOFFICE/Docker-DocumentServer](https://github.com/ONLYOFFICE/Docker-DocumentServer)来简单快速的进行子域安装。只需要遵循这个OnlyOffice文档指南。

### 测试 DocumentServer 是否在运行
安装过程完成后，访问这个页面来确保您的 OnlyOffice 工作正常：```http{s}://{your Seafile Server's domain or IP}/welcome```，您将会在这个页面中得到**Document Server is running**。

### 配置Seafile服务
添加以下配置信息到`seahub_settings.py`。

```
# Enable Only Office
ENABLE_ONLYOFFICE = True
VERIFY_ONLYOFFICE_CERTIFICATE = False
ONLYOFFICE_APIJS_URL = 'http{s}://{your OnlyOffice server's domain or IP}/web-apps/apps/api/documents/api.js'
ONLYOFFICE_FILE_EXTENSION = ('doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx', 'odt', 'fodt', 'odp', 'fodp', 'ods', 'fods')
ONLYOFFICE_EDIT_FILE_EXTENSION = ('docx', 'pptx', 'xlsx')
```

然后重启Seafile服务

```
./seafile.sh restart
./seahub.sh restart

# or
service seafile-server restart
```

当您点击一个文档您应该会看到一个新的预览页面。

## 通过子文件夹部署DocumentServer
URL 示例：https://seafile.domain.com/onlyofficeds

- 通过已存在的 Seafile 服务的域名代理到本地的子文件夹
- 通过 Seafile 服务域名的SSL链接，不需要依赖额外的证书！

**如果不是绝对需要，请不要更改子文件夹!**

**```/onlyoffice/```不能作为Seafile 和 Document服务之间的通信路径来使用！**

以下指南说明了如何在本地部署一个OnlyOffice Document服务。

*它基于["ONLYOFFICE/Docker-DocumentServer" documentation](https://github.com/ONLYOFFICE/Docker-DocumentServer).*

**要求** 只适用于通过Docker部署OnlyOffice DocumentServer
https://github.com/ONLYOFFICE/Docker-DocumentServer#recommended-system-requirements

### 安装Docker

[Ubuntu](https://docs.docker.com/engine/installation/linux/ubuntu/), [Debian](https://docs.docker.com/engine/installation/linux/debian/), [CentOS](https://docs.docker.com/engine/installation/linux/centos/)

### 部署 OnlyOffice DocumentServer Docker 镜像
这里下载并部署DocumentServer监听在本地88端口。

Debian 8
```
docker run -i -t -d -p 88:80 --restart=always --name oods onlyoffice/documentserver
```

Ubuntu 16.04
```
docker run -dit -p 88:80 --restart always --name oods onlyoffice/documentserver
```

*在CentOS 7上没有任何确认，您可以尝试以上任何一个命令，他们也可以工作。*

**示例:具有内存限制的Debian  Docker容器**

在Debian 8中，您首先需要更改grub配置中的一些设置，以支持docker的内存限制。
```
# 编辑 /etc/default/grub
# 添加以下配置项
GRUB_CMDLINE_LINUX_DEFAULT="cgroup_enable=memory swapaccount=1"

# 更新Grub2并重启
update-grub2 && reboot
```

现在您可以在启动docker时设置内存大小限制。

`docker run -i -t -d -p 88:80 --restart=always --memory "6g" --memory-swap="6g" --name oods onlyoffice/documentserver`

*这些限制超过了建议的最小限制(4G RAM/2GB SWAP)因此当多个用户编辑文档时DocumentServer's的性能保持不变。Docker SWAP不同于服务器 SWAP，点击[Docker文档](https://docs.docker.com/engine/admin/resource_constraints/)。*

**Docker 文档**

如果你有任何疑问请查看[Docker文档](https://docs.docker.com/engine/reference/run/)。

[自动运行docker镜像](https://docs.docker.com/engine/admin/start-containers-automatically/)。

如果你希望限制docker使用的资源请查看[Docker文档](https://docs.docker.com/engine/admin/resource_constraints/)。

### 配置 webserver
#### 配置 Nginx

添加以下配置到你的seafile的nginx配置中(e.g.`/etc/nginx/conf.d/seafile.conf`)的`searver`配置段以外。将为DocumentServer定义这些变量以在子文件夹中工作。

```
# Required for only office document server
map $http_x_forwarded_proto $the_scheme {
        default $http_x_forwarded_proto;
        "" $scheme;
    }

map $http_x_forwarded_host $the_host {
        default $http_x_forwarded_host;
        "" $host;
    }

map $http_upgrade $proxy_connection {
        default upgrade;
        "" close;
    }
```


添加以下配置到你的seafile的nginx配置中(e.g.`/etc/nginx/conf.d/seafile.conf`)的`searver`配置段下。
```

...   
location /onlyofficeds/ {

        # THIS ONE IS IMPORTANT ! - Trailing slash !
        proxy_pass http://{your Seafile server's domain or IP}:88/;

        proxy_http_version 1.1;
        client_max_body_size 100M; # Limit Document size to 100MB
        proxy_read_timeout 3600s;
        proxy_connect_timeout 3600s;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $proxy_connection;

        # THIS ONE IS IMPORTANT ! - Subfolder and NO trailing slash !
        proxy_set_header X-Forwarded-Host $the_host/onlyofficeds;

        proxy_set_header X-Forwarded-Proto $the_scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	}
...
```

#### 配置Apache

添加以下配置到你的seafile apache配置文件中(e.g. ```sites-enabled/seafile.conf```)的```<VirtualHost >```配置段以外。

```
...

LoadModule authn_core_module modules/mod_authn_core.so
LoadModule authz_core_module modules/mod_authz_core.so
LoadModule unixd_module modules/mod_unixd.so
LoadModule proxy_module modules/mod_proxy.so
LoadModule proxy_http_module modules/mod_proxy_http.so
LoadModule proxy_wstunnel_module modules/mod_proxy_wstunnel.so
LoadModule headers_module modules/mod_headers.so
LoadModule setenvif_module modules/mod_setenvif.so

<IfModule unixd_module>
  User daemon
  Group daemon
</IfModule>

...
```

添加以下配置到你的seafile apache配置文件中(e.g. ```sites-enabled/seafile.conf```)的```<VirtualHost >```配置段的末尾。

```
...

Define VPATH /onlyofficeds
Define DS_ADDRESS {your Seafile server's domain or IP}:88

...

<Location ${VPATH}>
  Require all granted
  SetEnvIf Host "^(.*)$" THE_HOST=$1
  RequestHeader setifempty X-Forwarded-Proto http
  RequestHeader setifempty X-Forwarded-Host %{THE_HOST}e
  RequestHeader edit X-Forwarded-Host (.*) $1${VPATH}
  ProxyAddHeaders Off
  ProxyPass "http://${DS_ADDRESS}/"
  ProxyPassReverse "http://${DS_ADDRESS}/"
</Location>

...
```

### 测试DocumentServer正在通过子文件夹运行

当安装过程完成后，访问这个页面确保你部署的OnlyOffice工作正常：`http{s}://{your Seafile Server's domain or IP}/{your subdolder}/welcome`，你将会在这个页面中得到**Document Server is running**。

### 配置seafile服务

添加以下配置项到`seahub_settings.py`:

```python
# Enable Only Office
ENABLE_ONLYOFFICE = True
VERIFY_ONLYOFFICE_CERTIFICATE = True
ONLYOFFICE_APIJS_URL = 'http{s}://{your Seafile server's domain or IP}/{your subdolder}/web-apps/apps/api/documents/api.js'
ONLYOFFICE_FILE_EXTENSION = ('doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx', 'odt', 'fodt', 'odp', 'fodp', 'ods', 'fods')
ONLYOFFICE_EDIT_FILE_EXTENSION = ('docx', 'pptx', 'xlsx')
```

然后重启seafile服务。

```
./seafile.sh restart
./seahub.sh restart

# or
service seafile-server restart
```

当你点击一个文档时你应该看到一个新的预览页面。

### 完整的nginx配置示例

基于Seafile Server V6.1包含子文件夹方式部署OnlyOffice DocumentServer的完整nginx配置文件(e.g. ```/etc/nginx/conf.d/seafile.conf```)示例：

```
# Required for OnlyOffice DocumentServer
map $http_x_forwarded_proto $the_scheme {
	default $http_x_forwarded_proto;
	"" $scheme;
}

map $http_x_forwarded_host $the_host {
	default $http_x_forwarded_host;
	"" $host;
}

map $http_upgrade $proxy_connection {
	default upgrade;
	"" close;
}

server {
        listen       80;
        server_name  seafile.domain.com;
        rewrite ^ https://$http_host$request_uri? permanent;    # force redirect http to https
        server_tokens off;
}

server {
        listen 443 http2;
        ssl on;
        ssl_certificate /etc/ssl/cacert.pem;        # path to your cacert.pem
        ssl_certificate_key /etc/ssl/privkey.pem;    # path to your privkey.pem
        server_name seafile.domain.com;
        proxy_set_header X-Forwarded-For $remote_addr;
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";
        server_tokens off;

    #
    # seahub
    #
    location / {
        fastcgi_pass    127.0.0.1:8000;
        fastcgi_param   SCRIPT_FILENAME     $document_root$fastcgi_script_name;
        fastcgi_param   PATH_INFO           $fastcgi_script_name;

        fastcgi_param   SERVER_PROTOCOL        $server_protocol;
        fastcgi_param   QUERY_STRING        $query_string;
        fastcgi_param   REQUEST_METHOD      $request_method;
        fastcgi_param   CONTENT_TYPE        $content_type;
        fastcgi_param   CONTENT_LENGTH      $content_length;
        fastcgi_param   SERVER_ADDR         $server_addr;
        fastcgi_param   SERVER_PORT         $server_port;
        fastcgi_param   SERVER_NAME         $server_name;
        fastcgi_param   REMOTE_ADDR         $remote_addr;
        fastcgi_param   HTTPS               on;
        fastcgi_param   HTTP_SCHEME         https;

        access_log      /var/log/nginx/seahub.access.log;
        error_log       /var/log/nginx/seahub.error.log;
        fastcgi_read_timeout 36000;
        client_max_body_size 0;
    }

    #
    # seafile
    #
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

    #
    # seafdav (webdav)
    #
    location /seafdav {
        fastcgi_pass    127.0.0.1:8080;
        fastcgi_param   SCRIPT_FILENAME     $document_root$fastcgi_script_name;
        fastcgi_param   PATH_INFO           $fastcgi_script_name;
        fastcgi_param   SERVER_PROTOCOL     $server_protocol;
        fastcgi_param   QUERY_STRING        $query_string;
        fastcgi_param   REQUEST_METHOD      $request_method;
        fastcgi_param   CONTENT_TYPE        $content_type;
        fastcgi_param   CONTENT_LENGTH      $content_length;
        fastcgi_param   SERVER_ADDR         $server_addr;
        fastcgi_param   SERVER_PORT         $server_port;
        fastcgi_param   SERVER_NAME         $server_name;
        fastcgi_param   HTTPS               on;
        client_max_body_size 0;
        access_log      /var/log/nginx/seafdav.access.log;
        error_log       /var/log/nginx/seafdav.error.log;
    }
    
    #
    # onlyofficeds
    #
    location /onlyofficeds/ {
        # IMPORTANT ! - Trailing slash !
        proxy_pass http://127.0.0.1:88/;
		
        proxy_http_version 1.1;
        client_max_body_size 100M; # Limit Document size to 100MB
        proxy_read_timeout 3600s;
        proxy_connect_timeout 3600s;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $proxy_connection;

        # IMPORTANT ! - Subfolder and NO trailing slash !
        proxy_set_header X-Forwarded-Host $the_host/onlyofficeds;
		
        proxy_set_header X-Forwarded-Proto $the_scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

### 完整的Apache配置示例

```
LoadModule authn_core_module modules/mod_authn_core.so
LoadModule authz_core_module modules/mod_authz_core.so
LoadModule unixd_module modules/mod_unixd.so
LoadModule proxy_module modules/mod_proxy.so
LoadModule proxy_http_module modules/mod_proxy_http.so
LoadModule proxy_wstunnel_module modules/mod_proxy_wstunnel.so
LoadModule headers_module modules/mod_headers.so
LoadModule setenvif_module modules/mod_setenvif.so
LoadModule ssl_module modules/mod_ssl.so

<IfModule unixd_module>
  User daemon
  Group daemon
</IfModule>

<VirtualHost *:80>
    ServerName seafile.domain.com
    ServerAlias domain.com
    Redirect permanent / https://seafile.domain.com
</VirtualHost>

<VirtualHost *:443>
  ServerName seafile.domain.com
  DocumentRoot /var/www

  SSLEngine On
  SSLCertificateFile /etc/ssl/cacert.pem
  SSLCertificateKeyFile /etc/ssl/privkey.pem
  
  ## Strong SSL Security
  ## https://raymii.org/s/tutorials/Strong_SSL_Security_On_Apache2.html

  SSLCipherSuite EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:ECDHE-RSA-AES128-SHA:DHE-RSA-AES128-GCM-SHA256:AES256+EDH:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA:DES-CBC3-SHA:HIGH:!aNULL:!eNULL:!EXPORT:!DES:!MD5:!PSK:!RC4
  SSLProtocol All -SSLv2 -SSLv3
  SSLCompression off
  SSLHonorCipherOrder on

  Alias /media  /home/user/haiwen/seafile-server-latest/seahub/media

  <Location /media>
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
  
  #
  # onlyofficeds
  #
  Define VPATH /onlyofficeds
  Define DS_ADDRESS {your Seafile server's domain or IP}:88
  
  <Location ${VPATH}>
  Require all granted
  SetEnvIf Host "^(.*)$" THE_HOST=$1
  RequestHeader setifempty X-Forwarded-Proto http
  RequestHeader setifempty X-Forwarded-Host %{THE_HOST}e
  RequestHeader edit X-Forwarded-Host (.*) $1${VPATH}
  ProxyAddHeaders Off
  ProxyPass "http://${DS_ADDRESS}/"
  ProxyPassReverse "http://${DS_ADDRESS}/"
  </Location>
  
</VirtualHost>
```
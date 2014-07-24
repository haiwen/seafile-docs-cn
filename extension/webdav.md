# WebDAV扩展

Seafile WebDAV Server(SeafDAV)在Seafile Server 2.1.0版本中被加入.

在下面的维基中, 我们假设你将Seafile安装到`/data/haiwen`目录下。

## SeafDAV配置

SeafDAV配置文件是`/data/haiwen/conf/seafdav.conf`. 如果它还没有被创建，你可以自行创建它。

<pre>
[WEBDAV]

# 默认值是false。改为true来使用SeafDAV server。
enabled = true

port = 8080

# 如果fastcgi将被使用则更改fastcgi的值为true。
fastcgi = false

# 如果你将seafdav部署到nginx/apache，你需要更改“share_name”的值。
share_name = /
</pre>

每次配置文件被修改后，你需要重启Seafile服务器使之生效。

<pre>
./seafile.sh restart
</pre>


### 示例配置 1: No nginx/apache

你的WebDAV客户端将在地址<code>http://example.com:8080</code>访问WebDAV服务器。

<pre>
[WEBDAV]
enabled = true
port = 8080
fastcgi = false
share_name = /
</pre>

### 示例配置 2: With Nginx/Apache

你的WebDAV客户端将在地址<code>http://example.com/seafdav</code>访问WebDAV服务器。

<pre>
[WEBDAV]
enabled = true
port = 8080
fastcgi = true
share_name = /seafdav
</pre>

在上面的配置中，'''share_name'''的值被改为'''/seafdav''', 它是你指定给seafdav服务器的地址后缀。


#### Nginx 无 HTTPS

相应的Nginx配置如下 (无 https):

<pre>
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

        access_log      /var/log/nginx/seafdav.access.log;
        error_log       /var/log/nginx/seafdav.error.log;
    }
</pre>

#### Nginx 有 HTTPS

Nginx配置为https:

<pre>
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

        access_log      /var/log/nginx/seafdav.access.log;
        error_log       /var/log/nginx/seafdav.error.log;
    }
</pre>

#### Apache

首先编辑 <code>apache2.conf</code> 文件, 添加如下这行到文件结尾(或者根据你的Linux发行版将其添加到 <code>httpd.conf</code>):

<pre>
FastCGIExternalServer /var/www/seafdav.fcgi -host 127.0.0.1:8080
</pre>

注意, <code>/var/www/seafdav.fcgi</code> 仅仅只是一个占位符, 实际在你的系统并不需要有此文件。

第二, 修改Apache配置文件 (site-enabled/000-default):

#### Apache 无 HTTPS

根据你的Apache配置当你[将要部署 Seafile 和 Apache|已经部署 Seafile 和 Apache], 加入Seafdav的相关配置:

<pre>
<VirtualHost *:80>

ServerName www.myseafile.com
  DocumentRoot /var/www
  Alias /media  /home/user/haiwen/seafile-server/seahub/media

  RewriteEngine On

  #
  # seafile fileserver
  #
  ProxyPass /seafhttp http://127.0.0.1:8082
  ProxyPassReverse /seafhttp http://127.0.0.1:8082
  RewriteRule ^/seafhttp - [QSA,L]

  #
  # seafile webdav
  #
  RewriteCond %{HTTP:Authorization} (.+)
  RewriteRule ^(/seafdav.*)$ /seafdav.fcgi$1 [QSA,L,e=HTTP_AUTHORIZATION:%1]
  RewriteRule ^(/seafdav.*)$ /seafdav.fcgi$1 [QSA,L]

  #
  # seahub
  #
  RewriteRule ^/(media.*)$ /$1 [QSA,L,PT]
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteRule ^(.*)$ /seahub.fcgi$1 [QSA,L,E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]

</virtualhost>
</pre>

#### Apache 有 HTTPS

根据你的apache配置当你[配置Seafile网站和Apache并启用Https](../deploy/https_with_apache.md), 加入seafdav的相关配置:

<pre>
<VirtualHost *:443>

ServerName www.myseafile.com
  DocumentRoot /var/www
  Alias /media  /home/user/haiwen/seafile-server/seahub/media

  SSLEngine On
  SSLCertificateFile /etc/ssl/cacert.pem
  SSLCertificateKeyFile /etc/ssl/privkey.pem

  RewriteEngine On

  #
  # seafile fileserver
  #
  ProxyPass /seafhttp http://127.0.0.1:8082
  ProxyPassReverse /seafhttp http://127.0.0.1:8082
  RewriteRule ^/seafhttp - [QSA,L]

  #
  # seafile webdav
  #
  RewriteCond %{HTTP:Authorization} (.+)
  RewriteRule ^(/seafdav.*)$ /seafdav.fcgi$1 [QSA,L,e=HTTP_AUTHORIZATION:%1]
  RewriteRule ^(/seafdav.*)$ /seafdav.fcgi$1 [QSA,L]

  #
  # seahub
  #
  RewriteRule ^/(media.*)$ /$1 [QSA,L,PT]
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteRule ^(.*)$ /seahub.fcgi$1 [QSA,L,E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]

</virtualhost>
</pre>

## 关于客户端的注意事项

### Windows

在Windows平台，我们推荐使用webdav客户端软件例如Cyberduck或BitKinex.
webdav对于Windows浏览器的支持实现并不是十分可用，因为：

```
Windows 浏览器需要利用HTTP数字认证。但是由于Seafile在服务器端不存储纯文本密码，所以它不支持这个特性。HTTP基本认证只被HTTPS支持（这是合理的）。但是浏览器不支持自我签署的证书。
```

结论就是如果你有一个合法的ssl证书，你应该能过通过Windows浏览器来访问seafdav。否则你应该使用客户端软件。Windows XP被声明不支持HTTPS webdav.

### Linux

在Linux平台你有更多的选择。你可以利用文件管理器例如Nautilus来连接webdav服务器，或者在命令行使用davfs2。

使用davfs2

<pre>
sudo apt-get install davfs2
sudo mount -t davfs -o uid=<username> https://example.com/seafdav /media/seafdav/
</pre>

-o选项设置挂载目录的拥有者为<username>，使得非root用户拥有可写权限。

我们建议对于davfs2，禁用锁操作。你需要编辑/etc/davfs2/davfs2.conf

<pre>
 use_locks       0
</pre>

### Mac OS X

Finder对于WebDAV的支持不稳定而且较慢. 所以我们建议使用webdav客户端软件如Cyberduck.

## 常见问题

### 客户端无法连接seafdav服务器

默认, seafdav是未被启用的。检查你是否在<code>seafdav.conf</code>中设置<code>enabled = true</code>。 
如果没有，更改配置文件并重启seafle服务器。


### 客户端得到"Error: 404 Not Found"错误

如果你将SeafDAV部署在Nginx/Apache, 请确保像上面的配置文件一样更改<code>share_name</code>的值。重启Seafile服务器后重新测试。

# WebDAV extension

Seafile WebDAV Server(SeafDAV) is added in seafile server 2.1.0.

In the wiki below, we assume your seafile installation folder is `/data/haiwen`.

## SeafDAV Configuration

The configuration file is `/data/haiwen/conf/seafdav.conf`. If it is not created already, you can just create the file.

<pre>
[WEBDAV]

# Default is false. Change it to true to enable SeafDAV server.
enabled = true

port = 8080

# Change the value of fastcgi to true if fastcgi is to be used
fastcgi = false

# If you deploy seafdav behind nginx/apache, you need to modify "share_name".
share_name = /
</pre>

Every time the configuration is modified, you need to restart seafile server to make it take effect.

<pre>
./seafile.sh restart
</pre>


### Sample Configuration 1: No nginx/apache

Your WebDAV client would visit the Seafile WebDAV server at <code>http://example.com:8080</code>

<pre>
[WEBDAV]
enabled = true
port = 8080
fastcgi = false
share_name = /
</pre>

### Sample Configuration 2: With Nginx/Apache

Your WebDAV client would visit the Seafile WebDAV server at <code>http://example.com/seafdav</code>

<pre>
[WEBDAV]
enabled = true
port = 8080
fastcgi = true
share_name = /seafdav
</pre>

In the above config, the value of '''share_name''' is changed to '''/seafdav''', which is the address suffix you assign to seafdav server.


#### Nginx without HTTPS

The corresponding Nginx configuration is (without https):

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

#### Nginx with HTTPS

Nginx conf with https:

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

First edit <code>apache2.conf</code> file, add this line to the end of the file (or add it to <code>httpd.conf</code> depending on your Linux distro):

<pre>
FastCGIExternalServer /var/www/seafdav.fcgi -host 127.0.0.1:8080
</pre>

Note, <code>/var/www/seafdav.fcgi</code> is just a placeholder, you don't need to actually have this file in your system.

Second, modify Apache config file (site-enabled/000-default):

#### Apache without HTTPS

Based on your apache configuration when you [[Deploy Seafile with apache|deployed seafile with Apache]], add seafdav related config:

<pre>
<VirtualHost *:80>

ServerName www.myseafile.com
  DocumentRoot /var/www
  Alias /media  /home/user/haiwen/seafile-server/seahub/media

  RewriteEngine On

  #
  # seafile httpserver
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

#### Apache with HTTPS

Based on your apache configuration when you [Enable Https on Seafile web with Apache](../deploy/https_with_apache.md), add seafdav related config:

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
  # seafile httpserver
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

## Notes on Clients

### Windows

On Windows it is recommended to use a webdav client software such as Cyberduck or BitKinex.
The implementation of webdav support in Windows explorer is not very usable since:

```
Windows explorer requires to use HTTP digest authentication. But Seafile can't support this because it doesn't store plain text passwords on the server. HTTP basic authentication is only supported for HTTPS (which is reasonable). But explorer doesn't accept self-signed certificates.
```

The conclusion is if you have a valid ssl certificate, you should be able to access seafdav from Windows explorer. Otherwise you should use a client software. It's also reported that Windows XP doesn't support HTTPS webdav.

### Linux

On Linux you have more choices. You can use file manager such as Nautilus to connect to webdav server. Or you can use davfs2 from the command line.

To use davfs2

<pre>
sudo apt-get install davfs2
sudo mount -t davfs -o uid=<username> https://example.com/seafdav /media/seafdav/
</pre>

The -o option sets the owner of the mounted directory to <username> so that it's writable for non-root users.

It's recommended to disable LOCK operation for davfs2. You have to edit /etc/davfs2/davfs2.conf

<pre>
 use_locks       0
</pre>

### Mac OS X

Finder's support for WebDAV is also not very stable and slow. So it is recommended to use a webdav client software such as Cyberduck.

## Frequently Asked Questions

### Clients can't connect to seafdav sersver

By default, seafdav is disabled. Check whether you have <code>enabled = true</code> in <code>seafdav.conf</code>.
If not, modify it and restart seafile server.


### The client gets "Error: 404 Not Found"

If you deploy SeafDAV behind Nginx/Apache, make sure to change the value of <code>share_name</code> as the sample configuration above. Restart your seafile server and try again.



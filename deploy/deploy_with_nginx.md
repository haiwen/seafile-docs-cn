# Config Seahub with Nginx

## Prepare

Install <code>python-flup</code> library. On Ubuntu:

```
sudo apt-get install python-flup
```

## Deploy Seahub/HttpServer with Nginx

Seahub is the web interface of Seafile server. HttpServer is used to handle raw file uploading/downloading through browsers. By default, it listens on port 8082 for HTTP request.

Here we deploy Seahub using [FastCGI](http://en.wikipedia.org/wiki/FastCGI), and deploy HttpServer with reverse proxy. We assume you are running Seahub using domain '''www.myseafile.com'''.

This is a sample Nginx config file.

<pre>
server {
    listen 80;
    server_name www.myseafile.com;
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
    }

    location /media {
        root /home/user/haiwen/seafile-server-latest/seahub;
    }
}
</pre>

Nginx settings "client_max_body_size" is by default 1M. Uploading a file bigger than this limit will give you an error message HTTP error code 413 ("Request Entity Too Large").

You should use 0 to disable this feature or write the same value than for the parameter max_upload_size in section [httpserver] of /seafile/seafile-data/seafile.conf

## Modify ccnet.conf and seahub_setting.py

### Modify ccnet.conf

You need to modify the value of <code>SERVICE_URL</code> in <code>/data/haiwen/ccnet/ccnet.conf</code>
to let Seafile know the domain you choose.

<pre>
SERVICE_URL = http://www.myseafile.com
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

## Notes when Upgrading Seafile Server

When [[upgrading seafile server]], besides the normal steps you should take, there is one extra step to do: '''Update the path of the static files in your nginx/apache configuration'''. For example, assume your are upgrading seafile server 1.3.0 to 1.4.0, then:

<pre>
    location /media {
        root /home/user/haiwen/seafile-server-1.4.0/seahub;
    }
</pre>

**Tip:**
You can create a symbolic link <code>seafile-server-latest</code>, and make it point to your current seafile server folder (Since seafile server 2.1.0, the <code>setup-seafile.sh</code> script will do this for your). Then, each time you run a upgrade script, it would update the <code>seafile-server-latest</code> symbolic link to keep it always point to the latest version seafile server folder.

In this case, you can write:

<pre>
    location /media {
        root /home/user/haiwen/seafile-server-latest/seahub;
    }
</pre>

This way, you no longer need to update the nginx config file each time you upgrade your seafile server.

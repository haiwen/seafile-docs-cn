# HAproxy 下启用 Https

请确保您已经获取了有效的证书文件。HAproxy所需证书文件格式比较特殊，要求为pem格式，且同时包含证书和与之匹配的私钥,可使用以下命令使之合并：
	```
	cat demo.crt demo.key > demo.pem
	```

## 修改 HAproxy 配置文件

配置示例：`/etc/haproxy/haproxy.cfg`
（假设用于健康状态检测的端口为12345）

```
global
    log 127.0.0.1 local1 notice
    maxconn 4096
    user haproxy
    group haproxy

defaults
    log global
    mode http
    retries 3
    maxconn 2000
    timeout connect 10000
    timeout client 300000
    timeout server 300000

listen seafile
    bind :80
    bind :443 ssl crt /etc/haproxy/demo.pem
    redirect scheme https if !{ ssl_fc }
    mode http
    option httplog
    option dontlognull
    option forwardfor
    cookie SERVERID insert indirect nocache
    server seafileserver01 <ip of frontend node1>:80 check port 12345 cookie seafileserver01
    server seafileserver02 <ip of frontend node2>:80 check port 12345 cookie seafileserver02
```

## 修改 nginx 配置
在前端seafile服务器节点上（即node B 和 node C）的nginx配置中添加两行配置到 `location /` 代码块中： `vim /etc/nginx/conf.d/seafile.conf`

```
proxy_set_header   X-Forwarded-Proto https;
```

配置示例：

```
location / {
    proxy_pass         http://127.0.0.1:8000;
    proxy_set_header   Host $host;
    proxy_set_header   X-Real-IP $remote_addr;
    proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header   X-Forwarded-Host $server_name;
    proxy_set_header   X-Forwarded-Proto https;
    proxy_read_timeout  1200s;
        ...
```

重新加载nginx配置：

```
nginx -s reload
```
